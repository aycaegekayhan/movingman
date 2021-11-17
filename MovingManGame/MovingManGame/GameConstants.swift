//
//  GameConstants.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/15/21.
//

import Foundation
import CoreGraphics

struct GameConstants {
    
    struct PhysicsCategories {
        //created bit masks to compare with bit operators and react to contact
        static let noCategory: UInt32 = 0 // check physics bodies, no bits of the number are set
        static let allCategory: UInt32 = UInt32.max // all bits of the number are set
        static let playerCategory: UInt32 = 0x1
        static let groundCategory: UInt32 = 0x1 << 1
        static let finishCategory: UInt32 = 0x1 << 2
        static let collectibleCategory: UInt32 = 0x1 << 3
        static let enemyCategory: UInt32 = 0x1 << 4
        static let frameCategory: UInt32 = 0x1 << 5
        static let ceilingCategory: UInt32 = 0x1 << 6
    }
    
    struct ZPositions {
        static let farBGZ: CGFloat = 0
        static let closeBGZ: CGFloat = 1 //higher set positions will be displayed in front of the lower ones
        static let worldZ: CGFloat = 2
        static let objectZ: CGFloat = 3
        static let playerZ: CGFloat = 4
        static let hudZ: CGFloat = 5
    }
    
    struct StringConstants {
        static let groundTilesName = "Ground Tiles"
        static let worldBackgroundNames = ["DessertBackground", "GrassBackground"]
        static let playerName = "Player" //will be assigned node of the player class to identify them
        static let playerImageName = "Idle_0"
        static let groundNodeName = "GroundNode"
        static let finishLineName = "FinishLine"
        static let enemyName = "Enemy"
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let playerRunAtlas = "Player Run Atlas"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let playerDieAtlas = "Player Die Atlas"
        static let idlePrefixKey = "Idle_"
        static let runPrefixKey = "Run_"
        static let jumpPrefixKey = "Jump_"
        static let diePrefixKey = "Die_"
        
        static let jumpUpActionKey = "JumpUp"
        static let brakeDescendActionKey = "BrakeDescend"
    }
    
}
