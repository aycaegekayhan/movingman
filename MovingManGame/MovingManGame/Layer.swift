//
//  Layer.swift
//  MovingManGame
//
//  Created by Ayça ege Kayhan on 11/9/21.
//

import SpriteKit

public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

class Layer: SKNode {
    
    var layerVelocity = CGPoint.zero
    
    func update(_ delta: TimeInterval) { // will call when work with layer
        for child in children{ //all children in layer node
            updateNodesGlobal(delta, childNode: child) // change the position of the respective child node by calculating offset
        }
    }
    
    func updateNodesGlobal(_ delta: TimeInterval, childNode: SKNode) {
        let offset = layerVelocity * CGFloat(delta) // take the velocity of layer and multiply it with the time that has passed
        childNode.position += offset //update the position of the child node
        updateNodes(delta, childNode: childNode) // if necessary the nodes will be updated
    }
    
    func updateNodes(_ delta: TimeInterval, childNode: SKNode) {
        // will be overriden in subclasses
    }
    
}
