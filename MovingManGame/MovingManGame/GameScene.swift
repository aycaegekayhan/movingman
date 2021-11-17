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
    var backGroundLayer: RepeatingLayer!
    var mapNode : SKNode!
    var tileMap :SKTileMapNode!
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
            case .finished:
                player.state = .idle
            default:
                break
            }
        }
    }
    
    var player: Player!
    
    var touch = false
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        
        createLayers()
    }
    
    func createLayers() {
        worldLayer = Layer()
        worldLayer.zPosition = GameConstants.ZPositions.worldZ
        addChild(worldLayer)
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        
        backGroundLayer = RepeatingLayer()
        backGroundLayer.zPosition = GameConstants.ZPositions.farBGZ
        addChild(backGroundLayer) //adding direct child to our game scene
        
        for i in 0...1 { // for loop will run twice
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundNames[0])
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
        if let groundTiles = mapNode.childNode(withName: GameConstants.StringConstants.groundTilesName) as? SKTileMapNode{ // if get a value for ground tiles it will be sktilemapnode
            tileMap = groundTiles
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0) //frame.size -> entire size of the sceene, adjust the size according to size
            PhysicsHelper.addPhysicBody(to: tileMap, and: "ground") // specify the user data info
        }
        
        addPlayer() //load level -> load tile map -> load player
        
    }
    
    func addPlayer() {
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        player.name = GameConstants.StringConstants.playerName
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX/2.0, y: frame.midY) // position the player in the first quadrant of the screen
        player.zPosition = GameConstants.ZPositions.playerZ
        player.loadTextures() //to load the frames
        player.state = .idle
        addChild(player)
        addPlayerActions()
    }
    
    func addPlayerActions() {
        let up = SKAction.moveBy(x: 0.0, y: frame.size.height/4, duration: 0.4) //jump quarter of the screens height
        up.timingMode = .easeOut // action slow down towards the end
        
        player.createUserData(entry: up, forKey: GameConstants.StringConstants.jumpUpActionKey)
    }
    
    func jump() { //function to make player actually jump
        player.airborne = true // make the player unable to jump more
        player.turnGravity(on: false)
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction) {
            if self.touch { //to make the double jump
                self.player.run(self.player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction, completion: {
                    self.player.turnGravity(on: true)
                })
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //called when there is a touch on the screen
        switch gameState {
        case .ready:
            gameState = .ongoing // if clicked on the screen when game state is ready
        case .ongoing: //when game runs jump everytime tapped as long as game state is ongoing and airborne is false
            touch = true
            if !player.airborne {
                jump()
            }
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { // touch of the screen stops
        touch = false
        player.turnGravity(on: true)
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { // touch of the screen stops
        touch = false
        player.turnGravity(on: true)
        
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
    
    override func didSimulatePhysics() {
        //track position of the player
        for node in tileMap[GameConstants.StringConstants.groundNodeName] {
            if let groundNode = node as? GroundNode { //check if there is a ground node
                let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale // top edge of the ground node
                let playerY = player.position.y - player.size.height/3 //minimal space between player and ground
                groundNode.isBodyActivated = playerY > groundY // y position of the player bigger than y position of the ground physics body gets activated
                
            }
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) { //called when the contact begins
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask // get 2 bodies of two nodes having contact, then create a contact mask
        
        switch contactMask {
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory: // contact between player and ground
            player.airborne = false
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) { // called when contact ends
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
            player.airborne = true // if player falls it will not be able to jump
        default:
            break
        }
    }
}
