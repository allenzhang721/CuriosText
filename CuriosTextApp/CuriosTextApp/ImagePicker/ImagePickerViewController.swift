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
    
    var didSelectedImageHandler: ((UIImage?) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for childVC in childViewControllers {
            
            if let childVC = childVC as? UITabBarController, let vcs = childVC.viewControllers {
                
                for vc in vcs {
                    if let vc = vc as? CTAPhotoPickerDelegate {
                        vc.pickerDelegate = self
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
    
    func pickerDidSelectedImage(image: UIImage) {
        didSelectedImageHandler?(image)
    }
}

