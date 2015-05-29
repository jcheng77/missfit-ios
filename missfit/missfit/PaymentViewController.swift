//
//  PaymentViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/19/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

enum PayMethods {
    case Alipay, Wepay
}

class PaymentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var orderId: String?
    var currentPayMethod: PayMethods = .Alipay
    var validThrough: String?
    var memberFee: String?
    var settingsController: SettingsViewController?
    var finalPrice: Float = 0.01
    
    var kPaymentContentCellIndex = 0
    var kPaymentCouponCellIndex = 1
    var kPaymentActualPriceCellIndex = 2
    var kPaymentActionCellIndex = 3
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func alipayButtonClicked(sender: AnyObject) {
        println("call alipayButtonClicked in PaymentViewController")
    }
    
    @IBAction func wepayButtonClicked(sender: AnyObject) {
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // request for the orderId
        submitOrder()
        
        // Now we don't need the coupon cell
        kPaymentActualPriceCellIndex = 1
        kPaymentActionCellIndex = 2
        kPaymentCouponCellIndex = -1
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("paySucceededCallback"), name: MissFitAlipaySucceededCallback, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPayment(sender: AnyObject) {
        let bodyString = "美人瑜月卡"
        self.pay("订金支付", body: bodyString, price: NSNumber(float: self.finalPrice).stringValue)
    }
    
    func paySucceededCallback() {
        self.settingsController?.loadMembership()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func pay(subject: String, body: String, price: String) {
        var orderSpec = AliPayUtils.getOrderInfo(subject, body: body, price: price, orderId: self.orderId!)
        var orderString = AliPayUtils.sign(orderSpec)
        if orderString != nil {
            AlipaySDK.defaultService().payOrder(orderString!, fromScheme: "missfit.yoga", callback: { (resultDictionary) -> Void in
                let result = resultDictionary as NSDictionary
                let resultsStatus = result["resultStatus"] as! String
                if resultsStatus == "9000" {
                    KVNProgress.showSuccessWithStatus("支付成功")
                    self.paySucceededCallback()
                } else {
                    if resultsStatus == "8000" {
                        KVNProgress.showWithStatus("支付结果确认中")
                        KVNProgress.dismiss()
                    } else {
                        KVNProgress.showErrorWithStatus("支付失败")
                    }
                }
            })
        }
    }
    
    func parseResponseObject(responseObject: NSDictionary) {
        // responseObject:{
        //data = 4r9gTYWZo33CtpksN;
        //status = success;
        //}
        let json = JSON(responseObject)
        self.orderId = json["data"].stringValue
        println("orderId:\(self.orderId)")
    }
    
    func submitOrder() {
        // POST /orders (需登陆) {"subject":"订单标题，比如美人鱼月费"//也可以考虑由服务器端统一指定, total_fee:"金额，不填则是199", price: 199//可不填, quantity: 1//可不填}
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitOrdersURI
        let params = ["subject": "美人瑜月卡", "total_fee": finalPrice, "price": finalPrice, "quantity": 1]
        KVNProgress.show()
        manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
        manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
        manager.POST(endpoint, parameters: params, success: { (operation, responseObject) -> Void in
            KVNProgress.dismiss()
            // Parse data
            self.parseResponseObject(responseObject as! NSDictionary)
            }) { (operation, error) -> Void in
                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                    // Need to get the status and message
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                    let message: String? = json["message"].string
                    KVNProgress.showErrorWithStatus(message)
                } else {
                    KVNProgress.showErrorWithStatus("创建订单失败")
                }
                self.navigationController?.popViewControllerAnimated(true)
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kPaymentActionCellIndex + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == kPaymentContentCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("PaymentContentTableViewCell", forIndexPath: indexPath) as! PaymentContentTableViewCell
            cell.validThrough.text = validThrough
            cell.price.text = self.memberFee
            cell.needToPay.text = self.memberFee
            return cell
        } else if indexPath.row == kPaymentCouponCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("PaymentCouponTableViewCell", forIndexPath: indexPath) as! PaymentCouponTableViewCell
            return cell
        } else if indexPath.row == kPaymentActualPriceCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("PaymentActualPriceTableViewCell", forIndexPath: indexPath) as! PaymentActualPriceTableViewCell
            cell.actualPrice.text = self.memberFee
            finalPrice = (cell.actualPrice.text! as NSString).floatValue
            return cell
        } else if indexPath.row == kPaymentActionCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("PaymentActionTableViewCell", forIndexPath: indexPath) as! PaymentActionTableViewCell
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == kPaymentContentCellIndex {
            return 181.0
        } else if indexPath.row == kPaymentActionCellIndex {
            // iPhone 4S
            if MissFitUtils.longestScreenWidth() <= 480.0 {
                return 197.0
            } else {
                return 217.0
            }
        } else {
            return 44.0
        }
    }


}
