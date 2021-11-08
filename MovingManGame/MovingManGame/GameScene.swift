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
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
