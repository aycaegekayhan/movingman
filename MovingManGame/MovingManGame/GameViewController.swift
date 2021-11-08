//
//  GameViewController.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/3/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true //child nodes within scene dont need to be rendered hierarchically, better perf. for gain
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

   
}
