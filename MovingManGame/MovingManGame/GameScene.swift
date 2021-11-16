//
//  GameScene.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/3/21.
//

import SpriteKit

enum GameState {
    case ready, ongoing, paused, finished
}

class GameScene: SKScene {
    
    var worldLayer: Layer!
    var backGroundLayer = RepeatingLayer!
    var mapNode : SKNode!
    var tileMap :SKTileMapNode!
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var gameState = GameState.ready
    
    override func didMove(to view: SKView) {
        createLayers()
    }
    
    func createLayers() {
        worldLayer = Layer()
        addChild(worldLayer)
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        
        backGroundLayer = RepeatingLayer()
        addChild(backGroundLayer) //adding direct child to our game scene
        
        for i in 0...1 { // for loop will run twice
            let backgroundImage = SKSpriteNode(imageNamed: "DesertBackground")
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0) //scale the background to screen
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundImage.size.width, y: 0.0)
            backGroundLayer.addChild(backgroundImage)
        }
        
        backGroundLayer.layerVelocity = CGPoint(x: -100.0, y: 0.0)
        
        load(level: "First Level")
    }
    
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFroFile(file: level) {
            mapNode = levelNode
            worldLayer.addChild(mapNode) // to add map to game
            loadTileMap() // scale is correct, tile map visible on the screen
        }
    }
    
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: "Ground Tiles") as? SKTileMapNode{ // if get a value for ground tiles it will be sktilemapnode
            tileMap = groundTiles
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0) //frame.size -> entire size of the sceene, adjust the size according to size
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //called when there is a touch on the screen
        switch gameState {
        case .ready:
            gameState = .ongoing // if clicked on the screen when game state is ready
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { // touch of the screen stops
        <#code#>
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { // touch of the screen stops
        <#code#>
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime > 0 {
            dt = currentTime - lastTime
        } else {
            dt = 0
        }
        lastTime = currentTime
        
        if gameState == .ongoing { // only move the map if the game has begun
            worldLayer.update(dt)
            backGroundLayer.update(dt)
        }
        
    }
}
