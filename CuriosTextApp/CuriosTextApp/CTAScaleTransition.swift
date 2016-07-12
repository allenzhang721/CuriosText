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
    
    var transitionBackView:UIView?
    
    var transitionAlpha:CGFloat = 1
    
    var bgView:UIView?
    
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
            return 0.2
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey){
                let view = transitionContext.containerView()!
                if self.bgView != nil {
                    view.addSubview(self.bgView!)
                }
                toView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                if self.fromRect != nil {
                    if self.toRect != nil {
                        toView.alpha = 1
                        if self.transitionBackView == nil {
                            self.transitionBackView = UIView(frame: toView.frame)
                            self.transitionBackView!.backgroundColor = CTAStyleKit.detailBackgroundColor
                        }
                        self.transitionBackView!.alpha = 0
                        view.addSubview(self.transitionBackView!)
                        if self.transitionView == nil {
                            self.transitionView = toView.snapshotViewAfterScreenUpdates(true)
                        }
                        self.transitionView!.frame = self.fromRect!
                        view.addSubview(self.transitionView!)
                        view.addSubview(toView)
                        toView.alpha = 0
                        self.alphaView?.alpha = 0
                        UIView.animateWithDuration(0.2, animations: {
                            self.transitionView!.frame = self.toRect!
                            self.transitionBackView!.alpha = self.transitionAlpha
                            }, completion: { (_) in
                                toView.alpha = 0
                                UIView.animateWithDuration(0.1, animations: {
                                    toView.alpha = 1
                                    }, completion: { (_) in
                                        self.alphaView?.alpha = 1
                                        self.transitionView!.removeFromSuperview()
                                        self.transitionBackView!.removeFromSuperview()
                                        self.trasitionComplete()
                                        transitionContext.completeTransition(true)
                                })
                        })
                    }else {
                        self.toRect = toView.frame
                        view.addSubview(toView)
                        let wChange = self.fromRect!.width / self.toRect!.width
                        let hChange = self.fromRect!.height / self.toRect!.height
                        toView.transform = CGAffineTransformMakeScale(wChange, hChange)
                        toView.center = CGPoint(x: self.fromRect!.origin.x + self.fromRect!.width/2, y: self.fromRect!.origin.y + self.fromRect!.height/2)
                        toView.alpha = 0
                        UIView.animateWithDuration(0.2, animations: {
                            toView.transform = CGAffineTransformMakeScale(1, 1)
                            toView.center = CGPoint(x: self.toRect!.width/2, y: self.toRect!.height/2)
                            toView.alpha = 1
                            }, completion: { (_) in
                                self.trasitionComplete()
                                transitionContext.completeTransition(true)
                        })
                    }
                }else {
                    view.addSubview(toView)
                    toView.alpha = 0
                    UIView.animateWithDuration(0.2, animations: {
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
                if self.toRect != nil {
                    if self.fromRect != nil {
                        if self.transitionBackView == nil {
                            self.transitionBackView = UIView(frame: fromView.frame)
                            self.transitionBackView!.backgroundColor = CTAStyleKit.detailBackgroundColor
                        }
                        self.transitionBackView!.alpha = self.transitionAlpha
                        view.addSubview(self.transitionBackView!)
                        if self.transitionView == nil {
                            self.transitionView = fromView.snapshotViewAfterScreenUpdates(true)
                        }
                        self.transitionView!.frame = self.fromRect!
                        view.addSubview(self.transitionView!)
                        fromView.alpha = 0
                        alphaView?.alpha = 0
                        UIView.animateWithDuration(0.2, animations: {
                            self.transitionView!.frame = self.toRect!
                            self.transitionBackView!.alpha = 0
                            }, completion: { (_) in
                                self.alphaView?.alpha = 1
                                self.transitionView!.removeFromSuperview()
                                self.transitionBackView!.removeFromSuperview()
                                fromView.removeFromSuperview()
                                self.trasitionComplete()
                                transitionContext.completeTransition(true)
                        })
                    }else {
                        self.fromRect = fromView.frame
                        UIView.animateWithDuration(0.2, animations: {
                            
                            let wChange = self.toRect!.width / self.fromRect!.width
                            let hChange = self.toRect!.height / self.fromRect!.height
                            fromView.transform = CGAffineTransformMakeScale(wChange, hChange)
                            fromView.center = CGPoint(x: self.toRect!.origin.x + self.toRect!.width/2, y: self.toRect!.origin.y + self.toRect!.height/2)
                            fromView.alpha = 0
                            }, completion: { (_) in
                                fromView.removeFromSuperview()
                                self.trasitionComplete()
                                transitionContext.completeTransition(true)
                        })
                    }
                }else {
                    fromView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                    fromView.alpha = 1
                    UIView.animateWithDuration(0.2, animations: {
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
        self.transitionBackView = nil
        self.transitionAlpha = 1
        if self.bgView != nil {
            self.bgView!.removeFromSuperview()
            self.bgView = nil
        }
    }
}