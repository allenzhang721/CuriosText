//
//  CTALoadingProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/15.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

protocol CTALoadingProtocol{
    var loadingImageView:UIImageView?{get}
    func showLoadingView()
    func hideLoadingView()
    func getLoadingImages() -> [UIImage]
}

extension CTALoadingProtocol where Self: UIViewController{
    
    func showLoadingView(){
        if self.loadingImageView != nil {
            self.loadingImageView!.animationImages = self.getLoadingImages()
            self.loadingImageView!.animationDuration = 1.0
            self.loadingImageView!.animationRepeatCount = 0
            self.view.addSubview(self.loadingImageView!)
            self.loadingImageView!.startAnimating()
        }
    }
    
    func hideLoadingView(){
        if self.loadingImageView != nil {
            self.loadingImageView!.stopAnimating()
            self.loadingImageView!.removeFromSuperview()

        }
    }

    func getLoadingImages() -> [UIImage]{
        let animationImages:[UIImage] = [UIImage(named: "fresh-icon-1")!, UIImage(named: "fresh-icon-2")!, UIImage(named: "fresh-icon-3")!, UIImage(named: "fresh-icon-4")!, UIImage(named: "fresh-icon-5")!, UIImage(named: "fresh-icon-6")!, UIImage(named: "fresh-icon-7")!, UIImage(named: "fresh-icon-8")!, UIImage(named: "fresh-icon-9")!, UIImage(named: "fresh-icon-10")!, UIImage(named: "fresh-icon-11")!, UIImage(named: "fresh-icon-12")!]
        return animationImages
    }
}
