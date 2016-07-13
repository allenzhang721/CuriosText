//
//  RecommandViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import MJRefresh

class RecommandViewController: UIViewController, CTALoadingProtocol {

    var headerView:UIView
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        self.initView()
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
        self.initCollectionView()
        self.initHeader()
    }
    
    func initHeader(){
        let bounds = UIScreen.mainScreen().bounds
        
        self.headerView = UIView(frame: CGRect(x: 0, y: 20, width: bounds.width, height: 44))
        self.headerView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.headerView)
        
        let homeLabel = UILabel(frame: CGRect(x: 0, y: 8, width: bounds.width, height: 28))
        homeLabel.font = UIFont.boldSystemFontOfSize(18)
        homeLabel.textColor = CTAStyleKit.normalColor
        homeLabel.text = NSLocalizedString("RecommendLabel", comment: "")
        homeLabel.textAlignment = .Center
        self.headerView.addSubview(homeLabel)
        let textLine = UIImageView(frame: CGRect(x: 0, y: 43, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        headerView.addSubview(textLine)
        self.view.addSubview(self.headerView)
    }
    
    func initCollectionView(){
        let bounds = UIScreen.mainScreen().bounds
        let rect:CGRect = CGRect(x: 0, y: 46, width: bounds.width, height: bounds.height-46)
        self.collectionLayout = UICollectionViewFlowLayout()
        
        let bounds = UIScreen.mainScreen().bounds
        let space:CGFloat = self.getCellSpace()
        let rect:CGRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        self.collectionLayout = CTACollectionViewStickyFlowLayout()
        
        self.collectionLayout.itemSize = self.getCellRect()
        self.collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        self.collectionLayout.minimumLineSpacing = self.collectionSpace
        self.collectionLayout.minimumInteritemSpacing = self.collectionSpace
        self.collectionView = UICollectionView(frame: rect, collectionViewLayout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CTAHomePublishesCell.self, forCellWithReuseIdentifier: "ctahomepublishescell")
        self.collectionView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.collectionView!);
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadFirstData))
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.collectionView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadLastData))
        self.footerFresh.refreshingTitleHidden = true
        self.footerFresh.setTitle("", forState: .Idle)
        self.footerFresh.setTitle("", forState: .NoMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        self.collectionView.mj_footer = footerFresh;
    }
}


