//
//  CTAPublishesCell.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/8.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher

class CTAPublishesCell: UICollectionViewCell, CTAImageControllerProtocol{
    
    var publishModel:CTAPublishModel!{
        didSet{
            self.reloadCell()
        }
    }
    
    var cellImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.cropImageRound(self.cellImageView)
        self.addImageShadow(self.contentView)
        self.contentView.addSubview(self.cellImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadCell(){
        let imagePath = CTAFilePath.publishFilePath+self.publishModel!.publishIconURL
        let imageURL = NSURL(string: imagePath)!
        self.cellImageView.kf_showIndicatorWhenLoading = true
        let size = CGSize.init(width: self.frame.width, height: self.frame.height)
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.whiteColor().setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.cellImageView.kf_setImageWithURL(imageURL, placeholderImage: image, optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
        }
    }
}