//
//  TouchLabel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/14/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class TouchLabel: UILabel {

    var tapHandler: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(TouchLabel.tap(_:)))
        addGestureRecognizer(tap)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        tapHandler?()
    }
}
