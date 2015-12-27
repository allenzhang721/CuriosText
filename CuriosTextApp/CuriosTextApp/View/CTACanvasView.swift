////
////  CTACanvasView.swift
////  CuriosTextApp
////
////  Created by Emiaostein on 12/15/15.
////  Copyright © 2015 botai. All rights reserved.
////
//
//import UIKit
//
//protocol CanvasControlable {
//    
//    func topContainerLayerAt(point: CGPoint) -> CTAContainerLayer?
//    
//}
//
//class CTACanvasView: UIView, CanvasControlable {
//
//    override class func layerClass() -> AnyClass {
//        return CTACanvasLayer.self
//    }
//    
//    func setupLayers(conLayers: [CTAContainerLayer]) {
//        
//        if let oldConLayers = (layer.sublayers?.filter{$0 is CTAContainerLayer}) {
//            
//            for l in oldConLayers {
//                l.removeFromSuperlayer()
//            }
//        }
//        for l in conLayers {
//            layer.addSublayer(l)
//        }
//    }
//}
//
//// MARK: - CanvasControlable
//extension CTACanvasView {
//    
//    func topContainerLayerAt(point: CGPoint) -> CTAContainerLayer? {
//        
//        guard let specifiedContainers = (layer.sublayers?.filter{$0.containsPoint(layer.convertPoint(point, toLayer: $0))}) else {
//            return nil
//        }
//        
//        print("count = \(specifiedContainers.count)")
//        return specifiedContainers.last as? CTAContainerLayer
//    }
//}
