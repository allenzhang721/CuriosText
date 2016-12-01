//
//  CTAImgContainerViewModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol ImageContainerVMProtocol: ContainerVMProtocol {
    
    var imageElement: (CTAElement & ImageModifiable)? {get}
    
    func updateWithImageSize(_ imageSize: CGSize, constraintSize: CGSize)
}

protocol ImageModifiable: class {
    
    func resultWithImgSize(_ originSize: CGSize, scale: CGFloat, containerSize: CGSize, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize)
}


extension CTAContainer: ImageContainerVMProtocol {
    
    var imageElement: (CTAElement & ImageModifiable)? {
        guard let a = element as? CTAImgElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        return a
    }
    
    func updateWithImageSize(_ imageSize: CGSize, constraintSize: CGSize) {
        
        guard let imgE = imageElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        let newResult = imgE.resultWithImgSize(imageSize, scale: scale, containerSize: size, constraintSize: constraintSize)
        let contentSize = CGSize(width: ceil(newResult.size.width), height: ceil(newResult.size.height))
        let inset = CGPoint(x: floor(newResult.inset.x), y: newResult.inset.y)
        // new content size
        let nextSize = CGSize(width: contentSize.width - 2 * inset.x, height: contentSize.height - 2 * inset.y)
        
        size = nextSize
        contentInset = inset
        
    }
}
