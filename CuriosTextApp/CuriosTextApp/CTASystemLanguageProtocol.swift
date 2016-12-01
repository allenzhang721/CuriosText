//
//  CTASystemLanguageProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/18.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
protocol CTASystemLanguageProtocol{
    func getCurrentLanguage()-> String
    func getSystemLanguages()-> NSArray
}

extension CTASystemLanguageProtocol{
    func getCurrentLanguage() -> String{
        let languages:NSArray = self.getSystemLanguages()
        return languages.object(at: 0) as! String
    }
    
    func getSystemLanguages() -> NSArray{
        let userDefault = UserDefaults.standard
        let languages:NSArray = userDefault.object(forKey: "AppleLanguages") as! NSArray
        return languages
    }
}
