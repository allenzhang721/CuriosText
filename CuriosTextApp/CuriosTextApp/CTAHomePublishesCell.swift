//
//  CTAHomePublishesCell.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/19.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher

class CTAHomePublishesCell: UICollectionViewCell{

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    var publishModel:CTAPublishModel?{
        didSet{
            self.didSetPublishModel()
        }
    }
    
    var previewView:CTAPublishPreviewView!
    
    var delegate:CTAHomePublishesCellDelegate?
    
    var isLoadViewTask:Bool = false
    
    var isLoadComplete:Bool = false
    
    var isPlayed:Bool = false
    
    var loadViewTask:Task?
    
    var loadCompeteHandler:(() -> Void)?
    
    func initView(){
        self.previewView = CTAPublishPreviewView(frame: self.getViewSize())
        self.contentView.addSubview(self.previewView)
        self.previewView.animationEnable = true
        self.previewView.delegate = self
        
        self.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    func didSetPublishModel(){
        if self.publishModel != nil{
            self.previewView.publishModel = self.publishModel
            self.previewView.loadImg()
            self.isLoadComplete = false
            self.beginLoadView()
        }
    }
    
    func beginLoadView(){
        if !self.isLoadViewTask && !self.isLoadComplete{
            self.isLoadViewTask = true
            self.loadViewTask = delay(1.0){
                if self.isLoadViewTask{
                    self.loadView()
                }
                self.isLoadViewTask = false
            }
        }
    }
    
    func cancelLoadView(){
        if self.isLoadViewTask {
            if self.loadViewTask != nil{
                cancel(self.loadViewTask)
                self.loadViewTask = nil
                self.isLoadViewTask = false
            }
        }
    }
    
    func loadView(){
        self.previewView.loadPreviewView()
    }
    
    func releaseView(){
        self.cancelLoadView()
        self.previewView.releasePreviewView()
        self.previewView.releaseImg()
        self.publishModel = nil
        self.isLoadComplete = false
        self.loadCompeteHandler = nil
        self.isPlayed = false
    }
    
    func playAnimation(){
        if self.isLoadComplete{
            if !self.isPlayed{
                self.previewView.playAnimation()
                self.isPlayed = true
            }
        }else {
            self.loadCompeteHandler = self.playAnimation
        }
    }
    
    func getViewSize() -> CGRect{
        let rect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        return rect
    }
}

protocol CTAHomePublishesCellDelegate {
    
}

extension CTAHomePublishesCell: CTAPublishPreviewViewDelegate{
    func beginLoad(){
        
    }
    
    func loadComplete(){
        self.isLoadComplete = true
        if self.loadCompeteHandler != nil {
            self.loadCompeteHandler!()
        }
    }
    
    func loadFailed(){
        
    }
}