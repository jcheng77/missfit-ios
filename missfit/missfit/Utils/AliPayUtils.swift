//
//  AliPayUtils.swift
//  Auto2o
//
//  Created by Hank Liang on 12/28/14.
//  Copyright (c) 2014 Hank Liang. All rights reserved.
//

import Foundation

class AliPayUtils {
    class func defaultPartner() -> String {
        return "2088511841967594"
    }
    
    class func defaultSeller() -> String {
        return "auto2o@outlook.com"
    }
    
    class func privateKey() -> String {
        return "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKl5EBi60MoIkSQmZyIljQquA45JhAkamGC2nwN9dZBnqcWmiPh5M1//kQ/6XB4eUVOTh4pHCxoNkuT19F/6WRNF1QNP3fiGt/q50Jwgmet+4GsUTWFD1wSThS6eCOkLQCppgT5e5kUddvQESV299YgeOSEIyVY0eka+dlHlTOSpAgMBAAECgYAiN384fv+IyxIC6n4INuyzK08se0tdSzFY1YZlff8umL9+WJFvGYl16HOxdisDKbvh0/eZw55KNFNkRwSAHFu/ZAboQnuUOLwHw615WgoK/gVx4henohVGP1HJpeg/WSgZbU/3sAloWrD/ovU8vV9KdH+9kT0aTBQ5acZfkXZoAQJBAOHq4dvYPeKVZMEeDxgJTEPQmg3kVNa3/H6tX7IaILCgLS1TknOGKErAVxm+OpZvz9hWJyTk+wa2COcxKJjO11ECQQDAChYgra+5LgeVOs/AX52G5Mpg7LrTVVoGI3mlUW2gv9K4vxCGIWuuAVMqhs83E6csnZir91NDJ4Bu9H8z7BHZAkALpQGzRTgbX7vrwFLi2EfYDv6BzM0arC0VknYmRfZ9ZCQv++jGj5mwEK3so8N9UZITAo3N9weBVwyqbfw7tB2hAkBq+vN6vuc+lNrakkm71EgwJnJrblVhd5HQC6EvrF4TB+l+y8mLv0B6Tfijnzf+aa9elmi/m+dBaNcOeJwIM8F5AkBBYxuyA602joM7AzqB7p5raJwCNM3fvG2FCzZBvhXSXqfqohjiMhkZHfoM+5xPpVA+aIO3hi2zJWklSaX3MA//"
    }
    
    class func publicKey() -> String {
        return "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"
    }
    
    class func getOrderInfo(subject: String, body: String, price: String, orderId: String) -> String {
        // 合作者身份ID
        var orderInfo = "partner=" + "\"" + self.defaultPartner() + "\""
        
        // 卖家支付宝账号
        orderInfo += "&seller_id=" + "\"" + self.defaultSeller() + "\""
        
        // 商户网站唯一订单号
        orderInfo += "&out_trade_no=" + "\"" + self.getOutTradeNo(orderId) + "\""
        
        // 商品名称
        orderInfo += "&subject=" + "\"" + subject + "\""
        
        // 商品详情
        orderInfo += "&body=" + "\"" + body + "\""
        
        // 商品金额
        orderInfo += "&total_fee=" + "\"" + price + "\""
        
        // 服务器异步通知页面路径
        orderInfo += "&notify_url=" + "\"" + MissFitBaseURL + MissFitPaymentCallbackURI
            + "\"";
        
        // 接口名称， 固定值
        orderInfo += "&service=\"mobile.securitypay.pay\""
        
        // 支付类型， 固定值
        orderInfo += "&payment_type=\"1\""
        
        // 参数编码， 固定值
        orderInfo += "&_input_charset=\"utf-8\""
        
        // 设置未付款交易的超时时间
        // 默认30分钟，一旦超时，该笔交易就会自动被关闭。
        // 取值范围：1m～15d。
        // m-分钟，h-小时，d-天，1c-当天（无论交易何时创建，都在0点关闭）。
        // 该参数数值不接受小数点，如1.5h，可转换为90m。
        orderInfo += "&it_b_pay=\"1m\""
        
        // 支付宝处理完请求后，当前页面跳转到商户指定页面的路径，可空
        orderInfo += "&show_url=\"m.alipay.com\""
        
        // 调用银行卡支付，需配置此参数，参与签名， 固定值
        // orderInfo += "&paymethod=\"expressGateway\"";
        
        return orderInfo
    }
    
    class func getOutTradeNo(tenderID: String) -> String {
        return tenderID
    }
    
    class func sign(orderSpec: String) -> String? {
        var signer = CreateRSADataSigner(self.privateKey())
        var signedString = signer.signString(orderSpec)
        var orderString: String? = nil
        if signedString != nil {
            orderString = String(format: "%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, "RSA")
        }
        return orderString
    }
}