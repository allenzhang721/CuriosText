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
        view.textAlignment = .Center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        view.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        view.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
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
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.applyLayoutAttributes(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? CollectionViewAttributes else {
            return
        }
        
        update()
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            UIView.transitionWithView(self, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {[weak self] () -> Void in
                
                if let sr = self {
                    sr.update()
                }
                
                }, completion: nil)
        }
    }
}
