//
//  CTAImgContainerViewModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol ImageContainerVMProtocol: ContainerVMProtocol {
    
    var imageElement: protocol<CTAElement, ImageModifiable>? {get}
    
//    func updateWithImage(image: UIImage, constraintSize: CGSize)
}

protocol ImageModifiable: class {
    
    func resultWithImgSize(originSize: CGSize, scale: CGFloat, containerSize: CGSize, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize)
}


extension CTAContainer: ImageContainerVMProtocol {
    
    var imageElement: protocol<CTAElement, ImageModifiable>? {
        guard let a = element as? CTAImgElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        return a
    }
    
//    func updateWithImageSize(imageSize: CGSize, constraintSize: CGSize) {
//        
//        guard let
//    }
}