//
//  GameScene.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/3/21.
//

import SpriteKit

class GameScene: SKScene {
    
    var mapNode : SKNode!
    var tileMap :SKTileMapNode!
    
    override func didMove(to view: SKView) {
        load(level: "First Level")
        
    }
    
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFroFile(file: level) {
            mapNode = levelNode
            addChild(mapNode) // to add map to game
            loadTileMap() // scale is correct, tile map visible on the screen
        }
    }
    
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: "Ground Tiles") as? SKTileMapNode{ // if get a value for ground tiles it will be sktilemapnode
            tileMap = groundTiles
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0) //frame.size -> entire size of the sceene, adjust the size according to size
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
