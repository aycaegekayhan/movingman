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
    
    func scale(to screenSize: CGSize, width: Bool, multiplier: CGFloat){ //METHOD TO SCALE A CERTAIN OBJECT(SKNODE), SCALE THE SKNODE DEPENDING ON OTHER NODES SIZE
        
        let scale = width ? (screenSize.width * multiplier) / self.frame.size.width : (screenSize.height * multiplier) / self.frame.size.width
        self.setScale(scale)
    }
    
    func turnGravity(on value: Bool) {
        physicsBody?.affectedByGravity = value // this method allows gravity of certain physics body on and off
    }
    
    func createUserData(entry: Any, forKey key: String) { // inside of a sknode this method will keep certain data
        
        if userData == nil {
            let userDataDictionary = NSMutableDictionary()
            userData = userDataDictionary
        }
        userData!.setValue(entry, forKey: key)
    }
}
