//
//  LikersAction.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class LikersAction: NSObject {

    
    class func likerListViewController(paras: [String: AnyObject]) -> UIViewController {
        guard let publishID = paras["publishID"] as? String else { fatalError() }
        
        let vc = UserListViewController()
        vc.publishID = publishID
        vc.type      = UserListType.Likers
        vc.delegate  = paras["delegate"] as? UserListViewDelegate
        return vc
    }
}
