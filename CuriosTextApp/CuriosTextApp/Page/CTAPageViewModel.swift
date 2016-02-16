//
//  CTAPageViewModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol PageVMProtocol {
    
    var containerVMs: [ContainerVMProtocol] { get }
    var animationBinders: [CTAAnimationBinder] { get }
}

extension PageVMProtocol {
    
    func containerByID(id: String) -> ContainerVMProtocol? {
        
        guard let index = (containerVMs.indexOf{$0.iD == id}) else {
            return nil
        }
        return containerVMs[index]
    }
    
    func indexByID(id: String) -> Int? {
        
        guard let index = (containerVMs.indexOf{$0.iD == id}) else {
            return nil
        }
        return index
    }
}

extension PageVMProtocol {
    
    func containerShouldLoadBeforeAnimationBeganByID(iD: String) -> Bool {
        
        guard let aniFirstIndex = (animationBinders.indexOf{$0.targetiD == iD}) else {
            return true
        }
        
        let ani = animationBinders[aniFirstIndex]
        return ani.name.shouldVisalbeBeforeBegan()
    }
    
}

extension CTAPage: PageVMProtocol {
    
    var containerVMs: [ContainerVMProtocol] {
        return containers.map{$0 as ContainerVMProtocol}
    }
    
    var animationBinders: [CTAAnimationBinder] {
        
        return animatoins.map { $0 as CTAAnimationBinder}
    }
}