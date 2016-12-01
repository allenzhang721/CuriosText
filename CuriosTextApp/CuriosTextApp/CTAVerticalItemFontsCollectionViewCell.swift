//
//  CTAVerticalItemFontsCollectionViewCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/13/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAVerticalItemFontsCollectionViewCell: CTAVerticalItemCollectionViewCell {

    var view: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        
        view = UILabel(frame: bounds)
        contentView.addSubview(view)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override func update() {
        
        let superActived = delegate?.itemCellSuperActived(self) ?? false
        
        if actived && superActived {
            alpha = 1.0
            view.textColor = CTAStyleKit.selectedColor
            return
        }
        
        if actived && !superActived {
            alpha = 1.0
            view.textColor = CTAStyleKit.normalColor
            return
        }
        
        if !actived && superActived {
            alpha = 1.0
            view.textColor = CTAStyleKit.normalColor
            return
        }
        
        if !actived && !superActived {
            alpha = 0.0
            view.textColor = CTAStyleKit.normalColor
            return
        }
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? CollectionViewAttributes else {
            return
        }
        
        update()
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            UIView.transition(with: self, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {[weak self] () -> Void in
                
                if let sr = self {
                    sr.update()
                }
                
                }, completion: nil)
        }
    }
}
