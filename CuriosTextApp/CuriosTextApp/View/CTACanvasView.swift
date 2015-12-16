//
//  CTACanvasView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class CTACanvasView: UIView {
    
    override class func layerClass() -> AnyClass {
        return CTACanvasLayer.self
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
