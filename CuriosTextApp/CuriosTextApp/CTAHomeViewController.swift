//
//  CTAHomeViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAHomeViewController: UIViewController, CTAPublishCellProtocol, CTALoginProtocol{

    var loginUser:CTAUserModel?
    
    var publishModelArray:Array<CTAPublishModel> = []
    var selectedPublishID:String = ""

    var userIconImage:UIImageView = UIImageView()
    var userNicknameLabel:UILabel = UILabel()
    var likeButton:UIButton = UIButton()
    
    var currentFullCell:CTAFullPublishesCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.initView()
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadLocalUserModel()
        self.loadNewPublishes()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
        let fullSize = self.getFullCellRect(nil, rate: 1.0)
        self.currentFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        self.view.addSubview(self.currentFullCell!)
        self.currentFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
       //self.currentFullCell.animationEnable = true
        self.currentFullCell.publishModel = nil
        
        self.initPublishSubView(CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height), horRate: self.getHorRate())
    }
    
    func loadNewPublishes(){
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        CTAPublishDomain.getInstance().newPublishList(userID, start: 0) { (info) -> Void in
            if info.result {
                self.publishModelArray.removeAll()
                let modelArray = info.modelArray
                for var i=0; i < modelArray!.count; i++ {
                    let publishModel = modelArray![i] as! CTAPublishModel
                    self.publishModelArray.append(publishModel)
                }
                if self.publishModelArray.count > 0{
                   self.changeViewByPublishModel(self.publishModelArray[0])
                }
            }
            
        }
    }
    
    func loadLocalUserModel(){
        if CTAUserManager.load(){
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
    }

    func changeViewByPublishModel(publishModel:CTAPublishModel){
        self.currentFullCell.publishModel = publishModel
        self.changeUserView(publishModel.userModel)
    }
}

extension CTAHomeViewController: CTAPublishProtocol{
    func likeButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else if let publishModel = self.currentFullCell.publishModel{
            self.likeHandler(self.loginUser!.userID, publishModel: publishModel)
        }
    }
    
    func shareButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else if let publishModel = self.currentFullCell.publishModel{
            self.shareHandler(self.loginUser!.userID, publishModel: publishModel)
        }
    }
    
    func rebuildButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else if let publishModel = self.currentFullCell.publishModel{
            self.rebuildHandler(self.loginUser!.userID, publishModel: publishModel)
        }
    }
    
    func userIconClick(sender: UIPanGestureRecognizer) {
        if let publishModel = self.currentFullCell.publishModel{
            let userID = self.loginUser == nil ? "" : self.loginUser!.userID
            self.showUserDetailHandler(publishModel.userModel, loginUserID: userID)
        }
    }
}
