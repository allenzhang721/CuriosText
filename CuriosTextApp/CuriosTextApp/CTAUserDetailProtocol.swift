//
//  CTAUserDetailProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/25.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

protocol CTAUserDetailProtocol{
    func showUserDetailView(viewUser:CTAUserModel?, loginUserID:String)
}

extension CTAUserDetailProtocol where Self: UIViewController{
    func showUserDetailView(viewUser:CTAUserModel?, loginUserID:String) {
        CTAUserDetailViewController.getInstance().viewUser = viewUser
        CTAUserDetailViewController.getInstance().loginUserID = loginUserID
        CTAUserDetailViewController.getInstance().transitioningDelegate = CTAPullUserDetailTransition.getInstance()
        CTAUserDetailViewController.getInstance().modalPresentationStyle = .Custom
        self.presentViewController(CTAUserDetailViewController.getInstance(), animated: true) { () -> Void in
            CTAUserDetailViewController.getInstance().setBackgroundColor()
        }
    }
}

class CTAPullUserDetailTransition: NSObject, UIViewControllerTransitioningDelegate{
    
    var isPersent:Bool = false
    
    static var _instance:CTAPullUserDetailTransition?;
    
    static func getInstance() -> CTAPullUserDetailTransition{
        if _instance == nil{
            _instance = CTAPullUserDetailTransition();
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

extension CTAPullUserDetailTransition: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        if isPersent{
            return 1.0
        }else {
            return 0.1
        }
       
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey){
                transitionContext.containerView()!.addSubview(toView)
                toView.frame = CGRect.init(x: 0, y: 0-UIScreen.mainScreen().bounds.height, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    toView.frame = UIScreen.mainScreen().bounds
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
            }
        }
        if !isPersent{
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey){
                fromView.frame = CGRect.init(x: 0, y: 0-UIScreen.mainScreen().bounds.height, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}

