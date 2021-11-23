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
    var tileMap : SKTileMapNode!
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
                pauseEnemies(bool: false)
            case .finished:
                player.state = .idle
                pauseEnemies(bool: true) // enemies will stop their actions
            default:
                break
            }
        }
    }
    
    var player: Player!
    
    var touch = false
    
    var brake = false
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frameCategory
        physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
        
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
        if let levelNode = SKNode.unarchiveFromFile(file: level) {
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
            for child in groundTiles.children {
                if let sprite = child as? SKSpriteNode, sprite.name != nil {
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
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
    
        let move = SKAction.moveBy(x: 0.0, y: player.size.height, duration: 0.4)
        let jump = SKAction.animate(with: player.jumpFrames, timePerFrame: 0.4/Double(player.jumpFrames.count)) // time: one animation loop strecth through 0.4 seconds
        let group = SKAction.group([move, jump]) // perform all passed actions at the same time
        
        player.createUserData(entry: group, forKey: GameConstants.StringConstants.brakeDescendActionKey) // save the actions to the player
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
    
    func brakeDescend() {
        brake = true // to make the movement once per jump
        player.physicsBody!.velocity.dy = 0.0 // current speed of the player in the y direction and cancel out the current momentum
    
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.brakeDescendActionKey) as! SKAction)
    }
    
    func handleEnemyContact() {
        die(reason: 0)
    }
    
    func pauseEnemies(bool: Bool) {
        for enemy in tileMap[GameConstants.StringConstants.enemyName] {
            enemy.isPaused = bool
        }
    }
    
    func die(reason: Int) {
        gameState = .finished
        turnGravity(on: false)
        let deathAnimation: SKAction!
        switch reason {
        case 0:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        case 1:
            let up = SKAction.moveTo(y: frame.midY, duration: 0.25)
            let wait = SKAction.wait(forDuration: 0.1)
            let down = SKAction.moveTo(y: -player.size.height, duration: 0.2)
            deathAnimation = SKAction.sequence([up, wait, down])
        default:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        }
        
        player.run(deathAnimation) {
            self.player.removeFromParent() // to remove player sprite from the scene
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
            } else if !brake {
                brakeDescend()
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
            brake = false // to use it again next jumps
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.finishCategory: //will be called when player hits the finish line
            gameState = .finished
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.enemyCategory:
            handleEnemyContact()
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.frameCategory:
            physicsBody = nil // to prevent die function to work again
            die(reason: 1)
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
