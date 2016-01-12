//
//  CTADocumentsViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAUserPublishesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var viewUser:CTAUserModel?;
    var loginUser:CTAUserModel?;
    var isLoginUser:Bool = false;
    
    var collectionView:UICollectionView!;
    var viewToolBar:UIView!;
    var userHeaderView:UIView!;
    var userIconImage:UIImageView!;
    var userNikenameLabel:UILabel!;
    
    let backButton:UIButton = UIButton.init(frame: CGRect.init(x: 10, y: 12, width: 12, height: 20))
    let homeViewButton:UIButton = UIButton.init(frame: CGRect.init(x: 10, y: 10, width: 30, height: 24));
    var settingButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initCollectionView();
        self.initViewNavigateBar();
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadLocalUserModel()
        if viewUser == nil {
            viewUser = loginUser
            self.isLoginUser = true
        }
        self.setViewNavigateBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadUserPublishes()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewUser  = nil
        self.loginUser = nil
        self.isLoginUser = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCollectionView(){
        let space:CGFloat = 10.00/375.00*self.view.frame.width
        let rect:CGRect = CGRect.init(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 44)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let itemWidth = (self.view.frame.width - space * 3)/2
        
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        
        self.collectionView = UICollectionView.init(frame: rect, collectionViewLayout: layout)
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.registerClass(CTAPublishesCell.self, forCellWithReuseIdentifier: "ctaPublishesCell")
        self.view.addSubview(self.collectionView!);
        self.collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let publishesCell:CTAPublishesCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ctaPublishesCell", forIndexPath: indexPath) as! CTAPublishesCell
        
        indexPath.section
        return publishesCell
    }

    func loadLocalUserModel(){
        self.loginUser = CTAUserModel.init(userID: "ae7ca2d8590f4709ad73286920fa522f", nikeName: "美丽俏佳人231fjdksaljfkdljaklfjajklfjdkaljfkldsa", userDesc: "美丽俏佳人231", userIconURL: "5416b04634fb4d0daed0e9f8ce10801d/icon.jpg", sex: 1)
    }
    
    func initViewNavigateBar(){
        
        self.userHeaderView = UIView.init(frame: CGRectMake(62,0,self.view.frame.size.width-124, 44))
        self.userIconImage = UIImageView.init(frame: CGRect.init(x: (self.userHeaderView.frame.width-25)/2, y: 9, width: 26, height: 26));
        self.userNikenameLabel = UILabel.init(frame: CGRect.init(x: (self.userHeaderView.frame.width-100)/2, y: 14, width: 100, height: 16))
        self.userNikenameLabel.font = UIFont.systemFontOfSize(12)
        self.settingButton = UIButton.init(frame: CGRect.init(x: self.view.frame.width - 42, y: 10, width: 32, height: 24))
        self.settingButton.backgroundColor = UIColor.redColor()
        self.homeViewButton.backgroundColor = UIColor.grayColor()
        self.backButton.backgroundColor = UIColor.greenColor()
        self.viewToolBar = UIView()
        self.viewToolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        self.userHeaderView.addSubview(self.userIconImage)
        self.userHeaderView.addSubview(self.userNikenameLabel)
        self.viewToolBar.addSubview(self.userHeaderView)
        self.viewToolBar.addSubview(self.settingButton)
        self.viewToolBar.addSubview(self.homeViewButton)
        self.viewToolBar.addSubview(self.backButton)
        self.view.addSubview(self.viewToolBar)
    
        let tap = UITapGestureRecognizer(target: self, action: "userHeaderClick:")
        self.userHeaderView.addGestureRecognizer(tap)
        self.settingButton.addTarget(self, action: "settingButtonClick:", forControlEvents: .TouchUpInside)
        self.homeViewButton.addTarget(self, action: "homeViewButtonClick:", forControlEvents: .TouchUpInside)
        self.backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
    }
    
    func setViewNavigateBar(){
        self.userIconImage.backgroundColor = UIColor.yellowColor()
        if self.isLoginUser {
            self.settingButton.hidden = false
            self.homeViewButton.hidden = false
            self.backButton.hidden = true
        }else {
            self.settingButton.hidden = true
            self.homeViewButton.hidden = true
            self.backButton.hidden = false
        }
        self.userNikenameLabel.text = self.viewUser?.nikeName
        self.userNikenameLabel.sizeToFit()
        let maxWidth = self.userHeaderView.frame.width - 30
        var labelWidth = self.userNikenameLabel.frame.width
        if self.userNikenameLabel.frame.width > maxWidth {
            labelWidth = maxWidth
        }
        let imgX = (self.userHeaderView.frame.width - labelWidth - 30)/2
        self.userNikenameLabel.frame = CGRect.init(x: imgX+30, y: 14, width: labelWidth, height: 16)
        self.userIconImage.frame = CGRect.init(x: imgX, y: 9, width: 26, height: 26)
        //let imagePath = CTAFilePath.userFilePath+self.viewUser?.userIconURL
    }
    
    func userHeaderClick(sender: UITapGestureRecognizer){
        print("header click")
    }
    
    func settingButtonClick(sender: UIButton){
        print("setting button click")
    }
    
    func backButtonClick(sender: UIButton){
        print("back button click")
    }
    
    func homeViewButtonClick(sender: UIButton){
        print("homeView button click")
    }
    
    func loadUserPublishes(){
        
        //        CTAPublishDomain.getInstance().userPublishList(self.viewUser!.userID, beUserID: self.viewUser!.userID, start: 0, size: 20) { (info) -> Void in
        //
        //        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
