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
    func showLoadingViewByView(_ centerView:UIView)
    func showLoadingViewInView(_ centerView:UIView)
    func showLoadingViewByRect(_ rect:CGRect)
    func hideLoadingView()
    func hideLoadingViewByView(_ centerView:UIView)
    func hideLoadingViewInView(_ centerView:UIView)
    func getLoadingImages() -> [UIImage]
}

extension CTALoadingProtocol where Self: UIViewController{
    
    func showLoadingView(){
        if self.loadingImageView != nil {
            self.view.isUserInteractionEnabled = false
            self.loadingImageView!.animationImages = self.getLoadingImages()
            self.loadingImageView!.animationDuration = 1.0
            self.loadingImageView!.animationRepeatCount = 0
            if !self.loadingImageView!.isDescendant(of: self.view){
                self.view.addSubview(self.loadingImageView!)
            }
            self.loadingImageView!.startAnimating()
        }
    }
    
    func showLoadingViewByView(_ centerView:UIView){
        if self.loadingImageView != nil {
            centerView.isHidden = true
            self.loadingImageView!.center = self.view.convert(centerView.center, from: centerView.superview)
            self.showLoadingView()
        }
    }
    
    func showLoadingViewInView(_ centerView:UIView){
        let viewFrame = centerView.frame
        let indicaW = viewFrame.width>viewFrame.height ? viewFrame.height : viewFrame.width
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: indicaW, height: indicaW)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = CGPoint(x: viewFrame.width / 2, y: viewFrame.height / 2)
        centerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func showLoadingViewByRect(_ rect:CGRect){
        if self.loadingImageView != nil {
            self.loadingImageView!.center = CGPoint(x: (rect.origin.x + rect.width/2), y: (rect.origin.y + rect.height/2))
            self.showLoadingView()
        }
    }
    
    func hideLoadingView(){
        if self.loadingImageView != nil {
            self.view.isUserInteractionEnabled = true
            self.loadingImageView!.stopAnimating()
            if self.loadingImageView!.isDescendant(of: self.view){
                self.loadingImageView!.removeFromSuperview()
            }
        }
    }

    func hideLoadingViewByView(_ centerView:UIView){
        if self.loadingImageView != nil {
            centerView.isHidden = false
            self.hideLoadingView()
        }
    }
    
    func hideLoadingViewInView(_ centerView:UIView){
        let subVies = centerView.subviews
        let subView = subVies[subVies.count-1]
        if subView is UIActivityIndicatorView{
            (subView as! UIActivityIndicatorView).stopAnimating()
            subView.removeFromSuperview()
        }
        self.view.isUserInteractionEnabled = true
    }
    
    func getLoadingImages() -> [UIImage]{
        let animationImages:[UIImage] = [UIImage(named: "fresh-icon-1")!, UIImage(named: "fresh-icon-2")!, UIImage(named: "fresh-icon-3")!, UIImage(named: "fresh-icon-4")!, UIImage(named: "fresh-icon-5")!, UIImage(named: "fresh-icon-6")!, UIImage(named: "fresh-icon-7")!, UIImage(named: "fresh-icon-8")!, UIImage(named: "fresh-icon-9")!, UIImage(named: "fresh-icon-10")!, UIImage(named: "fresh-icon-11")!, UIImage(named: "fresh-icon-12")!]
        return animationImages
    }
}
