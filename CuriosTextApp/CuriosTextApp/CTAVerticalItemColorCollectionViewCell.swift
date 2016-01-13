//
//  CTAVerticalItemColorCollectionViewCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAVerticalItemColorCollectionViewCell: CTAVerticalItemCollectionViewCell {

    
    var colorView: UIView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
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
        
        colorView = UIView(frame: bounds)
        colorView.layer.cornerRadius = 18
        colorView.layer.borderColor = UIColor.lightGrayColor().CGColor
        colorView.layer.borderWidth = 0.5
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        colorView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        colorView.widthAnchor.constraintEqualToConstant(36).active = true
        colorView.heightAnchor.constraintEqualToConstant(36).active = true
    }
    
    override func update() {
        
        let superActived = delegate?.itemCellSuperActived(self) ?? false
        
        if actived && superActived {
            alpha = 1.0
            return
        }
        
        if actived && !superActived {
            alpha = 1.0
            return
        }
        
        if !actived && superActived {
            alpha = 1.0
            return
        }
        
        if !actived && !superActived {
            alpha = 0.0
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
