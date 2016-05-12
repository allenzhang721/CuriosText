//
//  ShareViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/10/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ShareViewController: UIViewController {
    
    var imageURL: NSURL?
    var completedHandler: ((imageData: NSData?, text: String) -> ())?
    var dismissHandler:(() -> ())?
    
    var sending = false
    
    let normalAttributes: [String: AnyObject] = {
       
        var a = [String: AnyObject]()
        a[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 3
        
        a[NSParagraphStyleAttributeName] = para
        a[NSForegroundColorAttributeName] = UIColor.blackColor()
        
        return a
    }()
    
    let selectedAttributes: [String: AnyObject] = {
        
        var a = [String: AnyObject]()
        a[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 3
        
        a[NSParagraphStyleAttributeName] = para
        a[NSForegroundColorAttributeName] = UIColor.redColor()
        
        return a
    }()

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lengthLabel: UILabel!
    
    class func viewControllerWith(imageURL: NSURL?, completedHandler: ((imageData: NSData?, text: String) -> ())?, dismissHandler:(() -> ())?) -> ShareViewController {
        
        let v = UIStoryboard(name: "Share", bundle: nil).instantiateInitialViewController() as! ShareViewController
        v.imageURL = imageURL
        v.completedHandler = completedHandler
        v.dismissHandler = dismissHandler
        return v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setup() {
//        let url = NSBundle.mainBundle().URLForResource("animation", withExtension: "gif")
//        imageURL = url
        
        if let imageURL = imageURL {
            let image = FLAnimatedImage(animatedGIFData: NSData(contentsOfURL: imageURL))
            imageView.animatedImage = image
        }
        
        textView.delegate = self
        textView.text = ""
        let alength = textView.attributedText.length
        let attr = [NSForegroundColorAttributeName: alength > 140 ? UIColor.redColor() : UIColor.lightGrayColor()]
        lengthLabel.attributedText = NSAttributedString(string: "0", attributes: attr)
    }
}

// MARK: - Actions
extension ShareViewController {
    
    @IBAction func doneAction(sender: AnyObject) {
        
        guard sending == false else { return }
        sending = true
        
        textView.resignFirstResponder()
        
        let length = textView.attributedText.length
        let subString = textView.attributedText.attributedSubstringFromRange(NSMakeRange(0, length > 140 ? 140 : length)).string
        let data: NSData?
        if let url = imageURL {
            data = NSData(contentsOfURL: url)
        } else {
            data = nil
        }
        
        completedHandler?(imageData: data, text: subString)
    }
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        if let d = dismissHandler {
            d()
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension ShareViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {

        if textView.markedTextRange == nil {
        let alength = textView.attributedText.length
        let attr = [NSForegroundColorAttributeName: alength > 140 ? UIColor.redColor() : UIColor.lightGrayColor()]
        lengthLabel.attributedText = NSAttributedString(string: "\(alength)", attributes: attr)
            
            shareButton.enabled = true
        }
        
        guard let attributeText = textView.attributedText where attributeText.length > 140 && textView.markedTextRange == nil else { return }
        
        shareButton.enabled = false
        
//        let attributes = [NSFontAttributeName]
        
        let normalAttributes = self.normalAttributes
        let exceedAttributes = self.selectedAttributes
        
        let length = textView.attributedText.length
        let multAttriText = NSMutableAttributedString(attributedString: attributeText)
        multAttriText.setAttributes(normalAttributes, range: NSMakeRange(0, 140))
        multAttriText.setAttributes(exceedAttributes, range: NSMakeRange(140, length - 140))
        print(textView.selectedRange)
        textView.attributedText = multAttriText
    }
}