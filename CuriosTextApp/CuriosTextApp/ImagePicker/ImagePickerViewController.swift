//
//  ViewController.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {
    
//    weak var pickerDelegate: CTAPhotoPickerProtocol?
    
    var templateImage: UIImage?
    var backgroundColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var backgroundHex: String = "FFFFFF"
    var selectedImageIdentifier: String?
    var didSelectedImageHandler: ((UIImage?, UIColor, String?) -> ())?
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for childVC in childViewControllers {
            
            if let childVC = childVC as? UITabBarController, let vcs = childVC.viewControllers {
                
                for vc in vcs {
                    if let vc = vc as? CTAPhotoPickerDelegate {
                        vc.pickerDelegate = self
                    }
                    
                    if let vc = vc as? CTAPhotoPickerTemplateable {
                        vc.selectedImageIdentifier = selectedImageIdentifier
                        vc.templateImage = templateImage
                        vc.backgroundColor = backgroundColor
                        vc.backgroundColorHex = backgroundHex
                    }
                }
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ImagePickerViewController: CTAPhotoPickerProtocol {
    
    func pickerDidSelectedImage(_ image: UIImage, backgroundColor: UIColor, identifier: String?) {
        didSelectedImageHandler?(image, backgroundColor, identifier)
    }
}

