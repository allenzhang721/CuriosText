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
            self.controllerView.publishModel = self.publishModel
        }
    }
    
    var previewView:CTAPublishPreviewView!
    
    var controllerView:CTAPublishControllerView!
    
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
        self.controllerView = CTAPublishControllerView(frame: CGRect(x: 0, y: self.getViewSize().height, width: self.getViewSize().width, height: 100))
        self.contentView.addSubview(self.controllerView)
        self.controllerView.delegate = self
        self.backgroundColor = CTAStyleKit.commonBackgroundColor
        let textLine = UIImageView(frame: CGRect(x: 0, y: frame.size.height-1, width: frame.size.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        self.contentView.addSubview(textLine)
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
        self.delegate = nil
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
    func userIconTap(publishModel:CTAPublishModel?)
    func likeListTap(publishModel:CTAPublishModel?)
    func likeHandler(publishModel:CTAPublishModel?)
    func commentHandler(publishModel:CTAPublishModel?)
    func rebuildHandler(publishModel:CTAPublishModel?)
    func moreHandler(publishModel:CTAPublishModel?)
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

extension CTAHomePublishesCell: CTAPublishControllerDelegate{
    func userIconTap(){
        if self.delegate != nil{
            self.delegate?.userIconTap(self.publishModel)
        }
    }
    
    func likeListTap(){
        if self.delegate != nil{
            self.delegate?.likeListTap(self.publishModel)
        }
    }
    
    func likeHandler(){
        if self.delegate != nil{
            self.delegate?.likeHandler(self.publishModel)
        }
    }
    
    func commentHandler(){
        if self.delegate != nil{
            self.delegate?.commentHandler(self.publishModel)
        }
    }
    
    func rebuildHandler(){
        if self.delegate != nil{
            self.delegate?.rebuildHandler(self.publishModel)
        }
    }
    
    func moreHandler(){
        if self.delegate != nil{
            self.delegate?.moreHandler(self.publishModel)
        }
    }
}