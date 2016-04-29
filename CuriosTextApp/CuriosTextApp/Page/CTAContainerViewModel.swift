//
//  CTAContainerViewModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

enum CTAContentsType {
    
    case Empty, Text, Image
}

protocol ContainerVMProtocol: viewPropertiesModifiable, contentsTypeRetrivevable, ContainerIdentifiable {}

extension ContainerVMProtocol {
    
    var featureTypes: [CTAContainerFeatureType] {
        
        switch type {
         // Text Bar Items
        case .Text:
            let textTypes: [CTAContainerFeatureType] = [
                .Fonts,
                .Colors,
                .Size,
                .Rotator,
                .TextSpacing,
                .Aligments,
                .Animation
            ]
            
            return textTypes
            
        case .Image:
            let types: [CTAContainerFeatureType] = [
                .Size,
                .Rotator
            ]
            
            return types
            
        default:
            return []
        }
    }
}

// MARK: - ContainerEdit Protocols
protocol ContainerIdentifiable {
    
    var iD: String { get }
}

protocol ViewPropertiesRetrivevale:class {
    
    //    var origion: (x: Double, y: Double) { get }
    var center: CGPoint { get }
    var size: CGSize { get } // real size + inset
    var scale: CGFloat { get }
    var radius: CGFloat { get }
    var inset: CGPoint { get }
    
    func updateWithScale(ascale: CGFloat, constraintSzie: CGSize)
}

protocol viewPropertiesModifiable: ViewPropertiesRetrivevale {
    
    //    var origion: (x: Double, y: Double) { get set }
    var center: CGPoint { set get }
    var size: CGSize { get set }
    var scale: CGFloat { get set }
    var radius: CGFloat { get set }
}

protocol contentsTypeRetrivevable {
    
    var type: CTAContentsType { get }
}

// MARK: - contentsTypeRetrivevable
extension CTAContainer {
    
    var type: CTAContentsType {
        switch element {
            
        case is CTATextElement:
            return .Text
            
        case is CTAImgElement:
            return .Image
            
        default:
            return .Empty
        }
    }
}

// MARK: - ContainerViewModel
extension CTAContainer: ContainerVMProtocol {
    
    var center: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
        
        set {
            x = Double(newValue.x)
            y = Double(newValue.y)
        }
    }
    
    var size: CGSize {
        
        get {
            return CGSize(width: width, height: height)
        }
        
        set {
            width = Double(newValue.width)
            height = Double(newValue.height)
        }
        
    }
    
    var radius: CGFloat {
        
        get {
            return CGFloat(rotation)
        }
        
        set {
            rotation = Double(newValue)
        }
    }
    
    var scale: CGFloat {
        
        get {
            return CGFloat(contentScale)
        }
        
        set {
            
            contentScale = Double(newValue)
        }
    }
    
    var inset: CGPoint {
        return contentInset
    }
    
    func updateWithScale(ascale: CGFloat, constraintSzie: CGSize) {
        let preScale = scale
        scale = ascale
        element!.scale = ascale
        let newResult = element!.resultWithScale(ascale, preScale: preScale, containerSize: size, constraintSzie: constraintSzie)
        let contentSize = CGSize(width: ceil(newResult.size.width), height: ceil(newResult.size.height))
        let inset = CGPoint(x: floor(newResult.inset.x), y: newResult.inset.y)
        // new content size
        let nextContentSize = CGSize(width: contentSize.width - 2 * inset.x, height: contentSize.height - 2 * inset.y)
        
        size = nextContentSize
        contentInset = inset
    }
}
