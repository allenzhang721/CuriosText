//
//  FilterManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/1/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
// "-Amaro", "-Mayfair", "-Rise", "-Hudson", "-X-Pro II", "-Sierra", "-Willow" "-Lo-Fi", "-Earlybird"  "-Hefe", "Brannan"
let defaultFiltersName = ["Origin","Clarendon", "Gingham", "Moon", "Lark", "Reyes", "Juno", "Slumber", "Crema", "Ludwig", "Aden", "Perpetua", "Valencia", "Inkwell", "Nashville"]

class FilterManager {
    
    private(set) var filters: [FilterItem] = []
    
    func loadDefaultFilters() {
        filters = defaultFiltersName.map{FilterItem(name: $0, data: nil)}
    }
    
    deinit {
        print("\(#file) deinit")
    }

}