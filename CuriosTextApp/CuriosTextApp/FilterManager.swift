//
//  FilterManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/1/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

let defaultFiltersName = ["Be", "Ludwig", "Gingham", "Clarendon"]

class FilterManager {
    
    private(set) var filters: [FilterItem] = []
    
    func loadDefaultFilters() {
        filters = defaultFiltersName.map{FilterItem(name: $0, data: nil)}
    }
    
    deinit {
        print("\(#file) deinit")
    }

}