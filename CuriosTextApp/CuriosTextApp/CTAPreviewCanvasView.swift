//
//  CTAPreviewCanvasView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAPreviewCanvasViewDataSource: class {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> CTAPreviewPage
}

class CTAPreviewCanvasView: UIView, CTAPreviewControl {

    weak var datasource: CTAPreviewCanvasViewDataSource?
    var collectionView: UICollectionView!
    var page: CTAPreviewPage? {
        return datasource?.canvasViewWithPage(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let layout = CTAPreviewLayout()
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.registerClass(CTAPreviewCell.self, forCellWithReuseIdentifier: "ContainerCell")
        
        collectionView.dataSource = self
        layout.dataSource = self
        layer.addSublayer(collectionView.layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

extension CTAPreviewCanvasView {
    
    func play() {
        guard let cells = collectionView.visibleCells() as? [CTAPreviewCell] else {
            return
        }
        
        for cell in cells {
            cell.play()
        }
    }
    
    func pause() {
        guard let cells = collectionView.visibleCells() as? [CTAPreviewCell] else {
            return
        }
        
        for cell in cells {
            cell.pause()
        }
        
    }
    
    func stop() {
        guard let cells = collectionView.visibleCells() as? [CTAPreviewCell] else {
            return
        }
        
        for cell in cells {
            cell.stop()
        }
    }
    
    func replay() {
        guard let page = page else {
            return
        }
        
    }
}

extension CTAPreviewCanvasView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let page = page else {
            return 0
        }
        
        return page.containers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ContainerCell", forIndexPath: indexPath)
        
        return cell
    }
}

extension CTAPreviewCanvasView: CTAPreviewLayoutDataSource {
    
    func layout(layout: CTAPreviewLayout, layoutAttributesAtIndexPath indexPath: NSIndexPath) -> CTAPreviewContainer? {
        
        guard let page = page else {
            return nil
        }
        
        return page.containers[indexPath.item]
    }
}


