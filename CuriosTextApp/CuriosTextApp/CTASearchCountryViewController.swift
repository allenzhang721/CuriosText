//
//  CTASearchCountryViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/31.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit


protocol CTACountryDelegate: NSObjectProtocol {
    func setCountryCode(model:CountryZone)
}

class CTASearchCountryViewController: UIViewController{
    
    static var _instance:CTASearchCountryViewController?;
    
    static func getInstance() -> CTASearchCountryViewController{
        if _instance == nil{
            _instance = CTASearchCountryViewController();
        }
        return _instance!
    }
    
    var selectedDelegate: CTACountryDelegate?
    let allCountryLocale = LocaleHelper.allCountriesFromLocalFile()
    
    var searchArray:Dictionary<String, Array<CountryZone>>!
    
    var tableView: UITableView!
    var searchBar : UISearchBar!
    var selectedIndexPath: NSIndexPath?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
        let bouns = UIScreen.mainScreen().bounds
        self.searchArray = self.allCountryLocale
        let searchLabel = UILabel.init(frame: CGRect.init(x: 0, y: 8, width: bouns.width, height: 28))
        searchLabel.font = UIFont.systemFontOfSize(18)
        searchLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        searchLabel.text = NSLocalizedString("SearchLabel", comment: "")
        searchLabel.textAlignment = .Center
        self.view.addSubview(searchLabel)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        self.searchBar = UISearchBar.init(frame: CGRect.init(x: 0, y: 44, width: bouns.width, height: 50))
        self.searchBar.delegate = self
        self.view.addSubview(self.searchBar)
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 94, width: bouns.width, height: bouns.height - 103))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(CTASearchTabelCell.self, forCellReuseIdentifier: "ctasearchtabelcell")
        self.view.addSubview(self.tableView)
    }
    
    func backButtonClick(sender: UIButton){
        self.backHandler()
    }
    
    func backHandler(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func resetView(){
        if self.searchBar.showsCancelButton{
            self.searchBar.resignFirstResponder()
            self.searchArray = self.allCountryLocale
            self.tableView.reloadData()
            self.searchBar.text = ""
            self.searchBar.showsCancelButton = false
            self.searchBar.frame.origin.y = 44
            self.tableView.frame.origin.y = self.searchBar.frame.origin.y+self.searchBar.frame.height
        }
    }
}

extension CTASearchCountryViewController:UITableViewDataSource, UITableViewDelegate{

    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        let keys = Array(self.searchArray.keys).sort(<)
        return keys
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String,
        atIndex index: Int) -> Int {
        let keys = Array(self.searchArray.keys).sort(<)
        for var i:Int = 0; i<keys.count; i++ {
            let key = keys[i]
            if key == title{
                return i
            }
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return self.searchArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var dataArray:Array<CountryZone>?
        let keys = Array(self.searchArray.keys).sort(<)
        for var i:Int = 0; i<keys.count; i++ {
            if i == section{
                dataArray = self.searchArray[keys[i]]
                break
            }
        }
        if dataArray == nil{
            return 0
        }else {
            return  dataArray!.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        var dataKey:String = ""
        let keys = Array(self.searchArray.keys).sort(<)
        for var i:Int = 0; i<keys.count; i++ {
            if i == section{
                dataKey = keys[i]
                break
            }
        }
        if dataKey == "" {
            return nil
        }else {
            return dataKey
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let publishesCell:CTASearchTabelCell = self.tableView.dequeueReusableCellWithIdentifier("ctasearchtabelcell", forIndexPath: indexPath) as! CTASearchTabelCell
        let section = indexPath.section
        let raw     = indexPath.row
        var dataArray:Array<CountryZone>?
        let keys = Array(self.searchArray.keys).sort(<)
        for var i:Int = 0; i<keys.count; i++ {
            if i == section{
                dataArray = self.searchArray[keys[i]]
                break
            }
        }
        if dataArray != nil{
            if raw > -1 && raw < dataArray!.count{
                publishesCell.countryZone = dataArray![raw]
            }
            
        }
        return publishesCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let section = indexPath.section
        let raw     = indexPath.row
        var dataArray:Array<CountryZone>?
        let keys = Array(self.searchArray.keys).sort(<)
        for var i:Int = 0; i<keys.count; i++ {
            if i == section{
                dataArray = self.searchArray[keys[i]]
                break
            }
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if dataArray != nil{
            if raw > -1 && raw < dataArray!.count{
                let model = dataArray![raw]
                if self.selectedDelegate != nil {
                    self.selectedDelegate!.setCountryCode(model)
                }
                self.selectedDelegate = nil
                self.resetView()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }

    }
}

extension CTASearchCountryViewController: UISearchBarDelegate{
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchText == "" {
            self.searchArray = self.allCountryLocale
        }else {
            self.searchArray.removeAll()
            for (key, countries) in self.allCountryLocale {
                var searchCountrys:Array<CountryZone> = []
                for ctrl in countries{
                    if ctrl.displayName.lowercaseString.containsString(searchText.lowercaseString){
                        searchCountrys.append(ctrl)
                    }
                }
                if searchCountrys.count > 0{
                    self.searchArray[key] = searchCountrys
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        self.searchBar.showsCancelButton = true
        self.searchBar.frame.origin.y = 0
        self.tableView.frame.origin.y = self.searchBar.frame.origin.y+self.searchBar.frame.height
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        self.resetView()
    }
}

class CTASearchTabelCell: UITableViewCell{
    
    var countryNameLabel:UILabel!
    var countryCodeLabel:UILabel!
    
    var countryZone:CountryZone?{
        didSet{
            self.reloadView()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadView(){
        if self.countryNameLabel == nil {
            self.countryNameLabel = UILabel.init(frame: CGRect.init(x: 10, y: (self.contentView.frame.height - 25 )/2, width: self.contentView.frame.width, height: 25))
            self.contentView.addSubview(self.countryNameLabel)
            self.countryNameLabel.font = UIFont.systemFontOfSize(18)
            self.countryNameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        }
        self.countryNameLabel.text = self.countryZone!.displayName
        
        if self.countryCodeLabel == nil {
            self.countryCodeLabel = UILabel.init(frame: CGRect.init(x: 10, y: (self.contentView.frame.height - 25 )/2, width: self.contentView.frame.width, height: 25))
            self.contentView.addSubview(self.countryCodeLabel)
            self.countryCodeLabel.font = UIFont.systemFontOfSize(18)
            self.countryCodeLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        }
        self.countryCodeLabel.text = "+"+self.countryZone!.zoneCode
        self.countryCodeLabel.sizeToFit()
        self.countryCodeLabel.frame.origin.x = self.contentView.frame.width - 10 - self.countryCodeLabel.frame.width
    }
}

extension CTASearchCountryViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.searchBar.frame.origin.y == 0 {
            return false
        }
        return true
    }
    
}

