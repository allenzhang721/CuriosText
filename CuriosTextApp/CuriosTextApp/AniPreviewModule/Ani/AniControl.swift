//
//  AniControl.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

class AniControl: NSObject {
    
    enum AniControlState {
        case start
        case playing(Float, Float) // progress, duration
        case paused
        case continued
        case stoped
        case completed
    }
    
    typealias AniControlHander = (AniControlState) -> ()
    
    struct AniControlInner {
        var duration: Float = 2.0
        var progress: Float = 0
        var currentFrame: Int = 0
        var totalFrames: Int = 0
        
        //play control
        var playing = false

        mutating func reset() {
            playing = false
            progress = 0
            currentFrame = 0
            totalFrames = 0
            
        }
    }
    
    var inner = AniControlInner()
    fileprivate lazy var displayLink: CADisplayLink = {
        let adisplayLink = CADisplayLink(target: self,selector: #selector(AniControl.displayFrameTick))
        adisplayLink.add(to: RunLoop.current,forMode: RunLoopMode.commonModes)
        adisplayLink.isPaused = true
        return adisplayLink
    }()
    fileprivate var paused: Bool {
        get { return displayLink.isPaused }
        set { displayLink.isPaused = newValue }
    }
    
    fileprivate var playing: Bool {
        get { return inner.playing }
        set { inner.playing = newValue }
    }
    
    fileprivate var handler: AniControlHander?
    
    @objc fileprivate func displayFrameTick() {
        tick()
    }
    
    func start(_ duration: Float) {
        p_start(duration)
    }
    
    func pause() {
        p_pause()
    }
    
    func stop() {
        p_stop()
    }
    
    func callBack(_ handler: AniControlHander?) {
        self.handler = handler
    }
}

extension AniControl {
    fileprivate func tick() {
        if displayLink.duration > 0 && inner.totalFrames <= 0 {
            let frameRate = Float(displayLink.duration) / Float(displayLink.frameInterval)
            inner.totalFrames = Int(ceil(inner.duration / frameRate))
        }
        
        inner.currentFrame += 1
        if inner.currentFrame <= inner.totalFrames {
            if !inner.playing {
                inner.playing = true
            }
            inner.progress += 1.0 / Float(inner.totalFrames)
            handler?(.playing(inner.progress, inner.duration))
        } else {
            
            inner.reset()
            displayLink.isPaused = true
            handler?(.completed)
        }
    }
    
    fileprivate func p_start(_ duration: Float) {
        switch (playing, paused) {
        case (true, true): // paused
            paused = false; handler?(.continued)
        case (true, false): // playing
            ()
        case (false, true): // stop or not start
            inner.reset()
            inner.duration = duration
            playing = true
            paused = false
            handler?(.start)
        case (false, false):
            playing = true
        }
    }
    
    fileprivate func p_pause() {
        if !paused {
            paused = true
            handler?(.paused)
        }
    }
    
    fileprivate func p_stop() {
        if inner.playing {
            paused = true
            inner.reset()
            handler?(.stoped)
        }
    }
}
