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
    
    var prePublishID:String = ""
    
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
    
    var loadViewTask:Task?
    
    var loadCompeteHandler:(() -> Void)?
    
    var isDoubleClick:Bool = false
    
    func initView(){
        let bgView = UIView(frame: self.getViewRect())
        self.contentView.addSubview(bgView)
        bgView.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
        self.previewView = CTAPublishPreviewView(frame: self.getViewRect())
        self.contentView.addSubview(self.previewView)
        self.previewView.animationEnable = true
        self.previewView.delegate = self
        self.controllerView = CTAPublishControllerView(frame: self.bounds)
        self.contentView.addSubview(self.controllerView)
        self.controllerView.delegate = self
        self.backgroundColor = CTAStyleKit.commonBackgroundColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        self.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(_:)))
        tap2.numberOfTapsRequired=2
        tap2.numberOfTouchesRequired=1
        self.addGestureRecognizer(tap2)
    }
    
    func didSetPublishModel(){
        if self.publishModel != nil && self.prePublishID != self.publishModel!.publishID{
            self.previewView.publishModel = self.publishModel
            self.previewView.loadImg()
            self.isLoadComplete = false
            self.beginLoadView()
            self.prePublishID = self.publishModel!.publishID
        }
    }
    
    func beginLoadView(){
        if !self.isLoadViewTask && !self.isLoadComplete{
            self.isLoadViewTask = true
            self.loadViewTask = delay(1.0){
                cancel(self.loadViewTask)
                self.loadViewTask = nil
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
        self.prePublishID = ""
        self.isLoadComplete = false
        self.loadCompeteHandler = nil
        self.delegate = nil
    }
    
    func playAnimation(){
        if self.isLoadComplete{
            self.previewView.playAnimation()
        }else {
            self.loadCompeteHandler = self.playAnimation
        }
    }
    
    func stopAnimation(){
        if self.isLoadComplete{
            self.previewView.stopAnimation();
        }
    }
    
    func getViewRect() -> CGRect{
        let rect = CGRect(x: 0, y: 50, width: frame.size.width, height: frame.size.width)
        return rect;
    }
    
    func changeLikeStatus(publichModel:CTAPublishModel?){
        self.controllerView.publishModel = publichModel
        self.controllerView.changeLikeStatus()
        if let model = publichModel{
            if model.likeStatus == 1{
                dispatch_async(dispatch_get_main_queue(), {
                    let heartView = CTAHeartAnimationView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
                    heartView.center = self.previewView.center
                    self.contentView.addSubview(heartView)
                    heartView.playLikeAnimation(nil)
                    self.controllerView.playLikeAnimation()
                })
            }
        }
    }
    
    func singleTapHandler(sender: UIPanGestureRecognizer) {
        delay(0.2, task: {
            if !self.isDoubleClick {
                if self.delegate != nil{
                    self.delegate?.cellSingleTap(self)
                }
            }
            self.isDoubleClick = false
        })
    }
    
    func doubleTapHandler(sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.isDoubleClick = true
            self.delegate?.cellDoubleTap(self)
        }
    }
}

protocol CTAHomePublishesCellDelegate {
    func cellUserIconTap(cell:CTAHomePublishesCell?)
    func cellLikeListTap(cell:CTAHomePublishesCell?)
    func cellLikeHandler(cell:CTAHomePublishesCell?, justLike:Bool)
    func cellCommentHandler(cell:CTAHomePublishesCell?)
    func cellRebuildHandler(cell:CTAHomePublishesCell?)
    func cellMoreHandler(cell:CTAHomePublishesCell?)
    
    func cellDoubleTap(cell:CTAHomePublishesCell?)
    func cellSingleTap(cell:CTAHomePublishesCell?)
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

    func controlUserIconTap(){
        if self.delegate != nil{
            self.delegate?.cellUserIconTap(self)
        }
    }
    
    func controlLikeListTap(){
        if self.delegate != nil{
            self.delegate?.cellLikeListTap(self)
        }
    }
    
    func controlLikeHandler(){
        if self.delegate != nil{
            self.delegate?.cellLikeHandler(self, justLike:false)
        }
    }
    
    func controlCommentHandler(){
        if self.delegate != nil{
            self.delegate?.cellCommentHandler(self)
        }
    }
    
    func controlRebuildHandler(){
        if self.delegate != nil{
            self.delegate?.cellRebuildHandler(self)
        }
    }
    
    func controlMoreHandler(){
        if self.delegate != nil{
            self.delegate?.cellMoreHandler(self)
        }
    }
    
    func controlCloseHandler(){

    }
}