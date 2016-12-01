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
    
    var imageURL: URL?
    var completedHandler: ((_ imageData: Data?, _ text: String) -> ())?
    var dismissHandler:(() -> ())?
    
    var sending = false
    
    let normalAttributes: [String: AnyObject] = {
       
        var a = [String: AnyObject]()
        a[NSFontAttributeName] = UIFont.systemFont(ofSize: 14)
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 3
        
        a[NSParagraphStyleAttributeName] = para
        a[NSForegroundColorAttributeName] = UIColor.black
        
        return a
    }()
    
    let selectedAttributes: [String: AnyObject] = {
        
        var a = [String: AnyObject]()
        a[NSFontAttributeName] = UIFont.systemFont(ofSize: 14)
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 3
        
        a[NSParagraphStyleAttributeName] = para
        a[NSForegroundColorAttributeName] = UIColor.red
        
        return a
    }()

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lengthLabel: UILabel!
    
    class func viewControllerWith(_ imageURL: URL?, completedHandler: ((_ imageData: Data?, _ text: String) -> ())?, dismissHandler:(() -> ())?) -> ShareViewController {
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    func setup() {
//        let url = NSBundle.mainBundle().URLForResource("animation", withExtension: "gif")
//        imageURL = url
        
        if let imageURL = imageURL {
            let image = FLAnimatedImage(animatedGIFData: try? Data(contentsOf: imageURL))
            imageView.animatedImage = image
        }
        
        textView.delegate = self
        textView.text = "#Curios奇思#"
        let alength = textView.attributedText.length
        let attr = [NSForegroundColorAttributeName: alength > 140 ? UIColor.red : UIColor.lightGray]
        lengthLabel.attributedText = NSAttributedString(string: "0", attributes: attr)
    }
}

// MARK: - Actions
extension ShareViewController {
    
    @IBAction func doneAction(_ sender: AnyObject) {
        
        guard sending == false else { return }
        sending = true
        
        textView.resignFirstResponder()
        
        let length = textView.attributedText.length
        let subString = textView.attributedText.attributedSubstring(from: NSMakeRange(0, length > 140 ? 140 : length)).string
        let data: Data?
        if let url = imageURL {
            data = try? Data(contentsOf: url)
        } else {
            data = nil
        }
        
        completedHandler?(data, subString)
    }
    
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        if let d = dismissHandler {
            d()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ShareViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {

        if textView.markedTextRange == nil {
        let alength = textView.attributedText.length
        let attr = [NSForegroundColorAttributeName: alength > 140 ? UIColor.red : UIColor.lightGray]
        lengthLabel.attributedText = NSAttributedString(string: "\(alength)", attributes: attr)
            
            shareButton.isEnabled = true
        }
        
        guard let attributeText = textView.attributedText, attributeText.length > 140 && textView.markedTextRange == nil else { return }
        
        shareButton.isEnabled = false
        
//        let attributes = [NSFontAttributeName]
        
        let normalAttributes = self.normalAttributes
        let exceedAttributes = self.selectedAttributes
        
        let length = textView.attributedText.length
        let multAttriText = NSMutableAttributedString(attributedString: attributeText)
        multAttriText.setAttributes(normalAttributes, range: NSMakeRange(0, 140))
        multAttriText.setAttributes(exceedAttributes, range: NSMakeRange(140, length - 140))
        textView.attributedText = multAttriText
    }
}
