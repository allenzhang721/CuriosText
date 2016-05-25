//
//  LocalizationManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/9/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

enum LocalStrings: CustomStringConvertible {

    // Common
    case Cancel, Done, Delete, Attension
    
    // Image Picker
    case Camera, Photo, AllowPhotoTitle, AllowPhotoMessage
    
    // Editor
    case Publish , EditTextPlaceHolder, EditorDismissMessage
    
    // Publish
    case PublishFailure
    
    // Edior Tab
    case Size, Rotation, Font, Spacing, Alignment, Color, Animation, AnimationType, AnimationDuration, AnimationDelay
    
    //Animations
    case AniType(CTAAnimationType)
    
    //Alert 
    case OK, Yes, No, Resend, TakePhoto, ChoosePhoto, Back, Wait, Setting
    
    //Report
    case Porn, Scam, Sensitive
    
    //Share
    case DeleteFile, Wechat, Moments, Weibo, CopyLink, SaveLocal, Report, UploadFile, AddToHot
    
    var description: String {
        
        switch self {
            // Common
        case .Cancel:
            return NSLocalizedString("Cancel", comment: "")
        case .Done:
            return NSLocalizedString("Done", comment: "")
        case .Delete:
            return NSLocalizedString("Delete", comment: "")
        case .Attension:
            return NSLocalizedString("Attension", comment: "")
            
            // Image Picker
        case .Camera:
            return NSLocalizedString("Camera", comment: "")
        case .Photo:
            return NSLocalizedString("Photo", comment: "")
        case .AllowPhotoTitle:
            return NSLocalizedString("AllPhotoLibraryTitle", comment: "")
        case .AllowPhotoMessage:
            return NSLocalizedString("AllPhotoLibraryMessage", comment: "")
            
            // Editor
        case .Publish:
            return NSLocalizedString("Publish", comment: "")
        case .EditTextPlaceHolder:
            return NSLocalizedString("EditTextPlaceHolder", comment: "")
        case .EditorDismissMessage:
            return NSLocalizedString("EditorDismissMessage", comment: "")
            
            // Publish
        case .PublishFailure:
            return NSLocalizedString("PublishFailure", comment: "")
            
            // Edior Tab
        case .Size:
            return NSLocalizedString("Size", comment: "")
        case .Rotation:
            return NSLocalizedString("Rotation", comment: "")
        case .Font:
            return NSLocalizedString("Font", comment: "")
        case .Spacing:
            return NSLocalizedString("Spacing", comment: "")
        case .Alignment:
            return NSLocalizedString("Alignment", comment: "")
        case .Color:
            return NSLocalizedString("Color", comment: "")
        case .Animation:
            return NSLocalizedString("Animation", comment: "")
        case .AnimationType:
            return NSLocalizedString("AnimationType", comment: "")
        case .AnimationDuration:
            return NSLocalizedString("AnimationDuration", comment: "")
        case .AnimationDelay:
            return NSLocalizedString("AnimationDelay", comment: "")
            
            // Animation
        case .AniType(let type):
            return NSLocalizedString(type.rawValue, comment: "")
//        case .None:
//            return NSLocalizedString("None", comment: "")
//        case .MoveIn:
//            return NSLocalizedString("MoveIn", comment: "")
//        case .MoveOut:
//            return NSLocalizedString("MoveOut", comment: "")
//        case .ScaleIn:
//            return NSLocalizedString("ScaleIn", comment: "")
//        case .ScaleOut:
//            return NSLocalizedString("ScaleOut", comment: "")
            // Alert
        case .OK:
            return NSLocalizedString("AlertOkLabel", comment: "")
        case .Yes:
            return NSLocalizedString("AlertYesLabel", comment: "")
        case .No:
            return NSLocalizedString("AlertNoLabel", comment: "")
        case .Resend:
            return NSLocalizedString("AlertResendLabel", comment: "")
        case .TakePhoto:
            return NSLocalizedString("AlertTakePhotoLabel", comment: "")
        case .ChoosePhoto:
            return NSLocalizedString("AlertChoosePhoteLabel", comment: "")
        case .Back:
            return NSLocalizedString("AlertBackLabel", comment: "")
        case .Wait:
            return NSLocalizedString("AlertWaitLabel", comment: "")
        case .Setting:
            return NSLocalizedString("AlertSettingLabel", comment: "")
            //Report
        case .Porn:
            return NSLocalizedString("ReportPornLabel", comment: "")
        case .Scam:
            return NSLocalizedString("ReportScamLabel", comment: "")
        case .Sensitive:
            return NSLocalizedString("ReportSenLabel", comment: "")
            
            //Share
        case .DeleteFile:
            return NSLocalizedString("DeleteFileLabel", comment: "")
        case .Wechat:
            return NSLocalizedString("WechatShareLabel", comment: "")
        case .Moments:
            return NSLocalizedString("MomentsShareLabel", comment: "")
        case .Weibo:
            return NSLocalizedString("WeiboShareLabel", comment: "")
        case .SaveLocal:
            return NSLocalizedString("SaveLocalLabel", comment: "")
        case .Report:
            return NSLocalizedString("ReportLabel", comment: "")
        case .CopyLink:
            return NSLocalizedString("CopyLinkLabel", comment: "")
        case .UploadFile:
            return NSLocalizedString("UploadFileLabel", comment: "")
        case .AddToHot:
            return NSLocalizedString("AddToHotLabel", comment: "")
        }
    }
}
