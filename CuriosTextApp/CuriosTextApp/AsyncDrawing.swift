//
//  AsyncDrawing.swift
//  PromiseApp
//
//  Created by Emiaostein on 3/4/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

protocol Drawable {
    var position: CGPoint { get }
    var size: CGSize { get }
    var rotation: CGFloat { get }
}

protocol TextDrawable: Drawable {
    var attributeString: NSAttributedString { get }
}

protocol ImageDrawable: Drawable {
    var image: UIImage { get }
}

public enum Result<T> {
    case Success(T)
    case Failure()
}

struct TextDrawing: TextDrawable {
    let position: CGPoint
    let size: CGSize
    let rotation: CGFloat
    let attributeString: NSAttributedString
}

struct ImageDrawing: ImageDrawable {
    let position: CGPoint
    let size: CGSize
    let rotation: CGFloat
    let image: UIImage
}

// MARK: - Drawing

func drawing(promises: [Promise<Drawable>], size: CGSize, completed:(Result<UIImage>) -> ()) {
    
    when(promises).then { drawables -> UIImage in
        
        UIGraphicsBeginImageContextWithOptions(size, true, 3)
        
        // back ground
                let path = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
                UIColor.whiteColor().setFill()
                path.fill()
        
        for d in drawables {
            if let d = d as? TextDrawable {
                drawingText(d)
            } else if let d = d as? ImageDrawable {
                drawingImage(d)
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        dispatch_async(dispatch_get_main_queue(), {
            completed(.Success(image))
        })
        return image
    }
}

// MARK: - Generate Promise for Text and Image
func text(textPicker: ((NSAttributedString) -> ()) -> (), position: CGPoint, rotation: CGFloat) -> Promise<Drawable> {
    
    return Promise { fullfill, reject in
        textPicker { attributeText in
            let s = attributeText
            let size = CGSize(width: CGFloat.max, height: CGFloat.max)
            
            let constraintSize = size
            let storage = NSTextStorage(attributedString: s)
            let container = NSTextContainer(size: constraintSize)
            let manager = NSLayoutManager()
            manager.addTextContainer(container)
            storage.addLayoutManager(manager)
            container.lineFragmentPadding = 0
            let textSize = manager.usedRectForTextContainer(container).size
            
//            let size = s.boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max), options: .UsesLineFragmentOrigin, context: nil).size
            
            let drawUnit = TextDrawing(position: position, size: textSize, rotation: rotation, attributeString: s)
            fullfill(drawUnit)
        }
    }
}

func onlineImage(imagePicker: ((UIImage) -> ()) -> (), position: CGPoint, rotation: CGFloat) -> Promise<Drawable> {
    
    return Promise { fullfill, reject in
        imagePicker { image in
            let size = image.size
            let drawable = ImageDrawing(position: position, size: size, rotation: rotation, image: image)
            fullfill(drawable)
        }
    }
}

// MARK: - Drawing Text and Image

func drawingText(t: TextDrawable) {
    let context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, t.position.x, t.position.y)
    CGContextRotateCTM(context, t.rotation)
    let rect = CGRect(x: -t.size.width / 2.0, y: -t.size.height / 2.0, width: t.size.width, height: t.size.height)
    let s = t.attributeString
    s.drawInRect(rect)
    CGContextRestoreGState(context)
}

func drawingImage(t: ImageDrawable) {
    let context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, t.position.x, t.position.y)
    CGContextRotateCTM(context, t.rotation)
    let rect = CGRect(x: -t.size.width / 2.0, y: -t.size.height / 2.0, width: t.size.width, height: t.size.height)
    let s = t.image
    s.drawInRect(rect)
    CGContextRestoreGState(context)
}
