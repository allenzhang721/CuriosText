//
//  CTAAddBarProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/29.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

func setAddBarView(barView:CTAAddBarView, view:UIView){
    barView.translatesAutoresizingMaskIntoConstraints = false
    barView.heightAnchor.constraintEqualToConstant(40).active = true
    barView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.8).active = true
    barView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    barView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
}

protocol CTAAddBarProtocol{
    func initAddBarView()
    func addBarViewClick(sender: UIPanGestureRecognizer)
    func addPublishHandler()
}

extension CTAAddBarProtocol where Self: UIViewController{
    func initAddBarView(){
        let barView = CTAAddBarView(frame: CGRect.zero)
        self.view.addSubview(barView)
        setAddBarView(barView, view: self.view)
        
        let addBarTap = UITapGestureRecognizer(target: self, action: "addBarViewClick:")
        barView.addGestureRecognizer(addBarTap)
    }
    
    func addPublishHandler(){
        print("addPublishHandler")
    }
}