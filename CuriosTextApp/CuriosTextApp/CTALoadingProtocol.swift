//
//  CTALoadingProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/15.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

protocol CTALoadingProtocol{
    func showLoadingView(loadingImageView:UIImageView, superView:UIView)
    func hideLoadingView(loadingImageView:UIImageView)
    func getLoadingImages() -> [UIImage]
}

extension CTALoadingProtocol{
    
    func showLoadingView(loadingImageView:UIImageView, superView:UIView){
        loadingImageView.animationImages = self.getLoadingImages()
        loadingImageView.animationDuration = 1.0
        loadingImageView.animationRepeatCount = 0
        superView.addSubview(loadingImageView)
        loadingImageView.startAnimating()
    }
    
    func hideLoadingView(loadingImageView:UIImageView){
        loadingImageView.stopAnimating()
        loadingImageView.removeFromSuperview()
    }

    func getLoadingImages() -> [UIImage]{
        let animationImages:[UIImage] = [UIImage(named: "fresh-icon-1")!, UIImage(named: "fresh-icon-2")!, UIImage(named: "fresh-icon-3")!, UIImage(named: "fresh-icon-4")!, UIImage(named: "fresh-icon-5")!, UIImage(named: "fresh-icon-6")!, UIImage(named: "fresh-icon-7")!, UIImage(named: "fresh-icon-8")!, UIImage(named: "fresh-icon-9")!, UIImage(named: "fresh-icon-10")!, UIImage(named: "fresh-icon-11")!, UIImage(named: "fresh-icon-12")!]
        return animationImages
    }
}
