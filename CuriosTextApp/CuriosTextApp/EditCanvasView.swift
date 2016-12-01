//
//  CanvasView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

protocol CanvasViewDataSource: class {
    
    func numberOfcontainerInCanvasView(_ canvas: EditCanvasView) -> Int
    func canvasView(_ canvas: EditCanvasView, containerAtIndex index: Int) -> ContainerView
}

protocol CanvasViewDelegate: class {
    
    func canvasView(_ canvas: EditCanvasView, didSelectedContainerAtIndex index: Int)
}

class EditCanvasView: UIView {
    
    weak var dataSource: CanvasViewDataSource?
    weak var delegate: CanvasViewDelegate?
    
    fileprivate(set) var selectedContainerIndexs = [Int]()
    fileprivate var containerViews = [ContainerView]()
    var elementCount: Int {
        return containerViews.count
    }
    func reloadData() {
        
        if containerViews.count > 0 {
            
            for containerView in containerViews {
                containerView.removeFromSuperview()
            }
            containerViews = []
            selectedContainerIndexs = []
        }
        
        guard let count = dataSource?.numberOfcontainerInCanvasView(self), count > 0 else {
            return
        }
        
        setupContainers(count)
    }
    
    fileprivate func setupContainers(_ count: Int) {
        
        guard let dataSource = dataSource, count > 0 else {
            return
        }
        for index in 0..<count {
            let containerView = dataSource.canvasView(self, containerAtIndex: index)
            containerViews += [containerView]
            addSubview(containerView)
        }
    }
    
    func containerViewAt(_ index: Int) -> ContainerView? {
        return containerViews[index]
    }
}

// MARK: - Gestures
extension EditCanvasView {
    
    func tap(_ sender: UITapGestureRecognizer) {
        
        
        var index = -1
        for (i, view) in containerViews.reversed().enumerated() {
            let point = sender.location(in: view)
            if view.layer.contains(point) {
                index = elementCount - 1 - i
                break
            }
        }
        
        if index >= 0 {
            selectedContainerIndexs = [index]
            delegate?.canvasView(self, didSelectedContainerAtIndex: index)
        }
        
    }
}
