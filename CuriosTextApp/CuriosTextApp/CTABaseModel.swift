//
//  CTABaseModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/14/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol CTABaseModel {
    
    static func generateFrom(json: JSON) throws -> Self
    func save() throws
}
    