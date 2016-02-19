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
    func showLoadingViewByView(centerView:UIView?)
    func hideLoadingView()
    func hideLoadingViewByView(centerView:UIView?)
    func getLoadingImages() -> [UIImage]
}

extension CTALoadingProtocol where Self: UIViewController{
    
    func showLoadingView(){
        if self.loadingImageView != nil {
            self.view.userInteractionEnabled = false
            self.loadingImageView!.animationImages = self.getLoadingImages()
            self.loadingImageView!.animationDuration = 1.0
            self.loadingImageView!.animationRepeatCount = 0
            if !self.loadingImageView!.isDescendantOfView(self.view){
                self.view.addSubview(self.loadingImageView!)
            }
            self.loadingImageView!.startAnimating()
        }
    }
    
    func showLoadingViewByView(centerView:UIView?){
        if self.loadingImageView != nil {
            if centerView != nil {
                centerView!.hidden = true
                self.loadingImageView!.center = self.view.convertPoint(centerView!.center, fromView: centerView!.superview)
            }else {
                let canvas = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 90))
                canvas.backgroundColor = UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
                canvas.clipsToBounds = true
                canvas.layer.cornerRadius = 8.0
                canvas.center = self.view.center
                self.view.addSubview(canvas)
                self.loadingImageView!.center = self.view.center
            }
            self.showLoadingView()
        }
    }
    
    func hideLoadingView(){
        if self.loadingImageView != nil {
            self.view.userInteractionEnabled = true
            self.loadingImageView!.stopAnimating()
            if self.loadingImageView!.isDescendantOfView(self.view){
                self.loadingImageView!.removeFromSuperview()
            }
        }
    }

    func hideLoadingViewByView(centerView:UIView?){
        if self.loadingImageView != nil {
            if centerView != nil {
                centerView!.hidden = false
            }else {
                let subViews = self.view.subviews
                if subViews.count > 1{
                    let canvas = subViews[subViews.count - 2]
                    canvas.removeFromSuperview()
                }
            }
            self.hideLoadingView()
        }
    }
    
    func getLoadingImages() -> [UIImage]{
        let animationImages:[UIImage] = [UIImage(named: "fresh-icon-1")!, UIImage(named: "fresh-icon-2")!, UIImage(named: "fresh-icon-3")!, UIImage(named: "fresh-icon-4")!, UIImage(named: "fresh-icon-5")!, UIImage(named: "fresh-icon-6")!, UIImage(named: "fresh-icon-7")!, UIImage(named: "fresh-icon-8")!, UIImage(named: "fresh-icon-9")!, UIImage(named: "fresh-icon-10")!, UIImage(named: "fresh-icon-11")!, UIImage(named: "fresh-icon-12")!]
        return animationImages
    }
}
