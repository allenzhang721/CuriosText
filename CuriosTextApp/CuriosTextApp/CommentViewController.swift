//
//  CommentViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    var publishID: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.lightGrayColor()
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        closeButton.setImage(UIImage(named: "close-button"), forState: .Normal)
        closeButton.setImage(UIImage(named: "close-selected-button"), forState: .Highlighted)
        closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
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
    
    func closeButtonClick(sender: UIButton){
        self.dismissViewControllerAnimated(true) {
            
        }
    }

}
