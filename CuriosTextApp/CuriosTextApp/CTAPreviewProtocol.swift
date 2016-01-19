//
//  CTAPreviewProtocol.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

protocol CTAPreviewControl {
    
    func play()
    func pause()
    func stop()
    func replay()
}

protocol CTAPreviewPage {
    
    var containers: [CTAPreviewContainer] { get }
    var animations: [CTAAnimation] { get }
}

protocol CTAPreviewContainer {
    
    var iD: String { get }
    var bounds: CGRect { get }
    var center: CGPoint { get }
    var size: CGSize { get }
    var transform: CGAffineTransform { get }
    var transofrm3D: CATransform3D { get }
    var alpha: CGFloat { get }
}

protocol CTAPreviewTextContainer: CTAPreviewContainer {
    
    var text: String { get }
    var attributes: [String: AnyObject] { get }
}

protocol CTAPreviewImgContainer: CTAPreviewContainer {
    
    var image: String { get }
    var attributes: [String: AnyObject] { get }
}