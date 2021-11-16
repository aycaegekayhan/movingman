//
//  PhysicsHelper.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/16/21.
//

import SpriteKit

class PhysicsHelper {
    static func addPhysicsBody(to sprite: SKSpriteNode, with name: String) {
        
        switch name { //to check which node
        case GameConstants.StringConstants.playerName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width/2, height: sprite.size.height)) //cretated a rectangle for physics body
            sprite.physicsBody!.restitution = 0.0 // player will not bounce back when it hits another physics body
            sprite.physicsBody!.allowsRotation = false // player will stay staright up
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size) // add generic rectangle size
        }
    }
    
    static func addPhysicBody(to tileMap: SKTileMapNode, and tileInfo: String) {
        
    }
    
}
