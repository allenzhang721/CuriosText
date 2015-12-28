//
//  CTAError.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/14/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

enum CTAUploadError:Int, ErrorType{
    case ConnectFail = 10
}

enum CTAInternetError:Int, ErrorType{
    case ConnectFail = 10
}

enum CTAUserLoginError: Int, ErrorType{
    
    case UserNameOrPasswordWrong = 1
    case PhoneIsEmpty = 2
    case PhoneNotExist = 3
    case UserDeleted = 4
    case NeedContactWithService = 8
    case DataIsEmpty = 9
}

/*

1:用户名或密码错误
2:手机号码为空
3:手机用户不存在
4:用户已删除
8:请联系客服
9:数据为空

*/

enum CTAPhoneRegisterError:Int, ErrorType{
    
    case PhoneIsEmpty = 1
    case PhoneExist = 2
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:手机号码为空
2:手机号码已经绑定用户
8:请联系客服
9:数据为空

*/

enum CTAWeixinRegisterError:Int, ErrorType{
    
    case WeixinIDIsEmpty = 1
    case WeixinIDExist = 2
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:微信id为空
2:微信id已经绑定用户
8:请联系客服
9:数据为空

*/

enum CTAWeiboRegisterError:Int, ErrorType{
    
    case WeiboIDIsEmpty = 1
    case WeiboIDExist = 2
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:微博id为空
2:微博id已经绑定用户
8:请联系客服
9:数据为空

*/

enum CTARequestUserError:Int, ErrorType{
    
    case UserIDIsEmpty = 1
    case UserIDNotExist = 2
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:userid为空
2:userid不存在
8:请联系客服
9:数据为空

*/

enum CTABindingUserPhoneError:Int, ErrorType{
    
    case UserIDIsEmpty  = 1
    case UserIDNotExist = 2
    case PhoneIsEmpty   = 3
    case UserHavePhone  = 4
    case PhoneExist     = 5
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:userid为空
2:userid不存在
3:手机号为空
4:用户已绑定手机号
5:手机号已绑定用户
8:请联系客服
9:数据为空

*/

enum CTABindingUserWeixinError:Int, ErrorType{
    
    case UserIDIsEmpty  = 1
    case UserIDNotExist = 2
    case WeixinIsEmpty   = 3
    case UserHaveWeixin  = 4
    case WeixinExist     = 5
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:userid为空
2:userid不存在
3:微信号为空
4:用户已绑定微信号
5:微信号已绑定用户
8:请联系客服
9:数据为空

*/

enum CTABindingUserWeiboError:Int, ErrorType{
    
    case UserIDIsEmpty  = 1
    case UserIDNotExist = 2
    case WeiboIsEmpty   = 3
    case UserHaveWeibo  = 4
    case WeiboExist     = 5
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:userid为空
2:userid不存在
3:微博号为空
4:用户已绑定微博号
5:微博号已绑定用户
8:请联系客服
9:数据为空

*/

enum CTACheckPasswordError:Int, ErrorType{
    
    case PasswordIncorrect  = 1
    case UserIDIsEmpty  = 2
    case UserIDNotExist = 3
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*
1:密码不正确
2:userid为空
3:userid不存在
8:请联系客服
9:数据为空

*/


enum CTAResetPasswordError:Int, ErrorType{
    
    case PhoneIsEmpty = 1
    case PhoneNotExist = 2
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:Phone为空
2:Phone不存在
8:请联系客服
9:数据为空

*/

enum CTAUserDetailError:Int, ErrorType{
    
    case BeUserIDEmpty = 1
    case BeUserIDNotExist = 2
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:预览用户id为空
2:预览用户不存在
8:请联系客服
9:数据为空

*/

enum CTAPublishDeleteError:Int, ErrorType{
    
    case PublishIDEmpty = 1
    case PublishIDNotExist = 2
    case UserIDEmpty = 3
    case UserNotCompare = 4
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:发布id为空
2:发布不存在
3:用户id 为空
4:用户和发布用户不匹配
8:请联系客服
9:数据为空

*/

enum CTAPublishListError:Int, ErrorType{
    
    case UserIDEmpty = 1
    case UserIDNotExist = 2
    case BeUserIDEmpty = 3
    case BeUserIDNotExist = 4
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:userID为空
2:userID不存在
3:beuserID 为空
4:beuserID不存在
8:请联系客服
9:数据为空

*/

enum CTAUserPublishError:Int, ErrorType{
    
    case UserIDEmpty = 1
    case UserIDNotExist = 2
    case PublishIDNotExist = 3
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:userID为空
2:userID不存在
3:发布文件不存在
8:请联系客服
9:数据为空

*/

enum CTAUserRelationError:Int, ErrorType{
    
    case RelationUserIDEmpty = 1
    case UserIDNotExist = 2
    case RelationUserIDNotExist = 3
    case UserIDSame = 4
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:userID为空
2:userID不存在
3:关系userID不存在
4:userID 和 关系userID一样
8:请联系客服
9:数据为空

*/

enum CTAUserRelationListError:Int, ErrorType{
    
    case BeUserIDEmpty = 1
    case BeUserNotExist = 2
    case NeedContactWithService = 8
    case DataIsEmpty = 9
    
}

/*

1:beUserID为空
2:beUserID不存在
8:请联系客服
9:数据为空

*/