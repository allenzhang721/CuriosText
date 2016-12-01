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
    case cancel, done, delete, attension
    
    // Notification
    case notificationTitle, stared, clear, deleteComment, needClearAll
    
    // Image Picker
    case camera, photo, allowPhotoTitle, allowPhotoMessage
    
    // Comment
    case publishComment, comment, commentSuccess, commentFail
    
    // Editor
    case publish , editTextPlaceHolder, editorDismissMessage
    
    // Publish
    case publishFailure
    
    // Edior Tab
    case size, rotation, font, spacing, alignment, color, animation, animationType, animationDuration, animationDelay, templates, filters, shadow, outline, openShadow, closeShadow, openOutline, closeOutline, alpha
    
    //Animations
    case aniType(CTAAnimationType)
    
    //Alert 
    case ok, yes, no, resend, takePhoto, choosePhoto, back, wait, setting, photoTitle
    
    //Report
    case porn, scam, sensitive
    
    //Share
    case deleteFile, wechat, moments, weibo, copyLink, saveLocal, report, uploadFile, addToHot
    
    var description: String {
        
        switch self {
            // Common
        case .cancel:
            return NSLocalizedString("Cancel", comment: "")
        case .done:
            return NSLocalizedString("Done", comment: "")
        case .delete:
            return NSLocalizedString("Delete", comment: "")
        case .attension:
            return NSLocalizedString("Attension", comment: "")
            
        // Notification
        case .notificationTitle:
            return NSLocalizedString("NotificationTitle", comment: "")
        case .stared:
            return NSLocalizedString("StartedFollowingYou", comment: "")
        case .deleteComment:
            return NSLocalizedString("DeleteComment", comment: "")
        case .clear:
            return NSLocalizedString("Clear", comment: "")
        case .needClearAll:
            return NSLocalizedString("ClearAll", comment: "")
            
            // Image Picker
        case .camera:
            return NSLocalizedString("Camera", comment: "")
        case .photo:
            return NSLocalizedString("Photo", comment: "")
        case .allowPhotoTitle:
            return NSLocalizedString("AllPhotoLibraryTitle", comment: "")
        case .allowPhotoMessage:
            return NSLocalizedString("AllPhotoLibraryMessage", comment: "")
            
            // Comment
        case .publishComment:
            return NSLocalizedString("PublishComment", comment: "")
        case .comment:
            return NSLocalizedString("Comment", comment: "")
        case .commentSuccess:
            return NSLocalizedString("CommentSuccess", comment: "")
        case .commentFail:
            return NSLocalizedString("CommentFail", comment: "")
            
            // Editor
        case .publish:
            return NSLocalizedString("Publish", comment: "")
        case .editTextPlaceHolder:
            return NSLocalizedString("EditTextPlaceHolder", comment: "")
        case .editorDismissMessage:
            return NSLocalizedString("EditorDismissMessage", comment: "")
        case .templates:
            return NSLocalizedString("Templates", comment: "")
        case .filters:
            return NSLocalizedString("Filters", comment: "")
        case .shadow:
            return NSLocalizedString("Shadow", comment: "")
        case .outline:
            return NSLocalizedString("Outline", comment: "")
        case .openShadow:
            return NSLocalizedString("OpenShadow", comment: "")
        case .openOutline:
            return NSLocalizedString("OpenOutline", comment: "")
        case .closeShadow:
            return NSLocalizedString("CloseShadow", comment: "")
        case .closeOutline:
            return NSLocalizedString("CloseOutline", comment: "")
        case .alpha:
            return NSLocalizedString("Alpha", comment: "")
            
            // Publish
        case .publishFailure:
            return NSLocalizedString("PublishFailure", comment: "")
            
            // Edior Tab
        case .size:
            return NSLocalizedString("Size", comment: "")
        case .rotation:
            return NSLocalizedString("Rotation", comment: "")
        case .font:
            return NSLocalizedString("Font", comment: "")
        case .spacing:
            return NSLocalizedString("Spacing", comment: "")
        case .alignment:
            return NSLocalizedString("Alignment", comment: "")
        case .color:
            return NSLocalizedString("Color", comment: "")
        case .animation:
            return NSLocalizedString("Animation", comment: "")
        case .animationType:
            return NSLocalizedString("AnimationType", comment: "")
        case .animationDuration:
            return NSLocalizedString("AnimationDuration", comment: "")
        case .animationDelay:
            return NSLocalizedString("AnimationDelay", comment: "")
            
            // Animation
        case .aniType(let type):
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
        case .ok:
            return NSLocalizedString("AlertOkLabel", comment: "")
        case .yes:
            return NSLocalizedString("AlertYesLabel", comment: "")
        case .no:
            return NSLocalizedString("AlertNoLabel", comment: "")
        case .resend:
            return NSLocalizedString("AlertResendLabel", comment: "")
        case .takePhoto:
            return NSLocalizedString("AlertTakePhotoLabel", comment: "")
        case .choosePhoto:
            return NSLocalizedString("AlertChoosePhoteLabel", comment: "")
        case .back:
            return NSLocalizedString("AlertBackLabel", comment: "")
        case .wait:
            return NSLocalizedString("AlertWaitLabel", comment: "")
        case .setting:
            return NSLocalizedString("AlertSettingLabel", comment: "")
        case .photoTitle:
            return NSLocalizedString("AlertChangePhotoTitle", comment: "")
            //Report
        case .porn:
            return NSLocalizedString("ReportPornLabel", comment: "")
        case .scam:
            return NSLocalizedString("ReportScamLabel", comment: "")
        case .sensitive:
            return NSLocalizedString("ReportSenLabel", comment: "")
            
            //Share
        case .deleteFile:
            return NSLocalizedString("DeleteFileLabel", comment: "")
        case .wechat:
            return NSLocalizedString("WechatShareLabel", comment: "")
        case .moments:
            return NSLocalizedString("MomentsShareLabel", comment: "")
        case .weibo:
            return NSLocalizedString("WeiboShareLabel", comment: "")
        case .saveLocal:
            return NSLocalizedString("SaveLocalLabel", comment: "")
        case .report:
            return NSLocalizedString("ReportLabel", comment: "")
        case .copyLink:
            return NSLocalizedString("CopyLinkLabel", comment: "")
        case .uploadFile:
            return NSLocalizedString("UploadFileLabel", comment: "")
        case .addToHot:
            return NSLocalizedString("AddToHotLabel", comment: "")
        }
    }
}
