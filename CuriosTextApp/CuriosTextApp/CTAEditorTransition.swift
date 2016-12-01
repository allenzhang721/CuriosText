//
//  EditorTration.swift
//  CuriosTextApp
//
//  Created by allen on 16/7/17.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

class CTAEditorTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    var isPersent:Bool = false
    
    static var _instance:CTAEditorTransition?;
    
    var rootView:UIView?
    
    static func getInstance() -> CTAEditorTransition{
        if _instance == nil{
            _instance = CTAEditorTransition();
        }
        return _instance!
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPersent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPersent = false
        return self
    }
}

extension CTAEditorTransition: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        if isPersent{
            return 0.3
        }else {
            return 0.3
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to){
                let view = transitionContext.containerView
                let bounds = UIScreen.main.bounds
                toView.frame = CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height)
                if self.rootView != nil {
                    let bgView = UIView(frame: bounds)
                    bgView.backgroundColor = CTAStyleKit.commonBackgroundColor
                    view.addSubview(bgView)
                    view.addSubview(toView)
                    self.rootView!.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
                    view.addSubview(self.rootView!)
                    toView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    UIView.animate(withDuration: 0.3, animations: {
                        self.rootView!.frame.origin.y = bounds.height
                        toView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }, completion: { (_) in
                            self.rootView?.removeFromSuperview()
                            bgView.removeFromSuperview()
                            transitionContext.completeTransition(true)
                    })
                }else {
                    view.addSubview(toView)
                    toView.alpha = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        toView.alpha = 1
                        }, completion: { (_) in
                            transitionContext.completeTransition(true)
                    })
                }
            }
        }
        if !isPersent{
            if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from){
                let view = transitionContext.containerView
                let bounds = UIScreen.main.bounds
                fromView.frame = CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height)
                if self.rootView != nil {
                    let bgView = UIView(frame: bounds)
                    bgView.backgroundColor = CTAStyleKit.commonBackgroundColor
                    view.insertSubview(bgView, belowSubview: fromView)
                    
                    self.rootView!.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: bounds.height)
                    view.addSubview(self.rootView!)
                    fromView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.3, animations: {
                        self.rootView!.frame.origin.y = 0
                        fromView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                        }, completion: { (_) in
                            self.rootView?.removeFromSuperview()
                            self.rootView = nil
                            fromView.removeFromSuperview()
                            transitionContext.completeTransition(true)
                    })
                }else {
                    fromView.alpha = 1
                    UIView.animate(withDuration: 0.3, animations: {
                        fromView.alpha = 0
                        }, completion: { (_) in
                            fromView.removeFromSuperview()
                            transitionContext.completeTransition(true)
                    })
                }
            }
        }
    }
}
