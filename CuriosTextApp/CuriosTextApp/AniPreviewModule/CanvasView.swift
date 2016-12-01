//
//  CanvasView.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let canvasItemIdentifier = "com.emiaostein.containerIdentifier"
class CanvasView: UIView {
    
    weak var dataSource: (UICollectionViewDataSource & CanvasLayoutDataSource)?
    weak var delegate: UICollectionViewDelegate? {
        didSet { collectionView.delegate = delegate }
    }
    fileprivate let collectionView: UICollectionView
    fileprivate var layout: CanvasLayout {
        return collectionView.collectionViewLayout as! CanvasLayout
    }
    
    func changeDataSource() {
        layout.dataSource = dataSource
        collectionView.dataSource = dataSource
    }
    
    override init(frame: CGRect) {
        let layout = CanvasLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let layout = CanvasLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(ContainerCell.self, forCellWithReuseIdentifier: canvasItemIdentifier)
        isUserInteractionEnabled = false
//        layer.addSublayer(collectionView.layer)
//        addSubview(collectionView)  //use to debug
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.addSublayer(collectionView.layer)
        collectionView.frame = bounds
        collectionView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

extension CanvasView {
    
    func reloadData(_ completed:(() -> ())?) {
        DispatchQueue.main.async { [weak self] in
            guard let sf = self, sf.collectionView.dataSource?.collectionView(sf.collectionView, numberOfItemsInSection: 0) > 0 else {return}
            CATransaction.begin()
            CATransaction.setDisableActions(true)
//            sf.collectionView.reloadData()
            
            sf.collectionView.reloadSections(IndexSet(integer: 0))
            CATransaction.commit()
        
            completed?()
        }
    }
}

extension CanvasView {
    
    func containerCellAt(_ indexPath: IndexPath) -> ContainerCell? {
       return collectionView.cellForItem(at: indexPath) as? ContainerCell
    }
    
    func removeAllAnimations() {
        let cells = collectionView.visibleCells as! [ContainerCell]
        for c in cells {
            c.layer.removeAllAnimations()
            c.layer.mask?.removeAllAnimations()
            c.layer.mask = nil
            c.removeAllAnimations()
        }
    }
}
