//
//  TemplateModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/26/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
struct TemplateModel {
    let ID: String
    let author: String
    let date: String
    let name: String
    let pagePath: String
    let thumbImgPath: String
    init?(_ info: [String: AnyObject]) {
        guard let ID = info["ID"] as? String else { return nil }
        guard let author = info["author"] as? String else { return nil }
        guard let date = info["date"] as? String else { return nil }
        guard let name = info["name"] as? String else { return nil }
        guard let pagePath = info["pagePath"] as? String else { return nil }
        guard let thumbImg = info["thumbImgPath"] as? String else { return nil }
        self.ID = ID
        self.author = author
        self.date = date
        self.name = name
        self.pagePath = pagePath
        self.thumbImgPath = thumbImg
    }
}