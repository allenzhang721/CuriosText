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
    
    func exportGIF(_ publishID: String, page: CTAPage, gifType:CTAGIFCreateType, viewController: UIViewController, completedHandler:((_ fileURL: URL, _ thumbImg: UIImage) -> ())?)
}

extension CTAGIFProtocol {
    
    func exportGIF(_ publishID: String, page: CTAPage, gifType:CTAGIFCreateType, viewController: UIViewController, completedHandler:((_ fileURL: URL, _ thumbImg: UIImage) -> ())?) {
        
        let fakeView = UIScreen.main.snapshotView(afterScreenUpdates: true)
        
        let canvas = page.toAniCanvas()
        
        // get Image
        
        let url = URL(string: CTAFilePath.publishFilePath + publishID)!
        
        for c in canvas.containers {
            if let content = c.contents.first, content.type == .Image {
                let imageName = content.content.source.ImageName
                let imageURL = url.appendingPathComponent(imageName)
                debug_print("imageURL = \(imageURL)")
                KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                    let retriver = { (name: String,  handler: (String, UIImage?) -> ()) in
                        
                        debug_print("name = \(name), image = \(name)")
                        
                        handler(name, image)
                    }
                    
                    c.imageRetriver = retriver
                    //                        sf.readyPreView(canvas, publishModel: publishModel, completed: sf.readyCompleted)
                    
                    DispatchQueue.main.async(execute: {
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
                          DispatchQueue.main.async { [weak gifCreatorVC] in
                            gifCreatorVC?.dismiss(animated: true, completion: {
                              let data = NSData(contentsOf: imageurl)
                              completedHandler?(url, UIImage(data: data! as Data, scale: 0.1)!)
                            })
                          }
                        }
                        gifCreatorVC.transitioningDelegate = CTAFadeTransition.getInstance()
                        gifCreatorVC.modalPresentationStyle = .custom
                        viewController.present(gifCreatorVC, animated: true, completion: {
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

extension CTAFadeTransition: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        if isPersent{
            return 0.1
        }else {
            return 0.1
        }
        
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to){
                transitionContext.containerView.addSubview(toView)
                toView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                toView.alpha = 1
                UIView.animate(withDuration: 0.1, animations: { 
                    toView.alpha = 1
                    }, completion: { (_) in
                        transitionContext.completeTransition(true)
                })
            }
        }
        if !isPersent{
            if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from){
                fromView.alpha = 1
                UIView.animate(withDuration: 0.1, animations: {
                    fromView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    fromView.alpha = 1
                    }, completion: { (_) in
                        fromView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                })
            }
        }
    }
}
