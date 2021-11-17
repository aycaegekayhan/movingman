//
//  Player.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/15/21.
//

import SpriteKit

enum PlayerState {
    case idle, running
}

class Player: SKSpriteNode {
    
    var runFrames = [SKTexture]()
    var idleFrames = [SKTexture]()
    var jumpFrames = [SKTexture]()
    var dieFrames = [SKTexture]()
    
    var state = PlayerState.idle { // beggining state of game
        willSet {
            animate(for: newValue)
        }
    }

    func loadTextures() {
        
    }
    
    func animate(for state: PlayerState) {
        
    }
    
}
