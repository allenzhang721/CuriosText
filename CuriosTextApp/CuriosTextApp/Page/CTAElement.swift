//
//  CTAElement.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

protocol CTAElement: class, NSCoding {
    
    var resourceName: String { get }
    var scale: CGFloat { get set }
    //    var x: Double { get }
    //    var y: Double { get }
    //    var width: Double { get }
    //    var height: Double { get }
    
    func resultWithScale(
        _ scale: CGFloat,
        preScale: CGFloat,
        containerSize: CGSize,
        constraintSzie: CGSize) -> (inset: CGPoint, size: CGSize)
}
