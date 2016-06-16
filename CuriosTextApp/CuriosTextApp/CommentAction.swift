//
//  CommentAction.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class CommentAction: NSObject {
    
    class func commentViewController(paras: [String: AnyObject]) -> UIViewController {
        
        guard let userID = paras["userID"] as? String else { fatalError() }
        
        let vc = CommentViewController()
        vc.userID = userID
        
        return vc
    }
    
}
