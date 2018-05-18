//
//  Play.swift
//  shrink2
//
//  Created by Shant Narkizian on 8/18/17.
//  Copyright © 2017 Shant Narkizian. All rights reserved.
//

import SpriteKit
import GameplayKit

extension CGPoint {
    func distanceTo(_ p:CGPoint) -> CGFloat {
        return sqrt(pow((p.x - x), 2) + pow((p.y - y), 2))
    }
}


class Play: SKScene {
    
    var Circle = SKSpriteNode()
    var Circle2 = SKSpriteNode()
    let scoreText = SKLabelNode()
    var GCircle = SKSpriteNode()
    var RCircle = SKSpriteNode()
    var pause = SKSpriteNode()
    var pause1 = SKSpriteNode()
    var screen = SKSpriteNode()
    
    var run1 = false
    var called = true
    var called2 = false
    var intersected = false
    var initialsize = 80
    var durtimer: Double = 0
    var halt: Bool = false
    var par: Bool = false
    
    var twice: Bool = false
    
    let sound2 = SKAction.playSoundFileNamed("lost.wav", waitForCompletion: false)
    var duration = 3.0
    
    override func didMove(to view: SKView) {
        LoadView() 
    }
    
    func LoadView(){
        score = 0
        self.backgroundColor = UIColor.white
        Circle = SKSpriteNode(imageNamed: "Circle")
        Circle.size = CGSize(width: 80, height: 80)
        Circle.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(Circle)
        Circle2 = SKSpriteNode(imageNamed: "Circle2")
        Circle2.size = CGSize(width: 760, height: 760)
        Circle2.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(Circle2)
        Circle.zPosition = 0.1
        Circle2.zPosition = 0.2
        callCircle2()
        called = true
        
        self.scoreText.fontName = "STFangsong"
        self.scoreText.text = "\(score)"
        self.scoreText.fontSize = 100
        self.scoreText.position = CGPoint(x:310, y:585)
        self.scoreText.fontColor = UIColor.black
        self.addChild(scoreText)
        scoreText.zPosition = 0.3
        
        pause = SKSpriteNode(imageNamed: "pause")    //pause symbol
        pause.size = CGSize(width: 80, height: 80)
        pause.position = CGPoint(x: -325, y: 620)
        pause.zPosition = 0.9
        self.addChild(pause)
        
        
        pause1 = SKSpriteNode(imageNamed: "pause1")  //this is the text "pause"
        pause1.size = CGSize(width: 400, height: 400)
        pause1.position = CGPoint(x: 15, y: 400)
        pause1.zPosition = 1.1
        
        screen = SKSpriteNode(imageNamed: "screen")
        screen.size = CGSize(width: 100000, height: 100000)
        screen.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        screen.zPosition = 1     
    }
    
    
    
    func scaleCircle2(){
        let scaleAction2 = SKAction.scale(to: CGSize(width: 760, height: 760), duration: TimeInterval(duration))
        let scaleAction = SKAction.scale(to: CGSize(width: 3, height: 3), duration: TimeInterval(duration))
        let pulse = SKAction.sequence([scaleAction,scaleAction2])
        let forever = SKAction.repeatForever(pulse)
        Circle2.run(forever)      
    }
    
    func scaleCircle1(){
        let duration2 = 0.5
        let scaleAction3 = SKAction.scale(to: CGSize(width: initialsize, height: initialsize), duration: TimeInterval(duration2))
        Circle.run(scaleAction3)        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if Circle2.size.width > 750  {
            called2 = false
            called = true
            callCircle2()
        }
        if Circle.size.width < 9{    // game has ended
            run(sound2)
            endGame()
        }
        
        self.scoreText.text = "\(score)"

        if Circle2.size.width > Circle.size.width{
            twice = false
        }
    }
    
    
    var cl = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   //par & halt start at false
        let touch = touches.first!                  //pauses the game
        if pause.contains(touch.location(in: self)){
            if cl == true{
                Circle2.isPaused = true
                self.addChild(pause1)
                self.addChild(screen)
                halt = true
            }
            cl = false
        }else{
            Circle2.isPaused = false
            pause1.removeFromParent()
            screen.removeFromParent()
            cl = true
        }
        
     //  let touchy = touches.first!
     //   if screen.contains(touchy.location(in: self)){
     //       Circle2.isPaused = false
     //       pause1.removeFromParent()
     //       screen.removeFromParent()
     //       halt = true
     //       par = true
            
     //   }
        
        if halt == false{
            inOrOut()
        }else{
            par = true
        }
        halt = false
    }
    
    func inOrOut(){
        
        let sound = SKAction.playSoundFileNamed("point.wav", waitForCompletion: false)
        let sound1 = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)

        let size2 = Circle2.size.width
        let size = Circle.size.width
        if par == false{
            if size2 <= size{                               // doesn't allow multiple taps
                print("moving circle is inside")
                if twice == false{
                    initialsize += 5
                    print("dot =", initialsize)
                    score = score + 1
                    callscaleCircle1()
                    flashG()
                    run(sound)
                }
                twice = true
                print("duration =", duration)         
            }
            if size2 > size{
                print("moving circle is outside")
                flashR()
                initialsize -= 20
                run(sound1)
                scaleCircle1()    
            }
        }
        par = false        
    }
    
    func callCircle2(){    //makes sure scaleCircle2 isn't called twice
        if called == true{
            scaleCircle2()
        }
        called = false
    }
    
    func callscaleCircle1(){  //makes sure scaleCircle1() isnt called until scaleCircle2() is complete
        if called2 == false{
            durtimer += 0.20
            duration = ((durtimer + 3) / (pow(durtimer, 2) + 1))

            if initialsize <= 119{    // sets max size for Circle1
                scaleCircle1()
            }else{
               // initialsize -= 5
                initialsize = 120
                print("now dot =", initialsize)
            }
            called2 = true
        }
    }
    
    func endGame(){
        self.removeAllChildren()
        let action1 = SKAction.colorize(with: UIColor.red, colorBlendFactor:  1.0, duration: 0.2)
        let action2 = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 0.2)
        let pulse = SKAction.sequence([action1, action2])
        let pulseThreeTimes = SKAction.repeat(pulse, count: 2)
        self.scene?.run(pulseThreeTimes)
        let nextscene = GameOver(fileNamed: "GameOver")
        nextscene?.scaleMode = .aspectFill
        self.view?.presentScene(nextscene!)
    }
    
    func flashG(){                                              // flash green Circle
        GCircle = SKSpriteNode(imageNamed: "GCircle")
        GCircle.size = CGSize(width: initialsize, height: initialsize)
        GCircle.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        let put = SKAction.run({()in self.apparation()})
        let wait = SKAction.wait(forDuration: 0.1)
        let delete = SKAction.run({() in self.remove()})
        self.run(SKAction.sequence([put, wait, delete]))
        
        
    }
    
    func apparation(){
        GCircle.zPosition = 0.4
        self.addChild(GCircle)
    }
    func remove(){
        GCircle.removeFromParent()
    }

    func flashR(){                                          // flash red Circle
        RCircle = SKSpriteNode(imageNamed: "RCircle")
        RCircle.size = CGSize(width: initialsize + 5, height: initialsize + 5)
        RCircle.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        let put = SKAction.run({()in self.apparation2()})
        let wait = SKAction.wait(forDuration: 0.1)
        let delete = SKAction.run({() in self.remove2()})
        self.run(SKAction.sequence([put, wait, delete]))        
    }
    
    func apparation2(){
        RCircle.zPosition = 0.4
        self.addChild(RCircle)
    }
    func remove2(){
        RCircle.removeFromParent()
    } 
}
