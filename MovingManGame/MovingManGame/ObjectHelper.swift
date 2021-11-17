//
//  ObjectHelper.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/16/21.
//

import SpriteKit

class ObjectHelper {
    
    static func handleChild(sprite: SKSpriteNode, with name: String) {
        switch name {
        case GameConstants.StringConstants.finishLineName, GameConstants.StringConstants.enemyName:
            PhysicsHelper.addPhysicsBody(to: sprite, with: name)
        default:
            break
        }
    }
    
}
