//
//  CTAAnimationPlayNodeManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/25/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol CTAAnimationPlayNodeManagerDataSource: class {
    
    func numberOfNodesForNodeManager(manager: CTAAnimationPlayNodeManager) -> Int
    func nodeManager(manager: CTAAnimationPlayNodeManager, animationControllersForNodeAtIndex index: Int) -> [CTAAnimationController]
}

final class CTAAnimationPlayNodeManager {
    
    private class  CTAAnimationPlayNode: CTAAnimationControllerDelegate {

        var aniControllers = [CTAAnimationController]()
        var endControllerID: String!
        var nextNode: CTAAnimationPlayNode?
        var index: Int
        
        private(set) var playing: Bool = false
        private var pausing: Bool = true
        
        var stoped: Bool {
            return !playing
        }
        
        var paused: Bool {
            return (playing == true && pausing == true) ? true : false
        }
        
        init(controllers: [CTAAnimationController], index: Int) {
            
            self.index = index
            self.aniControllers = controllers
            
            var maxDuration: Float = 0.0
            var endID: String = ""
            for con in controllers {
                
                let duration = con.duration
                if maxDuration < duration {
                    maxDuration = duration
                    endID = con.iD
                }
                
                con.delegate = self
            }
            
            endControllerID = endID
        }
        
        func play() {
            
            if paused {
                playing = true
                pausing = false
                //TODO: continue play
                
                
                return
            }
            
            if playing {
                return
            }
            
            //TODO: replay
        }
        
        func pause() {
            
            if paused || stoped {
                return
            }
            
            if playing {
                playing = true
                pausing = true
                //TODO: pause
                
                return
            }
        }
        
        func stop() {
            
            if playing {
                playing = false
                pausing = false
                //TODO: stop
                return
            }
            
            if paused {
                playing = false
                pausing = false
                //TODO: stop
                return
            }
        }
        
        func controllerAnimationDidFinished(con: CTAAnimationController) {
            
            if con.iD == endControllerID {
                playing = false
                pausing = false
                nextNode?.play()
            }
            
        }
    }
    
    weak var dataSource: CTAAnimationPlayNodeManagerDataSource?
    private var nodes = [Int: CTAAnimationPlayNode]()
    var playing: Bool {
        guard nodes.count > 0 else {
            return false
        }
        
        for n in nodes.values {
            
            if n.playing {
                return true
            }
        }
        
        return false
    }
    
    var paused: Bool {
        guard nodes.count > 0 else {
            return true
        }
        
        for n in nodes.values {
            
            if n.paused {
                return false
            }
        }
        
        return true
    }
    
    var stoped: Bool {
        return !playing
    }
    
    func play() {
        
        // 1. if playing
        if playing {
            return
        }
        
        // 2. if pause
        if paused {
            // continue play
            return
        }
        
        // 3. if did end
        if stoped {
            // need first play or play again
            
            
            return
        }
        
        // 4. if first play not began
        
    }
    
    func pause() {
        
        //2. if pause
        if paused {
            return
        }
        
        //3. if did end
        if stoped {
            return
        }
        
        //1. if playing
        if playing {
            // pause
            return
        }
        
        //4. if first play not began
        
    }
    
    func stop() {
        
        //3. if did end
        if stoped {
            return
        }
        
        //1. if playing
        if playing {
            // need to stop
            return
        }

        //2. if pause
        if paused {
            // nned to stop
            return
        }
    }
    
    func reloadNodes() {
        
        // I. Clean Nodes
        
        
        if stoped {
            
        } else if playing { // 1. if playing
            stop()
            
        } else if paused { // 2. if pause
            stop()
        }
        
        // 3. if did end
//        if stoped {
//            
//        }
        
        nodes = [:]

        // II. reload notes
        guard let dataSource = dataSource else {
            return
        }
        
        let nodeCount = dataSource.numberOfNodesForNodeManager(self)
        for i in 0..<nodeCount {
            let aniControllers = dataSource.nodeManager(self, animationControllersForNodeAtIndex: i)
            let node = CTAAnimationPlayNode(controllers: aniControllers, index: i)
            nodes[i] = node
            
            if i > 0 && i <= (nodeCount - 1) {
                let preNode = nodes[i - 1]
                preNode?.nextNode = node
            }
        }
    }
}