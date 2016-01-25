//
//  CTAAnimationPlayNode.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/22/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

//class  CTAAnimationPlayNode {
//    
//    var aniControllers = [CTAAnimationController]()
//    var endControllerID: String!
//    var nextNode: CTAAnimationPlayNode?
//    private(set) var playing: Bool = false
//    
//    init(controllers: [CTAAnimationController]) {
//        self.aniControllers = controllers
//        
//        var maxDuration: Float = 0.0
//        var endID: String = ""
//        
//        for con in controllers {
//            
//            let duration = con.duration
//            if maxDuration < duration {
//                maxDuration = duration
//                endID = con.iD
//            }
//
//            con.delegate = self
//        }
//
//        endControllerID = endID
//    }
//    
//    func play() {
//        
//        if !playing {
//            playing = true
//            for ani in aniControllers {
//                ani.play()
//            }
//        }
//    }
//    
//    func pause() {
//        
//    }
//    
//    func stop() {
//        
//    }
//}
//
//extension CTAAnimationPlayNode: CTAAnimationControllerDelegate {
//    
//    func controllerAnimationDidFinished(con: CTAAnimationController) {
//        
//        if con.iD == endControllerID {
//            playing = false
//            debug_print("Node Did End", context: aniContext)
//            nextNode?.play()
//        }
//    }
//}