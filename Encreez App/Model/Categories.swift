//
//  Categories.swift
//  Encreez App
//
//  Created by Razy Tech on 2/3/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Categories {
    
    var CategoryId: String?
    var CategoryName : String?
    var Count : Int?
    var Image : String?
    
    init(json:JSON) {
        
        self.CategoryId = json["CategoryId"].string ?? ""
        self.CategoryName = json["CategoryName"].string ?? ""
        self.Count = json["Count"].int ?? 0
        self.Image = json["Image"].string ?? ""
        
    }
}
