//
//  DetailViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class PublishDetailViewController: UIViewController {

    
    var selectedPublishID:String = ""
    
    var publishArray:Array<CTAPublishModel> = []
    
    var controllerView:CTAPublishControllerView!
    
    var currentPreviewCell:CTAPublishPreviewView!
    var previousPreviewCell:CTAPublishPreviewView!
    var nextPreviewCell:CTAPublishPreviewView!
    
    var delegate:PublishDetailViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        
        self.navigationController?.navigationBarHidden = true
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func initView(){
        let bounds = self.view.bounds
        let selectedPublish = self.getSelectedPublishModel()
        
        let currentSize = self.getViewRect(selectedPublish)
        self.currentPreviewCell = CTAPublishPreviewView(frame: CGRect(x: 0, y: (bounds.height - currentSize.height )/2 - 15, width: currentSize.width, height: currentSize.height))
        self.view.addSubview(self.currentPreviewCell)
        self.currentPreviewCell.animationEnable = true
        self.currentPreviewCell.publishModel = selectedPublish
        self.currentPreviewCell.loadImg()
        
        self.controllerView = CTAPublishControllerView(frame: CGRect(x: 0, y: 20, width: bounds.width, height: bounds.height-20))
        self.controllerView.type = .PublishDetail
        self.controllerView.publishModel = selectedPublish
        self.view.addSubview(self.controllerView)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        closeButton.setImage(UIImage(named: "close-button"), forState: .Normal)
        closeButton.setImage(UIImage(named: "close-selected-button"), forState: .Highlighted)
        closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
    }
    
    func closeButtonClick(sender: UIButton){
        var toRect:CGRect!
        var alphaView:UIView?
        if self.delegate != nil {
            if let paremt = self.delegate?.getPublishCell(self.selectedPublishID, publishArray: self.publishArray){
                toRect = paremt.0
                alphaView = paremt.1
            }else {
                toRect = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
        }else {
            toRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        let ani = CTAScaleTransition.getInstance()
        ani.transitionView = self.currentPreviewCell.snapshotViewAfterScreenUpdates(true)
        ani.transitionAlpha = 1
        ani.transitionBgColor = CTAStyleKit.commonBackgroundColor
        ani.fromRect = self.currentPreviewCell.frame
        ani.toRect = toRect
        ani.alphaView = alphaView
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    func getSelectedPublishModel() -> CTAPublishModel?{
        for i in 0..<self.publishArray.count {
            let publishModel = self.publishArray[i]
            if publishModel.publishID == self.selectedPublishID{
                return publishModel
            }
        }
        return nil
    }
    
    func getViewRect(publish:CTAPublishModel?) -> CGSize{
        let rect = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width)
        return rect;
    }
}

protocol PublishDetailViewDelegate: AnyObject{
    
    func changeCellSelected(selectedID:String, publishArray:Array<CTAPublishModel>)
    
    func getPublishCell(selectedID:String, publishArray:Array<CTAPublishModel>) -> (CGRect, UIView)?;
}
