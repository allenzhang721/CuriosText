//
//  CTAError.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/14/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

enum CTAUploadError:Int, Error{
    case connectFail = 10
}

enum CTAInternetError:Int, Error{
    case connectFail = 10
}

enum CTAUserLoginError: Int, Error{
    
    case userNameOrPasswordWrong = 1
    case phoneIsEmpty = 2
    case phoneNotExist = 3
    case userDeleted = 4
    case needContactWithService = 8
    case dataIsEmpty = 9
}

/*

1:用户名或密码错误
2:手机号码为空
3:手机用户不存在
4:用户已删除
8:请联系客服
9:数据为空

*/

enum CTAPhoneRegisterError:Int, Error{
    
    case phoneIsEmpty = 1
    case phoneExist = 2
    case userIsDelete = 4
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:手机号码为空
2:手机号码已经绑定用户
8:请联系客服
9:数据为空

*/

enum CTAWeixinRegisterError:Int, Error{
    
    case weixinIDIsEmpty = 1
    case weixinIDExist = 2
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:微信id为空
2:微信id已经绑定用户
8:请联系客服
9:数据为空

*/

enum CTAWeiboRegisterError:Int, Error{
    
    case weiboIDIsEmpty = 1
    case weiboIDExist = 2
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:微博id为空
2:微博id已经绑定用户
8:请联系客服
9:数据为空

*/

enum CTARequestUserError:Int, Error{
    
    case userIDIsEmpty = 1
    case userIDNotExist = 2
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:userid为空
2:userid不存在
8:请联系客服
9:数据为空

*/

enum CTABindingUserPhoneError:Int, Error{
    
    case userIDIsEmpty  = 1
    case userIDNotExist = 2
    case phoneIsEmpty   = 3
    case phoneExist     = 4
    case needContactWithService = 8
    case dataIsEmpty = 9
    
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

enum CTABindingUserWeixinError:Int, Error{
    
    case userIDIsEmpty  = 1
    case userIDNotExist = 2
    case weixinIsEmpty   = 3
    case userHaveWeixin  = 4
    case weixinExist     = 5
    case needContactWithService = 8
    case dataIsEmpty = 9
    
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

enum CTABindingUserWeiboError:Int, Error{
    
    case userIDIsEmpty  = 1
    case userIDNotExist = 2
    case weiboIsEmpty   = 3
    case userHaveWeibo  = 4
    case weiboExist     = 5
    case needContactWithService = 8
    case dataIsEmpty = 9
    
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

enum CTACheckPasswordError:Int, Error{
    
    case passwordIncorrect  = 1
    case userIDIsEmpty  = 2
    case userIDNotExist = 3
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*
1:密码不正确
2:userid为空
3:userid不存在
8:请联系客服
9:数据为空

*/


enum CTAResetPasswordError:Int, Error{
    
    case phoneIsEmpty = 1
    case phoneNotExist = 2
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:Phone为空
2:Phone不存在
8:请联系客服
9:数据为空

*/

enum CTAUserDetailError:Int, Error{
    
    case beUserIDEmpty = 1
    case beUserIDNotExist = 2
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:预览用户id为空
2:预览用户不存在
8:请联系客服
9:数据为空

*/

enum CTAPublishDeleteError:Int, Error{
    
    case publishIDEmpty = 1
    case publishIDNotExist = 2
    case userIDEmpty = 3
    case userNotCompare = 4
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:发布id为空
2:发布不存在
3:用户id 为空
4:用户和发布用户不匹配
8:请联系客服
9:数据为空

*/

enum CTAPublishListError:Int, Error{
    
    case userIDEmpty = 1
    case userIDNotExist = 2
    case beUserIDEmpty = 3
    case beUserIDNotExist = 4
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:userID为空
2:userID不存在
3:beuserID 为空
4:beuserID不存在
8:请联系客服
9:数据为空

*/

enum CTAUserPublishError:Int, Error{
    
    case userIDEmpty = 1
    case userIDNotExist = 2
    case publishIDNotExist = 3
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:userID为空
2:userID不存在
3:发布文件不存在
8:请联系客服
9:数据为空

*/

enum CTAUserRelationError:Int, Error{
    
    case relationUserIDEmpty = 1
    case userIDNotExist = 2
    case relationUserIDNotExist = 3
    case userIDSame = 4
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:userID为空
2:userID不存在
3:关系userID不存在
4:userID 和 关系userID一样
8:请联系客服
9:数据为空

*/

enum CTAUserRelationListError:Int, Error{
    
    case beUserIDEmpty = 1
    case beUserNotExist = 2
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*

1:beUserID为空
2:beUserID不存在
8:请联系客服
9:数据为空

*/

enum CTAPublishHotError:Int, Error{
    
    case publishIDNotExist = 1
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*
 
 1:publishID为空
 8:请联系客服
 9:数据为空
 
 */

enum CTAPublishError:Int, Error{
    
    case publishIDEmpty = 1
    case publishIDNotExist = 2
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*
 
 1:publishID为空
 8:请联系客服
 9:数据为空
 
 */


enum CTAAddCommentError:Int, Error{
    
    case publishIDEmpty = 1
    case userIDNotExist = 2
    case publishIDNotExist = 3
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*
 
 1:publishID为空
 8:请联系客服
 9:数据为空
 
 */

enum CTADeleteCommentError:Int, Error{
    
    case commentIDEmpty = 1
    case commentIDNotExist = 2
    case publishIDNotExist = 3
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*
 
 1:publishID为空
 8:请联系客服
 9:数据为空
 
 */

enum CTARequestNoticeError:Int, Error{
    
    case noticeIDIsEmpty = 1
    case noticeIDNotExist = 2
    case needContactWithService = 8
    case dataIsEmpty = 9
    
}

/*
 
 1:userid为空
 2:userid不存在
 8:请联系客服
 9:数据为空
 
 */

