//
//  CTAImgContainerViewModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol ImageContainerVMProtocol: ContainerVMProtocol {
    
    var imageElement: protocol<CTAElement>? {get}
}

extension CTAContainer: ImageContainerVMProtocol {
    
    var imageElement: protocol<CTAElement>? {
        guard let imgElement = element as? CTAImgElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        return imgElement
    }
}