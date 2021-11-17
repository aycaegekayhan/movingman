//
//  AnimationHelper.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/16/21.
//

import SpriteKit

class AnimationHelper {
    static func loadTextures(from atlas: SKTextureAtlas, withName name: String) -> [SKTexture]{
        var textures = [SKTexture]()
        for index in 0..<atlas.textureNames.count { //to get the states of the player
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
    }
}
