//
//  CTAUserDetailProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/25.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

protocol CTAUserDetailProtocol{
    var userDetailViewController:CTAUserDetailViewController{ get }
    var userDetailTransition:CTAPullUserDetailTransition{ get }
    func showUserDetailView(viewUser:CTAUserModel?, loginUserID:String)
}

extension CTAUserDetailProtocol where Self: UIViewController{
    func showUserDetailView(viewUser:CTAUserModel?, loginUserID:String) {
        self.userDetailViewController
        self.userDetailViewController.viewUser = viewUser
        self.userDetailViewController.loginUserID = loginUserID
        self.userDetailViewController.transitioningDelegate = self.userDetailTransition
        self.userDetailViewController.modalPresentationStyle = .Custom
        self.presentViewController(self.userDetailViewController, animated: true) { () -> Void in
            self.userDetailViewController.setBackgroundColor()
        }
    }
}

class CTAPullUserDetailTransition: NSObject, UIViewControllerTransitioningDelegate{
    
    var isPersent:Bool = false
    
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
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey){
                transitionContext.containerView()!.addSubview(toView)
                toView.frame = CGRect.init(x: 0, y: 0-UIScreen.mainScreen().bounds.height, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    toView.frame = UIScreen.mainScreen().bounds
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
            }
        }
        if !isPersent{
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey){
                UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    fromView.frame = CGRect.init(x: 0, y: 0-UIScreen.mainScreen().bounds.height, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                    }, completion: { (_) -> Void in
                        fromView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                })
            }
        }
    }
}

