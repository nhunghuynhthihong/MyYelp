//
//  Filters.swift
//  MyYelp
//
//  Created by Nhung Huynh on 7/16/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import Foundation

// Model class that represents the user's search filterring
class Filters: NSObject {
    var hasDeal = false
    var distance: Float? = 0.0
    var sortBy: Int? = 0
    var categories = [String]()
    override init() {
        
    }
}
