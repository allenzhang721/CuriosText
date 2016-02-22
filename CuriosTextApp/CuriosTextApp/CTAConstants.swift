//
//  CTARequestConstants.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

func key(key: CTAParameterKey) -> String {
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
    static var publishFilePath = "https://o2w6twocj.qnssl.com/"
}

enum CTARequestHost: CustomStringConvertible {
  case Test, Debug, Production
  
  var description: String {
    switch self {
    case .Test:
      return "http://182.92.150.178/CuriosTextServices"
    case .Debug:
      return "http://192.168.1.103:8080/CuriosTextServices"
    case .Production:
      return "http://cta.curiosapp.com"
    }
  }
}

enum CTARequestUrl: CustomStringConvertible {
  case GetUserID,Login
  case PhoneRegister, WeixinRegister, WeiboRegister
  case UpdateUserInfo, UpdateUserNickname, UpdateUserDesc, UpdateUserIconURL, UpdateUserAddress, UpdateUserSex
  case CheckUserExist, BindingPhone, BindingWeixinID, UnbindingWeixinID, BingingWeiboID, UnbindingWeiboID
  case CheckPassword, UpdatePassword, ResetPassword, UserDetail
    
  case GetPublishID, CreatePublish, DeletePublish
  case UserPublishList, UserLikePublishList, UserRebuildPublishList, UserFollowPublishList, NewPubulishList, HotPublishList
  case LikePublish, UnLikePublish, RebuildPublish, SharePublish
  case FollowUser, UnFollowUser, BlockUser, UnBlockUser, UserFollowList, UserBeFollowList
  case UserUpToken, PublishUpToken, UploadFilePath
  
  var description: String {
    switch self {
    case .GetUserID:
        return "/user/getUserID"
    case .Login:
        return "/user/login"
    case .PhoneRegister:
      return "/user/register"
    case .WeixinRegister:
        return "/user/weixinRegister"
    case .WeiboRegister:
        return "/user/weiboRegister"
    case .UpdateUserInfo:
        return "/user/updateUserInfo"
    case .UpdateUserNickname:
        return "/user/updateUserNickname"
    case .UpdateUserDesc:
        return "/user/updateUserDesc"
    case .UpdateUserIconURL:
        return "/user/updateUserIconURL"
    case .UpdateUserAddress:
        return "/user/updateUserAddress"
    case .UpdateUserSex:
        return "/user/updateUserSex"
    case .CheckUserExist:
        return "/user/checkUserExist"
    case .BindingPhone:
        return "/user/bindingPhone"
    case .BindingWeixinID:
        return "/user/bindingWeixinID"
    case .UnbindingWeixinID:
        return "/user/unbindingWeixinID"
    case .BingingWeiboID:
        return "/user/bindingWeiboID"
    case .UnbindingWeiboID:
        return "/user/unbindingWeiboID"
    case .CheckPassword:
        return "/user/checkPassword"
    case .UpdatePassword:
        return "/user/updatePassword"
    case .ResetPassword:
        return "/user/resetPassword"
    case .UserDetail:
        return "/user/userDetail"
    case .GetPublishID:
        return "/publish/getPublishID"
    case .CreatePublish:
        return "/publish/createPublishFile"
    case .DeletePublish:
        return "/publish/deletePublishFile"
    case .UserPublishList:
        return "/publish/userPublishList"
    case .UserLikePublishList:
        return "/publish/userLikePublishList"
    case .UserRebuildPublishList:
        return "/publish/userRebuildPublishList"
    case .UserFollowPublishList:
        return "/publish/userFollowPublishList"
    case .NewPubulishList:
        return "/publish/newPublishList"
    case .HotPublishList:
        return "/publish/hotPublishList"
    case .LikePublish:
        return "/publish/likePublish"
    case .UnLikePublish:
        return "/publish/unLikePublish"
    case .RebuildPublish:
        return "/publish/rebuildPublish"
    case .SharePublish:
        return "/publish/sharePublish"
    case .FollowUser:
        return "/relation/followUser"
    case .UnFollowUser:
        return "/relation/unFollowUser"
    case .BlockUser:
        return "/relation/blockUser"
    case .UnBlockUser:
        return "/relation/unBlockUser"
    case .UserFollowList:
        return "/relation/userFollowList"
    case .UserBeFollowList:
        return "/relation/userBeFollowList"
    case .UserUpToken:
        return "/upload/userUpToken"
    case .PublishUpToken:
        return "/upload/publishUpToken"
    case .UploadFilePath:
        return "/upload/uploadFilePath"
    }
  }
}

enum CTAParameterKey: CustomStringConvertible {
  case Data
  case UserID, NickName, UserDesc, UserIconURL, Sex, Email, Phone, AreaCode, Password, WeixinID, WeiboID, Country, Province, City, NewPassword
  case BeUserID, Start, Size, SharePlatform, List
  case PublishID, Title, PublishDesc, PublishIconURL, PreviewIconURL, PublishURL
  case RelationType, RelationUserID, FollowCount, BeFollowCount, PublishCount
  case PublishFilePath, UserFilePath
  case UpToken, UpTokenKey
  case ShareCount, RebuildCount, LikeCount, LikeStatus
  case Openid, Headimgurl, WechatName
  
  var description: String {
    switch self {
    case .Data:
      return "data"
    case .UserID:
        return "userID"
    case .NickName:
        return "nickName"
    case .UserDesc:
        return "userDesc"
    case .UserIconURL:
        return "userIconURL"
    case .Sex:
        return "sex"
    case .Email:
        return "email"
    case .Phone:
      return "phone"
    case .AreaCode:
      return "areaCode"
    case .Password:
      return "password"
    case .WeixinID:
        return "weixinID"
    case .WeiboID:
        return "weiboID"
    case .Country:
        return "country"
    case .Province:
        return "province"
    case .City:
        return "city"
    case .NewPassword:
        return "newPassword"
    case .BeUserID:
        return "beUserID"
    case .Start:
        return "start"
    case .Size:
        return "size"
    case .SharePlatform:
        return "sharePlatform"
    case .List:
        return "list"
    case .PublishID:
        return "publishID"
    case .Title:
        return "title"
    case .PublishDesc:
        return "publishDesc"
    case .PublishIconURL:
        return "publishIconURL"
    case .PreviewIconURL:
        return "previewIconURL"
    case .PublishURL:
        return "publishURL"
    case .RelationType:
        return "relationType"
    case .RelationUserID:
        return "relationUserID"
    case .FollowCount:
        return "followCount"
    case .BeFollowCount:
        return "beFollowCount"
    case .PublishCount:
        return "publishCount"
    case .PublishFilePath:
        return "publishFilePath"
    case .UserFilePath:
        return "userFilePath"
    case .UpToken:
        return "upToken"
    case .UpTokenKey:
        return "upTokenKey"
    case .ShareCount:
        return "shareCount"
    case .RebuildCount:
        return "rebuildCount"
    case .LikeCount:
        return "likeCount"
    case .LikeStatus:
        return "likeStatus"
    case .Openid:
        return "openid"
    case .Headimgurl:
        return "headimgurl"
    case .WechatName:
        return "nickname"
    }
  }
}