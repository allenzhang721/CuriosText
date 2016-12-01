//
//  ContainerCell.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

let containerItemIdentifier = "com.emiaostein.contentIdentifier"
class ContainerCell: UICollectionViewCell {
    
    var identifier = ""
    weak var dataSource: (UICollectionViewDataSource & ContainerLayoutDataSource)? {
        didSet {
            layout.dataSource = dataSource
            collectionView.dataSource = dataSource
        }
    }
    weak var delegate: UICollectionViewDelegate? {
        didSet { collectionView.delegate = delegate }
    }
    fileprivate let collectionView: UICollectionView
    fileprivate var layout: ContainerLayout {
        return collectionView.collectionViewLayout as! ContainerLayout
    }
    
    override init(frame: CGRect) {
        let layout = ContainerLayout()
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
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(ContentTextCell.self, forCellWithReuseIdentifier: containerItemIdentifier + SourceType.Text.rawValue)
        collectionView.register(ContentImageCell.self, forCellWithReuseIdentifier: containerItemIdentifier + SourceType.Image.rawValue)
        contentView.layer.addSublayer(collectionView.layer)
        collectionView.layer.masksToBounds = false
        //        addSubview(collectionView)  use to debug
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

extension ContainerCell {
    
    func contentCellAt(_ indexPath: IndexPath) -> ContentCell? {
        return collectionView.cellForItem(at: indexPath) as? ContentCell
    }
    
    func reloadData(_ completed:() -> ()) {
        let cells = collectionView.visibleCells
        for c in cells {
            c.contentView.layer.removeAllAnimations()
        }
        
//        collectionView.performBatchUpdates({ [weak self] in
//            guard let sf = self else { return }
//            sf.collectionView.reloadData()
//            }) { (finished) in
//                
//                if finished {
//                    completed()
//                }
//        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        collectionView.reloadSections(IndexSet(integer: 0))
        collectionView.reloadData()
        CATransaction.commit()
//        dispatch_async(dispatch_get_main_queue()) { 
            completed()
//        }
    }
    
    func removeAllAnimations() {
        let cells = collectionView.visibleCells
        for c in cells {
            c.layer.removeAllAnimations()
            c.layer.mask?.removeAllAnimations()
            c.layer.mask = nil
            c.contentView.layer.removeAllAnimations()
            c.contentView.layer.mask?.removeAllAnimations()
            c.contentView.layer.mask = nil
        }
    }
}
