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
    
    func exportGIF(publishID: String, page: CTAPage, viewController: UIViewController, completedHandler:((fileURL: NSURL, thumbImg: UIImage) -> ())?)
}

extension CTAGIFProtocol {
    
    func exportGIF(publishID: String, page: CTAPage, viewController: UIViewController, completedHandler:((fileURL: NSURL, thumbImg: UIImage) -> ())?) {
        
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
                        
                        gifCreatorVC.progressBlock = {(progress, next) in
                            
                            debug_print(progress)
                            
                            next()
                        }
                        
                        gifCreatorVC.fakeView = fakeView
                        gifCreatorVC.completed = { (url, imageurl) in
                            dispatch_async(dispatch_get_main_queue(), {
                                completedHandler?(fileURL: url, thumbImg: UIImage(contentsOfFile: imageurl.path!)!)
                                dispatch_async(dispatch_get_main_queue(), {
                                    viewController.dismissViewControllerAnimated(false, completion: {
                                    })
                                })
                            })
                        }
                        viewController.presentViewController(gifCreatorVC, animated: false, completion: {
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