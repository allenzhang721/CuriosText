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
    var didSelectedImageHandler: ((UIImage?, UIColor) -> ())?
    
    deinit {
        print("\(#file) deinit")
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
                        vc.templateImage = templateImage
                        vc.backgroundColor = backgroundColor
                        vc.backgroundColorHex = backgroundHex
                    }
                }
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ImagePickerViewController: CTAPhotoPickerProtocol {
    
    func pickerDidSelectedImage(image: UIImage, backgroundColor: UIColor) {
        didSelectedImageHandler?(image, backgroundColor)
    }
}

