//
//  GameScene.swift
//  shrink2
//
//  Created by Shant Narkizian on 8/18/17.
//  Copyright © 2017 Shant Narkizian. All rights reserved.
//

import SpriteKit
import GameplayKit


var score = 0   // score for whole game
var highscore = 0

class GameScene: SKScene {
    
    
    let PlayButton = SKSpriteNode(imageNamed: "play")
    let bestscore = SKLabelNode()
    
    
    
    
    override func didMove(to view: SKView) {
        self.PlayButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        PlayButton.size = CGSize(width: 600, height: 600)
        self.addChild(PlayButton)
        self.backgroundColor = UIColor.white
        
        
        
        let highscoreDefault = UserDefaults.standard            //saves high score to core data
        
        if (highscoreDefault.value(forKey: "highscore") != nil){
            highscore = highscoreDefault.value(forKey: "highscore") as! NSInteger!
        }

        
        self.bestscore.fontName = "Helvetica Neue UltraLight"
        self.bestscore.text = "\(highscore)"
        self.bestscore.fontSize = 100
        self.bestscore.position = CGPoint(x: 0, y: -530)
        self.bestscore.fontColor = UIColor.black
        self.addChild(bestscore)
        bestscore.zPosition = 0.1
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var change = false
        
        
        let touch = touches.first!
        if PlayButton.contains(touch.location(in: self)){
            print("touched")
            change = true
        }
        
        if change == true{
            let NewScene = Play(fileNamed: "Play")
            NewScene?.scaleMode = .aspectFill
            self.view?.presentScene(NewScene!)
        }
        
    }
    
}





