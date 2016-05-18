//
//  CTAGIFProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/5/5.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import Kingfisher

protocol CTAGIFProtocol {
    
    func exportGIF(publishID: String, page: CTAPage, gifType:CTAGIFCreateType, viewController: UIViewController, completedHandler:((fileURL: NSURL, thumbImg: UIImage) -> ())?)
}

extension CTAGIFProtocol {
    
    func exportGIF(publishID: String, page: CTAPage, gifType:CTAGIFCreateType, viewController: UIViewController, completedHandler:((fileURL: NSURL, thumbImg: UIImage) -> ())?) {
        
        let fakeView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
        
        let canvas = page.toAniCanvas()
        
        // get Image
        
        let url = NSURL(string: CTAFilePath.publishFilePath + publishID)!
        
        for c in canvas.containers {
            if let content = c.contents.first where content.type == .Image {
                let imageName = content.content.source.ImageName
                let imageURL = url.URLByAppendingPathComponent(imageName)
                debug_print("imageURL = \(imageURL)")
                KingfisherManager.sharedManager.retrieveImageWithURL(imageURL, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                    let retriver = { (name: String,  handler: (String, UIImage?) -> ()) in
                        
                        debug_print("name = \(name), image = \(name)")
                        
                        handler(name, image)
                    }
                    
                    c.imageRetriver = retriver
                    //                        sf.readyPreView(canvas, publishModel: publishModel, completed: sf.readyCompleted)
                    
                    dispatch_async(dispatch_get_main_queue(), {
//                        guard let sf = self else {return}
                        
                        let gifCreatorVC = GIFCreateViewController()
                        gifCreatorVC.canvas = canvas
                        gifCreatorVC.publishID = publishID
                        gifCreatorVC.gifType = gifType
                        gifCreatorVC.progressBlock = {(progress, next) in
                            
                            debug_print(progress)
                            
                            next()
                        }
                        
                        gifCreatorVC.fakeView = fakeView
                        gifCreatorVC.completed = { (url, imageurl) in
                            dispatch_async(dispatch_get_main_queue(), {
                                gifCreatorVC.dismissViewControllerAnimated(true, completion: {
                                    completedHandler?(fileURL: url, thumbImg: UIImage(contentsOfFile: imageurl.path!)!)
                                })
//                                dispatch_async(dispatch_get_main_queue(), {
//                                    
//                                })
                            })
                        }
                        gifCreatorVC.transitioningDelegate = CTAFadeTransition.getInstance()
                        gifCreatorVC.modalPresentationStyle = .Custom
                        viewController.presentViewController(gifCreatorVC, animated: true, completion: {
                            debug_print(" did complated")
                            gifCreatorVC.began()
                        })
                        })
                    })
                
                break
            }
        }
        
    }
}

class CTAFadeTransition: NSObject, UIViewControllerTransitioningDelegate{
    
    var isPersent:Bool = false
    
    static var _instance:CTAFadeTransition?;
    
    static func getInstance() -> CTAFadeTransition{
        if _instance == nil{
            _instance = CTAFadeTransition();
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

extension CTAFadeTransition: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        if isPersent{
            return 0.1
        }else {
            return 0.1
        }
        
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey){
                transitionContext.containerView()!.addSubview(toView)
                toView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                toView.alpha = 1
                UIView.animateWithDuration(0.1, animations: { 
                    toView.alpha = 1
                    }, completion: { (_) in
                        transitionContext.completeTransition(true)
                })
            }
        }
        if !isPersent{
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey){
                fromView.alpha = 1
                UIView.animateWithDuration(0.1, animations: {
                    fromView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                    fromView.alpha = 1
                    }, completion: { (_) in
                        fromView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                })
            }
        }
    }
}