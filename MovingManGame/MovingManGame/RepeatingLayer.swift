//
//  RepeatingLayer.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/15/21.
//

import SpriteKit

class RepeatingLayer: Layer { //subclass of layer class
    
    override func updateNodes(_ delta: TimeInterval, childNode: SKNode) { //check if chil node move so much to left so that is not visible
        if let node = childNode as? SKSpriteNode {
            if node.position.x <= -(node.size.width) {
                if node.name == "0" && self.childNode(withName: "1") != nil || node.name == "1" && self.childNode(withName: "0") != nil {
                    node.position = CGPoint(x: node.position.x + node.size.width*2, y: node.position.y) //move it to right by doubling it's width.(for x position)
                }
            }
        }
    }
    
}
