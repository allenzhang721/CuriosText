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
    
    private var item: CTABarItem?
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    var selected: Bool = false
    
    init(frame: CGRect, item: CTABarItem?) {
        self.item = item
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        imageView = UIImageView()
        titleLabel = UILabel()
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        if let item = item {
            imageView.image = selected ? item.selectedImage : item.normalImage
            titleLabel.textColor = selected ? item.selectedColor : item.normalColor
            titleLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
            titleLabel.text = item.title
        }

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        imageView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        imageView.widthAnchor.constraintEqualToConstant(30).active = true
        imageView.heightAnchor.constraintEqualToConstant(30).active = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraintEqualToAnchor(imageView.bottomAnchor, constant: 5).active = true
        titleLabel.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
        titleLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
    }
    
    func setSelected(selected: Bool, animated: Bool = true) {
        
        if self.selected == !selected {
            self.selected = selected
            
            guard let aitem = item else {
                return
            }
            
            if animated {
                
                UIView.transitionWithView(self, duration: 0.3, options: .BeginFromCurrentState, animations: {[weak self] () -> Void in
                    
                    if let strongSelf = self {
                        let imageView = strongSelf.imageView
                        let titleLabel = strongSelf.titleLabel
                        let sel = strongSelf.selected
                        imageView.image =  sel ? aitem.selectedImage : aitem.normalImage
                        titleLabel.textColor = sel ? aitem.selectedColor : aitem.normalColor
                    }
                    
                    }, completion: nil)
                
            } else {
                
                imageView.image = self.selected ? aitem.selectedImage : aitem.normalImage
                titleLabel.textColor = self.selected ? aitem.selectedColor : aitem.normalColor
            }
        }
    }
    
    func setItem(nextItem: CTABarItem) {
        
        guard item != nextItem else {
            return
        }
        
        item = nextItem
        
        imageView.image = selected ? item!.selectedImage : item!.normalImage
        titleLabel.textColor = selected ? item!.selectedColor : item!.normalColor
        titleLabel.text = item!.title
    }
}
