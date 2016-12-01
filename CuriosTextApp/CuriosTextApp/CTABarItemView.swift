//
//  CTABarItemView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/27/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTABarItem: NSObject {
    
    let normalImage: UIImage
    let selectedImage: UIImage
    let normalColor: UIColor
    let selectedColor: UIColor
    let title: String
    
    init(normalImage: UIImage, selectedImage: UIImage, normalColor: UIColor, selectedColor: UIColor, title: String) {
        self.normalColor = normalColor
        self.selectedColor = selectedColor
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.title = title
    }
}

class CTABarItemView: UIView {
    
    fileprivate var item: CTABarItem?
    fileprivate var imageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    var selected: Bool = false
    
    init(frame: CGRect, item: CTABarItem?) {
        self.item = item
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        
        imageView = UIImageView()
        titleLabel = UILabel()
        
        imageView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        if let item = item {
            imageView.image = selected ? item.selectedImage : item.normalImage
            titleLabel.textColor = selected ? item.selectedColor : item.normalColor
            
            titleLabel.text = item.title
        }
        
        imageView.image = CTAStyleKit.imageOfSpacingBarItemNormal

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setSelected(_ selected: Bool, animated: Bool = true) {
        
        if self.selected == !selected {
            self.selected = selected
            
            guard let aitem = item else {
                return
            }
            
            if animated {
                
                UIView.transition(with: self, duration: 0.3, options: .beginFromCurrentState, animations: {[weak self] () -> Void in
                    
                    if let strongSelf = self {
                        let imageView = strongSelf.imageView
                        let titleLabel = strongSelf.titleLabel
                        let sel = strongSelf.selected
                        imageView?.image =  sel ? aitem.selectedImage : aitem.normalImage
                        titleLabel?.textColor = sel ? aitem.selectedColor : aitem.normalColor
                    }
                    
                    }, completion: nil)
                
            } else {
                
                imageView.image = self.selected ? aitem.selectedImage : aitem.normalImage
                titleLabel.textColor = self.selected ? aitem.selectedColor : aitem.normalColor
            }
        }
    }
    
    func setItem(_ nextItem: CTABarItem) {
        
        guard item != nextItem else {
            return
        }
        
        item = nextItem
        
        imageView.image = selected ? item!.selectedImage : item!.normalImage
        titleLabel.textColor = selected ? item!.selectedColor : item!.normalColor
        titleLabel.text = item!.title
    }
}
