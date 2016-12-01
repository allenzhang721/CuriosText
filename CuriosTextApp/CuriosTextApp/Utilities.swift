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
    
    UIApplication.shared.openURL(URL(string: url)!)
}

struct CTAShareConfig {
    static let shareURL = "http://www.curiosapp.com/sharedownload/index.html"//"https://itunes.apple.com/cn/app/curios-let-photos-lively/id1090836500?l=en&mt=8"
}
