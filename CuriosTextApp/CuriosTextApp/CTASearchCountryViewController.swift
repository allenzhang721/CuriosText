//
//  CTASearchCountryViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/31.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit


protocol CTACountryDelegate: NSObjectProtocol {
    func setCountryCode(_ model:CountryZone)
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
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
        let bouns = UIScreen.main.bounds
        self.searchArray = self.allCountryLocale
        let searchLabel = UILabel(frame: CGRect(x: 0, y: 28, width: bouns.width, height: 28))
        searchLabel.font = UIFont.boldSystemFont(ofSize: 18)
        searchLabel.textColor = CTAStyleKit.normalColor
        searchLabel.text = NSLocalizedString("SearchLabel", comment: "")
        searchLabel.textAlignment = .center
        self.view.addSubview(searchLabel)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), for: UIControlState())
        backButton.setImage(UIImage(named: "back-selected-button"), for: .highlighted)
        backButton.addTarget(self, action: #selector(CTASearchCountryViewController.backButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 64, width: bouns.width, height: 50))
        self.searchBar.delegate = self
        self.view.addSubview(self.searchBar)
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 114, width: bouns.width, height: bouns.height - 103))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CTASearchTabelCell.self, forCellReuseIdentifier: "ctasearchtabelcell")
        self.view.addSubview(self.tableView)
    }
    
    func backButtonClick(_ sender: UIButton){
        self.backHandler()
    }
    
    func backHandler(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func resetView(){
        if self.searchBar.showsCancelButton{
            self.searchBar.resignFirstResponder()
            self.searchArray = self.allCountryLocale
            self.tableView.reloadData()
            self.searchBar.text = ""
            self.searchBar.showsCancelButton = false
            self.searchBar.frame.origin.y = 64
            self.tableView.frame.origin.y = self.searchBar.frame.origin.y+self.searchBar.frame.height
        }
    }
}

extension CTASearchCountryViewController:UITableViewDataSource, UITableViewDelegate{

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let keys = Array(self.searchArray.keys).sorted(by: <)
        return keys
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String,
        at index: Int) -> Int {
        let keys = Array(self.searchArray.keys).sorted(by: <)
        for i in 0..<keys.count {
            let key = keys[i]
            if key == title{
                return i
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.searchArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var dataArray:Array<CountryZone>?
        let keys = Array(self.searchArray.keys).sorted(by: <)
        for i in 0..<keys.count {
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        var dataKey:String = ""
        let keys = Array(self.searchArray.keys).sorted(by: <)
        for i in 0..<keys.count {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let publishesCell:CTASearchTabelCell = self.tableView.dequeueReusableCell(withIdentifier: "ctasearchtabelcell", for: indexPath) as! CTASearchTabelCell
        let section = indexPath.section
        let raw     = indexPath.row
        var dataArray:Array<CountryZone>?
        let keys = Array(self.searchArray.keys).sorted(by: <)
        for i in 0..<keys.count {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let section = indexPath.section
        let raw     = indexPath.row
        var dataArray:Array<CountryZone>?
        let keys = Array(self.searchArray.keys).sorted(by: <)
        for i in 0..<keys.count {
            if i == section{
                dataArray = self.searchArray[keys[i]]
                break
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
        if dataArray != nil{
            if raw > -1 && raw < dataArray!.count{
                let model = dataArray![raw]
                if self.selectedDelegate != nil {
                    self.selectedDelegate!.setCountryCode(model)
                }
                self.selectedDelegate = nil
                self.resetView()
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
}

extension CTASearchCountryViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText == "" {
            self.searchArray = self.allCountryLocale
        }else {
            self.searchArray.removeAll()
            for (key, countries) in self.allCountryLocale {
                var searchCountrys:Array<CountryZone> = []
                for ctrl in countries{
                    if ctrl.displayName.lowercased().contains(searchText.lowercased()){
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        self.searchBar.showsCancelButton = true
        self.searchBar.frame.origin.y = 20
        self.tableView.frame.origin.y = self.searchBar.frame.origin.y+self.searchBar.frame.height
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
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
            self.countryNameLabel = UILabel(frame: CGRect(x: 10, y: (self.contentView.frame.height - 25 )/2, width: self.contentView.frame.width, height: 25))
            self.contentView.addSubview(self.countryNameLabel)
            self.countryNameLabel.font = UIFont.systemFont(ofSize: 16)
            self.countryNameLabel.textColor = CTAStyleKit.normalColor
        }
        self.countryNameLabel.text = self.countryZone!.displayName
        
        if self.countryCodeLabel == nil {
            self.countryCodeLabel = UILabel(frame: CGRect(x: 10, y: (self.contentView.frame.height - 25 )/2, width: self.contentView.frame.width, height: 25))
            self.contentView.addSubview(self.countryCodeLabel)
            self.countryCodeLabel.font = UIFont.systemFont(ofSize: 16)
            self.countryCodeLabel.textColor = CTAStyleKit.normalColor
        }
        self.countryCodeLabel.text = "+"+self.countryZone!.zoneCode
        self.countryCodeLabel.sizeToFit()
        self.countryCodeLabel.frame.origin.x = self.contentView.frame.width - 10 - self.countryCodeLabel.frame.width
    }
}

extension CTASearchCountryViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.searchBar.frame.origin.y == 20 {
            return false
        }
        return true
    }
    
}

