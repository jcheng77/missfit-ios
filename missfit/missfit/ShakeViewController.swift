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
    }


    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func categoryClicked(sender: AnyObject) {
    }
    
    @IBAction func sexClicked(sender: AnyObject) {
    }
    
    @IBAction func areaClicked(sender: AnyObject) {
    }
    
    @IBAction func headCountClicked(sender: AnyObject) {
    }
    
    @IBAction func learningPhaseClicked(sender: AnyObject) {
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
