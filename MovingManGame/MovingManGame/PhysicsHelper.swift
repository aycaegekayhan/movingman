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
        let tileSize = tileMap.tileSize // how big the tiles in the map
        
        for row in 0..<tileMap.numberOfRows {
            var tiles = [Int]() //created an integer array, to save all the indexes of tiles which is labeled as ground tile
            for col in 0..<tileMap.numberOfColumns {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isUsedTile = tileDefinition?.userData?[tileInfo] as? Bool
                if (isUsedTile ?? false) {
                    tiles.append(1)
                } else {
                    tiles.append(0)
                }
            }
            if tiles.contains(1) {
                var platform = [Int]()
                for (index, tile) in tiles.enumerated() {
                    if tile == 1 && index < (tileMap.numberOfColumns - 1) {
                        platform.append(index)
                    } else if !platform.isEmpty {
                        print(platform)
                        platform.removeAll()
                    }
                    
                }
            }
        }
    }
    
}
