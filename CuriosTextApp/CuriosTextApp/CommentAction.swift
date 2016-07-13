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
        
        guard let publishID = paras["publishID"] as? String else { fatalError() }
        guard let userID = paras["userID"] as? String else { fatalError() }
        
        let vc = UIStoryboard(name: "Comment", bundle: nil).instantiateInitialViewController() as! CommentViewController
        vc.title = LocalStrings.Comment.description
        vc.publishID = publishID
        vc.myID = userID
        vc.delegate   = paras["delegate"] as? CommentViewDelegate
        
        return vc
    }
    
}
