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
  var alpha: CGFloat{ get }
}

protocol TextDrawable: Drawable {
  var attributeString: NSAttributedString { get }
}

protocol ImageDrawable: Drawable {
  var image: UIImage { get }
}

public enum AResult<T> {
  case success(T)
  case failure()
}

struct TextDrawing: TextDrawable {
  let position: CGPoint
  let size: CGSize
  let rotation: CGFloat
  let alpha: CGFloat
  let attributeString: NSAttributedString
}

struct ImageDrawing: ImageDrawable {
  let position: CGPoint
  let size: CGSize
  let rotation: CGFloat
  let alpha: CGFloat
  let image: UIImage
}

// MARK: - Drawing

func drawing(_ promises: [Promise<Drawable>], size: CGSize, backgroundColor: UIColor = UIColor.white ,completed:@escaping (AResult<UIImage>) -> ()) {
  
  
  when(resolved:promises).then { drawables -> UIImage in
    
    UIGraphicsBeginImageContextWithOptions(size, true, 3)
    
    // back ground
    let path = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
    backgroundColor.setFill()
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
//    dispatch_async(dispatch_get_main_queue(), {
//      completed(.Success(image))
//    })
    DispatchQueue.main.async {
//      completed(.success(image))
      completed(.success(image!))
    }
    return image!
  }
}

// MARK: - Generate Promise for Text and Image
func text(_ textPicker: ((NSAttributedString) -> ()) -> (), position: CGPoint, rotation: CGFloat, alpha: CGFloat) -> Promise<Drawable> {
  
  return Promise { fullfill, reject in
    textPicker { attributeText in
      let s = attributeText
      let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
      
      let constraintSize = size
      let storage = NSTextStorage(attributedString: s)
      let container = NSTextContainer(size: constraintSize)
      let manager = NSLayoutManager()
      manager.addTextContainer(container)
      storage.addLayoutManager(manager)
      container.lineFragmentPadding = 0
      let textSize = manager.usedRect(for: container).size
      
      //            let size = s.boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max), options: .UsesLineFragmentOrigin, context: nil).size
      
      let drawUnit = TextDrawing(position: position, size: textSize, rotation: rotation, alpha: alpha, attributeString: s)
      fullfill(drawUnit)
    }
  }
}

func onlineImage(_ imagePicker: ((UIImage) -> ()) -> (), position: CGPoint, rotation: CGFloat, alpha: CGFloat) -> Promise<Drawable> {
  
  return Promise { fullfill, reject in
    imagePicker { image in
      let size = image.size
      let drawable = ImageDrawing(position: position, size: size, rotation: rotation, alpha: alpha,image: image)
      fullfill(drawable)
    }
  }
}

// MARK: - Drawing Text and Image

func drawingText(_ t: TextDrawable) {
  let context = UIGraphicsGetCurrentContext()
  context?.saveGState()
  context?.setAlpha(t.alpha)
  context?.translateBy(x: t.position.x, y: t.position.y)
  context?.rotate(by: t.rotation)
  let rect = CGRect(x: -t.size.width / 2.0, y: -t.size.height / 2.0, width: t.size.width, height: t.size.height)
  let s = t.attributeString
  
  s.draw(in: rect)
  context?.restoreGState()
}

func drawingImage(_ t: ImageDrawable) {
  let context = UIGraphicsGetCurrentContext()
  context?.saveGState()
  context?.translateBy(x: t.position.x, y: t.position.y)
  context?.rotate(by: t.rotation)
  let rect = CGRect(x: -t.size.width / 2.0, y: -t.size.height / 2.0, width: t.size.width, height: t.size.height)
  let s = t.image
  s.draw(in: rect)
  context?.restoreGState()
}
