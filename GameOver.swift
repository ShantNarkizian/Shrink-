//
//  GameOver.swift
//  shrink2
//
//  Created by Shant Narkizian on 8/18/17.
//  Copyright © 2017 Shant Narkizian. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit


class GameOver: SKScene, GKGameCenterControllerDelegate{
    
    
    var button1 = SKSpriteNode()
    var button2 = SKSpriteNode()
    var button3 = SKSpriteNode()
    var button4 = SKSpriteNode()
    let scoreText = SKLabelNode()
    let replay = SKLabelNode()
    let share = SKLabelNode()
    let GC = SKLabelNode()
    
    override func didMove(to view: SKView) {
        let action1 = SKAction.colorize(with: UIColor.red, colorBlendFactor:  1.0, duration: 0.2)
        let action2 = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 0.2)
        let pulse = SKAction.sequence([action1, action2])
        let pulseThreeTimes = SKAction.repeat(pulse, count: 1)
        self.scene?.run(pulseThreeTimes)
        
        self.backgroundColor = UIColor.white
        
        button1 = SKSpriteNode(imageNamed: "button")
        button1.size = CGSize(width: 500, height: 500)
        button1.position = CGPoint(x: 0, y: 200)
        button1.zPosition = 0.1
        self.addChild(button1)
        
        button2 = SKSpriteNode(imageNamed: "button2")
        button2.size = CGSize(width: 500, height: 500)
        button2.position = CGPoint(x: 0, y: -45)
        button2.zPosition = 0.1
        self.addChild(button2)
        
        button3 = SKSpriteNode(imageNamed: "button2")
        button3.size = CGSize(width: 500, height: 500)
        button3.position = CGPoint(x: 0, y: -200)
        button3.zPosition = 0.1
        self.addChild(button3)
        
        button4 = SKSpriteNode(imageNamed: "button2")
        button4.size = CGSize(width: 500, height: 500)
        button4.position = CGPoint(x: 0, y: -355)
        button4.zPosition = 0.1
        self.addChild(button4)
        
        self.scoreText.fontName = "STFangsong"
        self.scoreText.text = "\(score)"
        self.scoreText.fontSize = 200
        self.scoreText.position = CGPoint(x: 0, y:175)
        self.scoreText.fontColor = UIColor.white
        self.addChild(scoreText)
        scoreText.zPosition = 0.2
        
        self.replay.fontName = "STFangsong"
        self.replay.text = "REPLAY"
        self.replay.fontSize = 80
        self.replay.position = CGPoint(x: 0, y:13)
        self.replay.fontColor = UIColor.white
        self.addChild(replay)
        replay.zPosition = 0.2
        
        self.share.fontName = "STFangsong"
        self.share.text = "SHARE"
        self.share.fontSize = 80
        self.share.position = CGPoint(x: 0, y:-140)
        self.share.fontColor = UIColor.white
        self.addChild(share)
        share.zPosition = 0.2
        
        self.GC.fontName = "STFangsong"
        self.GC.text = "LEADERBOARDS"
        self.GC.fontSize = 50
        self.GC.position = CGPoint(x: 0, y:-283)
        self.GC.fontColor = UIColor.white
        self.addChild(GC)
        GC.zPosition = 0.2

        
        if score > highscore {
            highscore = score
        }
        
        let highscoreDefault = UserDefaults.standard
        highscoreDefault.set(highscore, forKey: "highscore")
        highscoreDefault.synchronize()
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var push = false
        
        let touch = touches.first!
        if replay.contains(touch.location(in: self)){
            push = true
        }
        
        if push == true{
            let Next = GameScene(fileNamed: "GameScene")
            Next?.scaleMode = .aspectFill
            self.view?.presentScene(Next!)
        }
        
        let touch2 = touches.first!
        if share.contains(touch2.location(in: self)){

            let textToShare = "i just scored \(score) points in shrink! Try to beat me!"
            
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
            
            currentViewController.present(activityVC, animated: true, completion: nil)
        }
        
     let touch3 = touches.first!
        if GC.contains(touch3.location(in: self)){
        saveHS(number: highscore)
        showLeader()
        }
        
    }
    
    
    func saveHS(number: Int){
        
        if GKLocalPlayer.localPlayer().isAuthenticated{
            let scoreReport = GKScore(leaderboardIdentifier: "SHRINK")
            
            scoreReport.value = Int64(number)
            let scoreArray : [GKScore] = [scoreReport]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
        
    }
    
    func showLeader(){
        let viewController = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        
        gc.gameCenterDelegate = self 
        
        viewController?.present(gc, animated: true, completion: nil)
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
 
    
    
}
