//
//  GroundNode.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/16/21.
//

import SpriteKit

class GroundNode: SKSpriteNode {
    
    var isBodyActivated: Bool = false {
        didSet {
            physicsBody = isBodyActivated ? activatedBody : nil //check nodes physics body to see if it is active, if player below a platform remove its physicsbody
        }
    }
    
    private var activatedBody: SKPhysicsBody?
    
    init(with size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size) // not see the node -> clear
        let bodyInitialPoint = CGPoint(x: 0.0, y: size.height)//two points one for left one for right edge of the platform
        let bodyEndPoint = CGPoint(x: size.width, y: size.height) // physics body of the platform if it is active
        
        activatedBody = SKPhysicsBody(edgeFrom: bodyInitialPoint, to: bodyEndPoint)
        activatedBody!.restitution = 0.0 // prevent bouncing
        
        physicsBody = isBodyActivated ? activatedBody : nil
        name = GameConstants.StringConstants.groundNodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
