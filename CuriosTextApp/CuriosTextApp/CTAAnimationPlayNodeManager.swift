//
//  CTAAnimationPlayNodeManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/25/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol CTAAnimationPlayNodeManagerDataSource: class {
    
    func numberOfNodesForNodeManager(_ manager: CTAAnimationPlayNodeManager) -> Int
    func nodeManager(_ manager: CTAAnimationPlayNodeManager, animationControllersForNodeAtIndex index: Int) -> [CTAAnimationController]
}

final class CTAAnimationPlayNodeManager {
    
    fileprivate class  CTAAnimationPlayNode: CTAAnimationControllerDelegate {

        var aniControllers = [CTAAnimationController]()
        var endControllerID: String!
        var nextNode: CTAAnimationPlayNode?
        var index: Int
        
        fileprivate(set) var playing: Bool = false
        fileprivate var pausing: Bool = true
        
        var stoped: Bool {
            return !playing
        }
        
        var paused: Bool {
            return (playing == true && pausing)
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
            
            if stoped {
                playing = true
                pausing = false
                //TODO: replay
                for controller in aniControllers {
                    controller.play()
                }
            }
            
            if paused {
                playing = true
                pausing = false
                //TODO: controllers continue play
                for controller in aniControllers {
                    controller.play()
                }
                return
            }
            
            if playing {
                return
            }
        }
        
        func pause() {
            
            if paused || stoped {
                return
            }
            
            if playing {
                playing = true
                pausing = true
                //TODO:  controllers pause
                for controller in aniControllers {
                    controller.pause()
                }
                return
            }
        }
        
        func stop() {
            
            if playing {
                playing = false
                pausing = false
                //TODO: controllers stop
                for controller in aniControllers {
                    controller.stop()
                }
                return
            }
            
            if paused {
                playing = false
                pausing = false
                //TODO: controllers stop
                for controller in aniControllers {
                    controller.stop()
                }
                return
            }
        }
        
        func controllerAnimationDidFinished(_ con: CTAAnimationController) {
            
            if con.iD == endControllerID {
                playing = false
                pausing = false
                nextNode?.play()
            }
        }
    }
    
    weak var dataSource: CTAAnimationPlayNodeManagerDataSource?
    fileprivate var nodes = [Int: CTAAnimationPlayNode]()
    
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
            return false
        }
        
        
        for n in nodes.values {
            if n.paused {
                
                return true
            }
        }
        
        return false
    }
    
    var stoped: Bool {
        return !playing
    }
    
    func play() {
        
        // 3. if did end or if first play not began
        if stoped {
            debug_print("Manager is stop and will play", context: aniContext)
            // need first play or play again
            if nodes.count > 0 {
                let headNode = nodes[0]
                headNode?.play()
            }
            
            return
        }
        
        // 2. if pause
        if paused {
            debug_print("Manager is paused and will play", context: aniContext)
            // continue play
            for n in nodes.values {
                if n.paused {
                    
                    n.play()
                }
            }
            return
        }
        
        // 1. if playing
        if playing {
            return
        }
        
        
    }
    
    func pause() {
        
        //2. if pause
        if paused {
            debug_print("Manager is paused and will pause but do nothing", context: aniContext)
            return
        }
        
        //1. if playing
        if playing {
            debug_print("Manager is playing and will pause", context: aniContext)
            // pause
            for n in nodes.values {
                
                if n.playing {
                    n.pause()
                }
            }
            return
        }
        
        //3. if did end or first play not began
        if stoped {
            debug_print("Manager is stoped and will pause but do nothing", context: aniContext)
            return
        }
    }
    
    func stop() {
        
        //3. if did end
        if stoped {
            debug_print("Manager is stoped and will stop but do nothing", context: aniContext)
            return
        }
        
        //1. if playing
        if playing {
            debug_print("Manager is playing and will stop", context: aniContext)
            // need to stop
            for n in nodes.values {
                if n.playing {
                    n.stop()
                }
            }
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
