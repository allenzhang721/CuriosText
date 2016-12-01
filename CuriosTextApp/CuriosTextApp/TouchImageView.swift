//
//  TouchImageView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/13/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class TouchImageView: UIImageView {
    
    var tapHandler: (() -> ())?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapHandler?()
    }
    
}
