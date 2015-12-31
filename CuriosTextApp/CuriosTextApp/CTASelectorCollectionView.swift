//
//  CTAToolsView.swift
//  EditorToolApp
//
//  Created by Emiaostein on 12/29/15.
//  Copyright © 2015 Emiaostein. All rights reserved.
//

import UIKit

enum CTASelectorType {
    
    case Size
    case Fonts
}

final class CTASelectorViewFactory {
    
    class func selectorViewBy(type: CTASelectorType) -> CTASelectorReuseableView {
        
        switch type {
            
        case .Size:
            return CTASelectorReuseableView()
        case .Fonts:
            return CTASelectorReuseableView()
        }
    }
}

final class CTASelectorCollectionView: UIView {
    
    private var selectorsQueue = [CTASelectorType: [CTASelectorReuseableView]]()
    
    var selectorView: CTASelectorReuseableView?
    
    func changeTo(type: CTASelectorType) {
        
        let preresueView = selectorView
        let nextReuseView: CTASelectorReuseableView
        
//       print("\nchangeBegan = \(self.selectorsQueue[.Size])")
        
        if let reuseViews = selectorsQueue[type] where reuseViews.count > 0 {
            nextReuseView = reuseViews.first!
            selectorsQueue[type]!.removeAtIndex(0)
        } else {
            // generate new reuseView
//            print("Create New")
            nextReuseView = CTASelectorViewFactory.selectorViewBy(type)
        }
        
        nextReuseView.frame = bounds
        
//        print("nextNew = \(nextReuseView)")
        let translationY =  CGRectGetHeight(bounds)
        
        nextReuseView.backgroundColor = UIColor.lightGrayColor()
        
        nextReuseView.transform = CGAffineTransformMakeTranslation(0, translationY)
        
        UIView.transitionWithView(self, duration: 0.2, options: [.BeginFromCurrentState],
            animations: {[unowned self] () -> Void in
                if let preresueView = preresueView {
                    self.sendSubviewToBack(preresueView)
                    preresueView.transform = CGAffineTransformMakeTranslation(0, translationY)
                    
                }
                self.addSubview(nextReuseView)
                nextReuseView.transform = CGAffineTransformMakeTranslation(0, 0)
                self.selectorView = nextReuseView
                
            })  {[weak self] (success) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    if let preresueView = preresueView {
                        if self?.selectorsQueue[type] != nil {
                            self?.selectorsQueue[type]! += [preresueView]
                        } else {
                            self?.selectorsQueue[type] = [preresueView]
                        }
                        preresueView.transform = CGAffineTransformIdentity
                    }
//                    print("willReove = \(preresueView)")
                    preresueView?.removeFromSuperview()
                    
//                    print("removeFinish = \(self?.selectorsQueue[.Size]?.count)")
                })
        }
    }
    
    
    
    
    
    

//    func changeTo(index: Int) {
//        
//        let v1 = UIView(frame: self.bounds)
//        
//        switch index % 3 {
//        case 0:
//            v1.backgroundColor = UIColor.lightGrayColor()
//            col = "red"
//        case 1:
//            v1.backgroundColor = UIColor.grayColor()
//            col = "blue"
//            
//        case 2:
//            v1.backgroundColor = UIColor.darkGrayColor()
//            col = "yellow"
//            
//        default:
//            v1.backgroundColor = UIColor.lightGrayColor()
//        }
//        
//        let pre = selectorView
//        v1.transform = CGAffineTransformMakeTranslation(0, 88)
//        
//        UIView.transitionWithView(self, duration: 0.2, options: [.BeginFromCurrentState], animations: {[unowned self] () -> Void in
//
//            if let pre = pre {
//                pre.transform = CGAffineTransformMakeTranslation(0, 88)
//                self.sendSubviewToBack(pre)
//            }
//            self.addSubview(v1)
//            v1.transform = CGAffineTransformMakeTranslation(0, 0)
//            self.selectorView = v1
//            
//            })  { (success) -> Void in
//
//                pre?.removeFromSuperview()
//        }
//
//    }

}
