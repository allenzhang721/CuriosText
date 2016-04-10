//
//  CanvasView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

protocol CanvasViewDataSource: class {
    
    func numberOfcontainerInCanvasView(canvas: EditCanvasView) -> Int
    func canvasView(canvas: EditCanvasView, containerAtIndex index: Int) -> ContainerView
}

protocol CanvasViewDelegate: class {
    
    func canvasView(canvas: EditCanvasView, didSelectedContainerAtIndex index: Int)
}

class EditCanvasView: UIView {
    
    weak var dataSource: CanvasViewDataSource?
    weak var delegate: CanvasViewDelegate?
    
    private(set) var selectedContainerIndexs = [Int]()
    private var containerViews = [ContainerView]()
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
        
        guard let count = dataSource?.numberOfcontainerInCanvasView(self) where count > 0 else {
            return
        }
        
        setupContainers(count)
    }
    
    private func setupContainers(count: Int) {
        
        guard let dataSource = dataSource where count > 0 else {
            return
        }
        for index in 0..<count {
            let containerView = dataSource.canvasView(self, containerAtIndex: index)
            containerViews += [containerView]
            addSubview(containerView)
        }
    }
    
    func containerViewAt(index: Int) -> ContainerView? {
        return containerViews[index]
    }
}

// MARK: - Gestures
extension EditCanvasView {
    
    func tap(sender: UITapGestureRecognizer) {
        
        
        var index = -1
        for (i, view) in containerViews.reverse().enumerate() {
            let point = sender.locationInView(view)
            if view.layer.containsPoint(point) {
                index = elementCount - 1 - i
                break
            }
        }
        print(index)
        if index >= 0 {
            selectedContainerIndexs = [index]
            delegate?.canvasView(self, didSelectedContainerAtIndex: index)
            print("did selected container")
        }
        
    }
}
