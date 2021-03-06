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
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.playerCategory
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.groundCategory | GameConstants.PhysicsCategories.finishCategory // to collide with the finish line
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.allCategory // check the players contact with the other elements of the game
        case GameConstants.StringConstants.finishLineName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.finishCategory
        case GameConstants.StringConstants.enemyName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.enemyCategory
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size) // add generic rectangle size
        }
        
        if name != GameConstants.StringConstants.playerName {
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory //checking contact with player
            sprite.physicsBody!.isDynamic = false // to make physics bodies stay in their place
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
                        //position of ground node
                        let x = CGFloat(platform[0]) * tileSize.width //first index of the platform * width of tiles
                        let y = CGFloat(row) * tileSize.height
                        let tileNode = GroundNode(with: CGSize(width: tileSize.width * CGFloat(platform.count), height: tileSize.height))
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.anchorPoint = CGPoint.zero
                        tileMap.addChild(tileNode)
                        platform.removeAll()
                        
                    }
                    
                }
            }
        }
    }
    
}
