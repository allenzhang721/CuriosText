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
        colorView.layer.borderColor = UIColor.lightGray.cgColor
        colorView.layer.borderWidth = 0.5
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        colorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 36).isActive = true
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
