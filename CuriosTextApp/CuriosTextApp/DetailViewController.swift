//
//  DetailViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    var selectedPublishID:String = ""
    
    var publishArray:Array<CTAPublishModel> = []
    
    var controllerView:CTAPublishControllerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.controllerView = CTAPublishControllerView(frame: self.view.bounds)
        self.view.addSubview(self.controllerView)
    }
}
