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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tapHandler?()
    }
}
