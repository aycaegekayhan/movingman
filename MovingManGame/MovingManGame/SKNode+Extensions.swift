//
//  SKNode+Extensions.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/7/21.
//

import SpriteKit

extension SKNode {
    
    class func unarchiveFroFile(file: String) -> SKNode? {
        
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let url = URL(fileURLWithPath: path)
            do{
                let sceneData = try Data(contentsOf: url, options: .mappedIfSafe) // if it is possible and safe the data will be mapped
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                archiver.setClass(self.classForKeyedArchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKNode
                archiver.finishDecoding()
                return scene
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
        
    }
    
}
