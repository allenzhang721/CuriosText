//
//  CTATextModifyViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTATextModifyViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    private var text = ""
    private var attri = [String: NSObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func beganWith(text: String, attributes: [String: NSObject]?) {
        self.text = text
        if let attributes = attributes {
            self.attri = attributes
        }
        
        let attributeText = NSAttributedString(string: self.text, attributes: self.attri)
        textView.attributedText = attributeText
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        cancel()
    }
    
    @IBAction func doneAction(sender: AnyObject) {
    }
    
    private func cancel() {
        
        dismissViewControllerAnimated(true) { 
            
            // dismiss and cancel completion
        }
    }
    
    private func done() {
        
        dismissViewControllerAnimated(true) { 
            
            // dismiss and done completion
        }
    }
}
