//
//  ShakeViewController.swift
//  missfit
//
//  Created by Hank Liang on 8/1/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit
import AVFoundation

class ShakeViewController: UIViewController {
    @IBOutlet weak var categoryLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sexLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var areaLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headCountLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var learningPhaseLineHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var headCountLabel: UILabel!
    @IBOutlet weak var learningPhaseLabel: UILabel!
    
    var isRequesting = false
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        sexLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        areaLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        headCountLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        learningPhaseLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        
        categoryLabel.text = ""
        sexLabel.text = ""
        areaLabel.text = ""
        headCountLabel.text = ""
        learningPhaseLabel.text = ""
    }


    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func categoryClicked(sender: AnyObject) {
        let dataPicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MultiSelectionViewController") as! MultiSelectionViewController
        dataPicker.components = ["瑜伽", "舞蹈", "健身"]
        dataPicker.onComponentsSelected = {(results: String) in
            self.categoryLabel.text = results
        }
        dataPicker.title = "我想组队练"
        self.navigationController?.pushViewController(dataPicker, animated: true)
    }
    
    @IBAction func sexClicked(sender: AnyObject) {
        let dataPicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MultiSelectionViewController") as! MultiSelectionViewController
        dataPicker.onlySupportSingleSelection = true
        dataPicker.components = ["男神", "女神", "秘密"]
        dataPicker.onComponentsSelected = {(results: String) in
            self.sexLabel.text = results
        }
        dataPicker.title = "我是"
        self.navigationController?.pushViewController(dataPicker, animated: true)
    }
    
    @IBAction func areaClicked(sender: AnyObject) {
    }
    
    @IBAction func headCountClicked(sender: AnyObject) {
        let dataPicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MultiSelectionViewController") as! MultiSelectionViewController
        dataPicker.onlySupportSingleSelection = true
        dataPicker.components = ["1-2人（预估200元/次）", "3-4人（预估80元/次）", "5-6人（预估60元/次）"]
        dataPicker.onComponentsSelected = {(results: String) in
            self.headCountLabel.text = results
        }
        dataPicker.title = "人数价格"
        self.navigationController?.pushViewController(dataPicker, animated: true)
    }
    
    @IBAction func learningPhaseClicked(sender: AnyObject) {
        let dataPicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MultiSelectionViewController") as! MultiSelectionViewController
        dataPicker.onlySupportSingleSelection = true
        dataPicker.components = ["初级", "中级", "高级"]
        dataPicker.onComponentsSelected = {(results: String) in
            self.learningPhaseLabel.text = results
        }
        dataPicker.title = "学习阶段"
        self.navigationController?.pushViewController(dataPicker, animated: true)
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion != UIEventSubtype.MotionShake {
            return
        }
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion != UIEventSubtype.MotionShake {
            return
        }
        
        
        if !isRequesting {
            if player == nil {
                let url = NSBundle.mainBundle().URLForResource("shake", withExtension: "mp3")
                if url == nil {
                    return
                }
                
                player = AVAudioPlayer(contentsOfURL: url, error: nil)
            }
            
            if !player!.prepareToPlay() {
                return
            }
            
            if !player!.playing {
                println("player.play()")
                player!.play()
            }
        }
    }
    
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion != UIEventSubtype.MotionShake {
            return
        }
        println("motionCancelled")
    }
    
}
