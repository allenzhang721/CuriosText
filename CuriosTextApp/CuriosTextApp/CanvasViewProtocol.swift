//
//  CanvasViewProtocol.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

protocol CanvasViewDataSource: class {
    
    func numberOfcontainerInCanvasView(canvas: CanvasView) -> Int
    func canvasView(canvas: CanvasView, containerAtIndex index: Int) -> ContainerView
}

protocol CanvasViewDelegate: class {
    
    func canvasView(canvas: CanvasView, didSelectedContainerAtIndex index: Int)
}