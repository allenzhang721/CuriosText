//
//  AniPlayCanvasView.swift
//  PopApp
//
//  Created by Emiaostein on 4/8/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

protocol AniPlayCanvasViewDataSource: class {
    
    func animationsForAniPlayCanvasView(_ view: AniPlayCanvasView) -> [Animation]?
    func containerItemForAniPlayCanvasView(_ view: AniPlayCanvasView, containerID: String) -> AniCanvasAccessResult
}

class AniPlayCanvasView: CanvasView {

    weak var aniDataSource: AniPlayCanvasViewDataSource?
    var completedBlock: (() -> ())?
    var beganNode: AniNode?
    var currentNode: AniNode?
    let control = AniControl()

    func ready() {
        if layer.speed != 0 { layer.speed = 0 }
        control.stop()
        reset()
        setupAniNodes()
        setupControl()
        currentNode = beganNode
        guard let aniNode = currentNode else { return }
        readyWith(aniNode)
    }
    
    func play() {
        if let currentNode = currentNode {
            control.start(Float(currentNode.duration))
        }
    }
    
    func pause() {
        control.pause()
    }
    
    func stop() {
        control.stop()
    }
}

// Using progress to control animation, can be use to generate gif.
extension AniPlayCanvasView {
    
    enum PlayNextResult {
        case next(duration: CGFloat)
        case failture
    }
    
    var progress: CGFloat {
        set {
            guard let currentNode = currentNode else { return }
            layer.timeOffset = CFTimeInterval(currentNode.duration) * CFTimeInterval(newValue)
        }
        
        get {
            guard let currentNode = currentNode else { return 0 }
            return CGFloat(layer.timeOffset / CFTimeInterval(currentNode.duration))
        }
    }
    
    func progressBegan() -> PlayNextResult {
        if let currentNode = currentNode {
            return .next(duration: CGFloat(currentNode.duration))
        } else {
            return .failture
        }
    }
    
    func progressPlayNext() -> PlayNextResult {
        reset()
        currentNode = currentNode?.nextNode
        if let aniNode = currentNode {
            readyWith(aniNode)
            return .next(duration: CGFloat(aniNode.duration))
        } else {
            return .failture
        }
    } 
}

extension AniPlayCanvasView {
    
    fileprivate func reset() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        removeAllAnimations()
        layer.timeOffset = 0
        CATransaction.commit()
    }
    
    fileprivate func setupAniNodes() {
        guard let aniDataSource = aniDataSource, let animations = aniDataSource.animationsForAniPlayCanvasView(self) else {
            beganNode = nil
            currentNode = nil
            return
        }
        
        let node = AniNode(animations: animations)
        beganNode = node
    }
    
    fileprivate func readyWith(_ node: AniNode) -> Float {
        guard let aniDataSource = aniDataSource else { return 0 }
        let result = node.startWith(bounds.size) {[weak self] (containerID) -> AniNodeFinderResult in
            if let sf = self {
                switch aniDataSource.containerItemForAniPlayCanvasView(sf, containerID: containerID) {
                case .success(let i , let container):
                    return AniNodeFinderResult.success(i, container)
                    
                case .failture:
                    return AniNodeFinderResult.notFound
                }
            } else {
                return AniNodeFinderResult.notFound
            }
        }
        beganAnimationAt(result.containers)
        return result.duration
    }
    
    fileprivate func setupControl() {
        control.callBack {[weak self] (state) in
            guard let sf = self else {
                return
            }
            switch state {
            case .playing(let p, let d):
                sf.layer.timeOffset = CFTimeInterval(d) * CFTimeInterval(p)
            case .completed:
//                sf.reset()
                sf.currentNode = sf.currentNode?.nextNode
                guard let aniNode = sf.currentNode else {
                    self?.completedBlock?()
                    return
                }
                sf.readyWith(aniNode)
                sf.control.start(Float(aniNode.duration))
            default:
                ()
            }
        }
    }
}

