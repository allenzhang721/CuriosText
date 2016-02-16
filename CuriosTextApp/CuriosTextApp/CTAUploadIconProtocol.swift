//
//  CTAUploadIconProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/16.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

protocol CTAUploadIconProtocol: CTAAlertProtocol{
    func uploadBegin()
    func uploadUserIcon(user:CTAUserModel, icon:UIImage)
    func uploadComplete(result:Bool, iconPath:String, icon:UIImage?)
}

extension CTAUploadIconProtocol{
    func uploadUserIcon(user:CTAUserModel, icon:UIImage){
        let userID = user.userID
        let uuid = NSUUID().UUIDString
        let uuidStr = NSString(string: uuid)
        let imageName = uuidStr.substringWithRange(NSMakeRange(0, 6))
        let userIconKey = userID+"/"+imageName+".jpg"
        let uptoken = CTAUpTokenModel.init(upTokenKey: userIconKey)
        self.uploadBegin()
        CTAUpTokenDomain.getInstance().userUpToken([uptoken], compelecationBlock: { (listInfo) -> Void in
            if listInfo.result {
                let newToken = listInfo.modelArray![0] as! CTAUpTokenModel
                let imageData = getIconData(icon)
                let uploadModel = CTAUploadModel.init(key: userIconKey, token: newToken.upToken, fileData: imageData)
                CTAUploadAction.getInstance().uploadFile(userID, uploadModel: uploadModel, progress: { (_) -> Void in
                    }, complete: { (info) -> Void in
                        if info.result{
                            let newImage = compressIconImage(icon)
                            self.uploadComplete(true, iconPath: userIconKey, icon: newImage)
                        }else {
                            self.uploadComplete(false, iconPath: "", icon: nil)
                            self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                            })
                        }
                })
            }else {
                self.uploadComplete(false, iconPath: "", icon: nil)
            }
        })

    }
}