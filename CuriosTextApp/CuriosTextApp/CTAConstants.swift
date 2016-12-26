//
//  CTARequestConstants.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

func key(_ key: CTAParameterKey) -> String {
  return key.description
}

struct CTARequestResultKey {
    
    static let result = "resultType"
    static let resultIndex = "resultIndex"
    static let success = "success"
    static let fail = "fail"
}

struct CTAFilePath {

    static var userFilePath = "https://dn-tu-curiosapp.qbox.me/"
    static var publishFilePath = "https://dn-tp-curiosapp.qbox.me/"
    static var resourceFilePath = "https://o6kzay0ng.qnssl.com/"
}

enum CTARequestHost: CustomStringConvertible {
  case test, debug, production
  
  var description: String {
    switch self {
    case .test:
        CTAFilePath.userFilePath = "http://7wy3u8.com2.z0.glb.qiniucdn.com/"
        CTAFilePath.publishFilePath = "http://7wy3u8.com2.z0.glb.qiniucdn.com/"
        CTAFilePath.resourceFilePath = "https://o6kzay0ng.qnssl.com/"
        return "http://182.92.150.178/CuriosTextServices" 
    case .debug:
        CTAFilePath.userFilePath = "http://7wy3u8.com2.z0.glb.qiniucdn.com/"
        CTAFilePath.publishFilePath = "http://7wy3u8.com2.z0.glb.qiniucdn.com/"
        CTAFilePath.resourceFilePath = "https://o6kzay0ng.qnssl.com/"
        return "http://192.168.1.102:8080/CuriosTextServices"
    case .production:
        CTAFilePath.userFilePath = "https://dn-tu-curiosapp.qbox.me/"
        CTAFilePath.publishFilePath = "https://dn-tp-curiosapp.qbox.me/"
        CTAFilePath.resourceFilePath = "https://o6kzay0ng.qnssl.com/"
        return "http://cta.curiosapp.com"
    }
  }
}

enum CTARequestUrl: CustomStringConvertible {
  case login
  case phoneRegister, weixinRegister, weiboRegister
  case updateUserInfo, updateUserNickname, updateUserDesc, updateUserIconURL, updateUserAddress, updateUserSex
  case checkUserExist, bindingPhone, bindingWeixinID, unbindingWeixinID, bingingWeiboID, unbindingWeiboID
  case checkPassword, updatePassword, resetPassword, userDetail
    
  case createPublish, deletePublish, publishDetail
  case userPublishList, userLikePublishList, userRebuildPublishList, userFollowPublishList, newPubulishList, hotPublishList, setHotPublish, publishLikeUserList
  case likePublish, unLikePublish, rebuildPublish, sharePublish, reportPublish
  case followUser, unFollowUser, blockUser, unBlockUser, userFollowList, userBeFollowList
  case userUpToken, publishUpToken, uploadFilePath, resourceUpToken
  case addPublishComment, deletePublishComment, publishCommentList
  case unReadNoticeCount, noticeList, deleteNotice, clearNotices, setNoticesReaded
  
  var description: String {
    switch self {
    case .login:
        return "/user/login"
    case .phoneRegister:
      return "/user/register"
    case .weixinRegister:
        return "/user/weixinRegister"
    case .weiboRegister:
        return "/user/weiboRegister"
    case .updateUserInfo:
        return "/user/updateUserInfo"
    case .updateUserNickname:
        return "/user/updateUserNickname"
    case .updateUserDesc:
        return "/user/updateUserDesc"
    case .updateUserIconURL:
        return "/user/updateUserIconURL"
    case .updateUserAddress:
        return "/user/updateUserAddress"
    case .updateUserSex:
        return "/user/updateUserSex"
    case .checkUserExist:
        return "/user/checkUserExist"
    case .bindingPhone:
        return "/user/bindingPhone"
    case .bindingWeixinID:
        return "/user/bindingWeixinID"
    case .unbindingWeixinID:
        return "/user/unbindingWeixinID"
    case .bingingWeiboID:
        return "/user/bindingWeiboID"
    case .unbindingWeiboID:
        return "/user/unbindingWeiboID"
    case .checkPassword:
        return "/user/checkPassword"
    case .updatePassword:
        return "/user/updatePassword"
    case .resetPassword:
        return "/user/resetPassword"
    case .userDetail:
        return "/user/userDetail"
    case .createPublish:
        return "/publish/createPublishFile"
    case .deletePublish:
        return "/publish/deletePublishFile"
    case .publishDetail:
        return "/publish/publishFileDetail"
    case .userPublishList:
        return "/publish/userPublishList"
    case .userLikePublishList:
        return "/publish/userLikePublishList"
    case .userRebuildPublishList:
        return "/publish/userRebuildPublishList"
    case .userFollowPublishList:
        return "/publish/userFollowPublishList"
    case .newPubulishList:
        return "/publish/newPublishList"
    case .hotPublishList:
        return "/publish/hotPublishList"
    case .setHotPublish:
        return "/publish/setHotPublish"
    case .publishLikeUserList:
        return "/publish/publishLikeUserList"
    case .likePublish:
        return "/publish/likePublish"
    case .unLikePublish:
        return "/publish/unLikePublish"
    case .rebuildPublish:
        return "/publish/rebuildPublish"
    case .sharePublish:
        return "/publish/sharePublish"
    case .reportPublish:
        return "/publish/reportPublish"
    case .followUser:
        return "/relation/followUser"
    case .unFollowUser:
        return "/relation/unFollowUser"
    case .blockUser:
        return "/relation/blockUser"
    case .unBlockUser:
        return "/relation/unBlockUser"
    case .userFollowList:
        return "/relation/userFollowList"
    case .userBeFollowList:
        return "/relation/userBeFollowList"
    case .userUpToken:
        return "/upload/userUpToken"
    case .publishUpToken:
        return "/upload/publishUpToken"
    case .uploadFilePath:
        return "/upload/uploadFilePath"
    case .resourceUpToken:
        return "/upload/resourceUpToken"
    case .addPublishComment:
        return "/comment/addPublishComment"
    case .deletePublishComment:
        return "/comment/deletePublishComment"
    case .publishCommentList:
        return "/comment/publishCommentList"
    case .unReadNoticeCount:
        return "/notice/unReadNoticeCount"
    case .noticeList:
        return "/notice/noticeList"
    case .deleteNotice:
        return "/notice/deleteNotice"
    case .clearNotices:
        return "/notice/clearUserNotices"
    case .setNoticesReaded:
        return "/notice/setNoticesReaded"
    }
  }
}

enum CTAParameterKey: CustomStringConvertible {
  case data
  case userID, userType, nickName, userDesc, userIconURL, sex, email, phone, areaCode, password, weixinID, weiboID, country, province, city, newPassword
  case beUserID, start, size, sharePlatform, list, reportType, reportMessage
  case publishID, title, publishDesc, publishIconURL, previewIconURL, publishURL, publishDate
  case relationType, relationUserID, followCount, beFollowCount, publishCount
  case publishFilePath, userFilePath, resourceFilePath
  case upToken, upTokenKey
  case shareCount, rebuildCount, likeCount, likeStatus, commentCount
  case openid, headimgurl, wechatName
  case weiBoUserID, weiBoID, avatarhd, gender, weiboName, weiboDesc
  case commentMessage, commentID, beCommentedNickName, beCommentedUserID, beCommentUserDesc, beCommentUserIconURL, beCommentSex, commentDate
  case noticeID, noticeMessage, noticeDate, noticeReaded, noticeType, noticeTypeID, noticeCount
  case alias
    
  var description: String {
    switch self {
    case .data:
      return "data"
    case .userID:
        return "userID"
    case .userType:
        return "userType"
    case .nickName:
        return "nickName"
    case .userDesc:
        return "userDesc"
    case .userIconURL:
        return "userIconURL"
    case .sex:
        return "sex"
    case .email:
        return "email"
    case .phone:
      return "phone"
    case .areaCode:
      return "areaCode"
    case .password:
      return "password"
    case .weixinID:
        return "weixinID"
    case .weiboID:
        return "weiboID"
    case .country:
        return "country"
    case .province:
        return "province"
    case .city:
        return "city"
    case .newPassword:
        return "newPassword"
    case .beUserID:
        return "beUserID"
    case .start:
        return "start"
    case .size:
        return "size"
    case .sharePlatform:
        return "sharePlatform"
    case .reportType:
        return "reportType"
    case .reportMessage:
        return "reportMessage"
    case .list:
        return "list"
    case .publishID:
        return "publishID"
    case .title:
        return "title"
    case .publishDesc:
        return "publishDesc"
    case .publishIconURL:
        return "publishIconURL"
    case .previewIconURL:
        return "previewIconURL"
    case .publishURL:
        return "publishURL"
    case .publishDate:
        return "publishDate"
    case .relationType:
        return "relationType"
    case .relationUserID:
        return "relationUserID"
    case .followCount:
        return "followCount"
    case .beFollowCount:
        return "beFollowCount"
    case .publishCount:
        return "publishCount"
    case .publishFilePath:
        return "publishFilePath"
    case .userFilePath:
        return "userFilePath"
    case .resourceFilePath:
        return "resourceFilePath"
    case .upToken:
        return "upToken"
    case .upTokenKey:
        return "upTokenKey"
    case .shareCount:
        return "shareCount"
    case .rebuildCount:
        return "rebuildCount"
    case .likeCount:
        return "likeCount"
    case .likeStatus:
        return "likeStatus"
    case .commentCount:
        return "commentCount"
    case .openid:
        return "openid"
    case .headimgurl:
        return "headimgurl"
    case .wechatName:
        return "nickname"
    case .weiBoUserID:
        return "userID"
    case .weiBoID:
        return "id"
    case .avatarhd:
        return "avatar_hd"
    case .gender:
        return "gender"
    case .weiboName:
        return "screen_name"
    case .weiboDesc:
        return "description"
    case .commentMessage:
        return "commentMessage"
    case .commentID:
        return "commentID"
    case .beCommentedUserID:
        return "beCommentedUserID"
    case .beCommentedNickName:
        return "beCommentedNickName"
    case .beCommentUserDesc:
        return "beCommentedUserDesc"
    case .beCommentUserIconURL:
        return "beCommentedUserIconURL"
    case .beCommentSex:
        return "beCommentedSex"
    case .commentDate:
        return "commentDate"
    case .noticeID:
        return "noticeID"
    case .noticeMessage:
        return "noticeMessage"
    case .noticeDate:
        return "noticeDate"
    case .noticeReaded:
        return "noticeReaded"
    case .noticeType:
        return "noticeType"
    case .noticeTypeID:
        return "noticeTypeID"
    case .noticeCount:
        return "count"
    case .alias:
        return "alias"
    }
  }
}
