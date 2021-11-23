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
            let component = name.components(separatedBy: NSCharacterSet.decimalDigits.inverted) // to take the numbers in the name
            if let rows = Int(component[0]), let columns = Int(component[1]) {
                calculateGridWith(rows: rows, columns: columns, parent: sprite)
            }
        }
    }
    
    static func calculateGridWith(rows: Int, columns:Int, parent: SKSpriteNode) {
        
    }
    
    static func addCoin(to parent: SKSpriteNode, at position: CGPoint, columns: Int) {
        
    }
    
}
