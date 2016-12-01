//
//  CTAImagePickerViewController.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 3/1/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? CTAPhotoPickerDelegate {
            vc.pickerDelegate = self
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ImageViewController: CTAPhotoPickerProtocol {
    
    func pickerDidSelectedImage(_ image: UIImage, backgroundColor: UIColor, identifier: String?) {
        
        imageView.image = image
    }
}
