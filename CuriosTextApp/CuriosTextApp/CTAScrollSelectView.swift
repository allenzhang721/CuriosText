//
//  CTAScrollSelectView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAScrollSelectView: UIControl {

    private let collectionView: UICollectionView
    
    init(frame: CGRect, direction: UICollectionViewScrollDirection) {
        
        let lineLayout = CTALineFlowLayout()
        lineLayout.scrollDirection = direction
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: lineLayout)
        super.init(frame: frame)
        addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }

}
