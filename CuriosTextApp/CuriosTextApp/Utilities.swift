//
//  Utilities.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/23/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

func gobal_jumpToAppStoreRation() {
    
    let appID = "1090836500"
    let url = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
    
    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
}