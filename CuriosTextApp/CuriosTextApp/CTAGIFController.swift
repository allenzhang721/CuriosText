//
//  CTAGIFController.swift
//  CuriosTextApp
//
//  Created by allen on 16/5/4.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

class CTAGIFController {
    
    
    static var _instance:CTAGIFController?;
    
    static func getInstance() -> CTAGIFController{
        if _instance == nil{
            _instance = CTAGIFController();
        }
        return _instance!
    }
    
    func createGIF(viewController: UIViewController, page: CTAPage, publishID: String, complete:((NSURL, UIImage) -> ())?) {
        let gifCreatorVC = GIFCreateViewController()
        gifCreatorVC.canvas = page.toAniCanvas()
        gifCreatorVC.publishID = publishID
        gifCreatorVC.fakeView = viewController.view.snapshotViewAfterScreenUpdates(true)
        gifCreatorVC.completed = { (url, image) in
            dispatch_async(dispatch_get_main_queue(), {
                if complete != nil {
                    complete!(url, image)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    viewController.dismissViewControllerAnimated(false, completion: {
                    })
                })
            })
        }
        dispatch_async(dispatch_get_main_queue()) {
            viewController.presentViewController(gifCreatorVC, animated: false, completion: nil)
        }
    }
    
}