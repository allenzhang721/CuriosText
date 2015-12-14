//
//  CTAError.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/14/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

enum CTAUserLoginError:Int, ErrorType {
    
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