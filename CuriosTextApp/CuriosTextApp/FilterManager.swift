//
//  FilterManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/1/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
// "-Amaro", "-Mayfair", "-Rise", "-Hudson", "-X-Pro II", "-Sierra", "-Willow" "-Lo-Fi", "-Earlybird"  "-Hefe", "Brannan"
let defaultFiltersName = ["Origin","Clarendon","Juno","Ludwig","Lark","Valencia","Crema","Moon","Gingham","Aden","Slumber","Reyes","Perpetua","Inkwell","Nashville"]

class FilterManager {
    
    fileprivate(set) var filters: [FilterItem] = []
    
    func loadDefaultFilters() {
        filters = defaultFiltersName.map{FilterItem(name: $0, data: nil)}
    }
    
    func cleanImage() {
        for i in filters {
            i.cleanImage()
        }
    }
    
    func filter(ByName name: String) -> FilterItem? {
        if filters.count > 0 {
            if name.isEmpty {
                return nil
            } else {
                if let index = defaultFiltersName.index(of: name) {
                    return filters[index]
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
    
    func filterIndex(byName name: String) -> Int {
        if filters.count <= 0 {
            return 0
        } else {
            return defaultFiltersName.index(of: name) ?? 0
        }
    }
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
    }

}
