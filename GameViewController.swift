//
//  GameViewController.swift
//  shrink2
//
//  Created by Shant Narkizian on 8/18/17.
//  Copyright © 2017 Shant Narkizian. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import GameKit



class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var googleBannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateP()
        
        // displays google ads
        googleBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        
        googleBannerView.adUnitID = "ca-app-pub-6175087177570433/4230330539"
        
        googleBannerView.rootViewController = self
        let request: GADRequest = GADRequest()
        googleBannerView.load(request)
        
        googleBannerView.frame = CGRect(x: 0, y: view.bounds.height - googleBannerView.frame.size.height, width:  googleBannerView.frame.size.width, height: googleBannerView.frame.size.height)
        
        
        self.view.addSubview(googleBannerView!)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false 
        }
    }
    
    func authenticateP(){
        let localP = GKLocalPlayer.localPlayer()
        
        localP.authenticateHandler = {
            (view, error) in
            
            if view != nil{
                
                self.present(view!, animated: true, completion: nil)
                
            }else{
                print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
        }
    }
        
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
