//
//  GameConstants.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/15/21.
//

import Foundation
import CoreGraphics

struct GameConstants {
    
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
    }
    
}
