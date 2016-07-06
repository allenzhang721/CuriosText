//
//  PopupAni.swift
//  TestFilePopup
//
//  Created by allen on 16/7/5.
//  Copyright © 2016年 com.horner.storyboard.demo. All rights reserved.
//

import UIKit

class CTAScaleTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    var isPersent:Bool = false
    
    static var _instance:CTAScaleTransition?;
    
    var fromRect:CGRect?
    
    var toRect:CGRect?
    
    var transitionView:UIView?
    
    var transitionBgColor:UIColor?
    
    var transitionAlpha:CGFloat = 1
    
    weak var alphaView:UIView?
    
    static func getInstance() -> CTAScaleTransition{
        if _instance == nil{
            _instance = CTAScaleTransition();
        }
        return _instance!
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPersent = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPersent = false
        return self
    }
}

extension CTAScaleTransition: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        if isPersent{
            return 0.3
        }else {
            return 0.3
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey){
                let view = transitionContext.containerView()!
                view.addSubview(toView)
                toView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                if self.fromRect != nil {
                    if self.toRect == nil {
                        self.toRect = toView.frame
                    }
                    toView.alpha = 1
                    let backView = UIView(frame: toView.frame)
                    backView.backgroundColor = self.transitionBgColor
                    backView.alpha = 0
                    view.addSubview(backView)
                    if self.transitionView == nil {
                        self.transitionView = toView.snapshotViewAfterScreenUpdates(true)
                    }
                    self.transitionView!.frame = self.fromRect!
                    view.addSubview(self.transitionView!)
                    toView.alpha = 0
                    self.alphaView?.alpha = 0
                    UIView.animateWithDuration(0.3, animations: {
                        self.transitionView!.frame = self.toRect!
                        backView.alpha = self.transitionAlpha
                        }, completion: { (_) in
                            toView.alpha = 1
                            self.alphaView?.alpha = 1
                            self.transitionView!.removeFromSuperview()
                            backView.removeFromSuperview()
                            self.trasitionComplete()
                            transitionContext.completeTransition(true)
                    })
                }else {
                    toView.alpha = 1
                    UIView.animateWithDuration(0.3, animations: {
                        toView.alpha = 1
                        }, completion: { (_) in
                            self.trasitionComplete()
                            transitionContext.completeTransition(true)
                    })
                }
            }
        }
        if !isPersent{
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey){
                let view = transitionContext.containerView()!
                fromView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                if self.toRect != nil {
                    fromView.alpha = 1
                    if self.fromRect != nil {
                        self.fromRect = fromView.frame
                    }
                    let backView = UIView(frame: fromView.frame)
                    backView.backgroundColor = self.transitionBgColor
                    backView.alpha = self.transitionAlpha
                    view.addSubview(backView)
                    if self.transitionView == nil {
                        self.transitionView = fromView.snapshotViewAfterScreenUpdates(true)
                    }
                    self.transitionView!.frame = self.fromRect!
                    view.addSubview(self.transitionView!)
                    fromView.alpha = 0
                    alphaView?.alpha = 0
                    UIView.animateWithDuration(0.3, animations: {
                        self.transitionView!.frame = self.toRect!
                        backView.alpha = 0
                        }, completion: { (_) in
                            fromView.alpha = 1
                            self.alphaView?.alpha = 1
                            self.transitionView!.removeFromSuperview()
                            backView.removeFromSuperview()
                            fromView.removeFromSuperview()
                            self.trasitionComplete()
                            transitionContext.completeTransition(true)
                    })
                }else {
                    fromView.alpha = 1
                    UIView.animateWithDuration(0.3, animations: {
                        fromView.alpha = 1
                        }, completion: { (_) in
                            fromView.removeFromSuperview()
                            self.trasitionComplete()
                            transitionContext.completeTransition(true)
                    })
                }
            }
        }
    }
    
    func trasitionComplete(){
        self.transitionView = nil
        self.fromRect = nil
        self.toRect = nil
        self.transitionBgColor = nil
        self.transitionAlpha = 1
    }
}