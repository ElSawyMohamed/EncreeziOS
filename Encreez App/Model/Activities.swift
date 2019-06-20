//
//  Activities.swift
//  Encreez App
//
//  Created by Razy Tech on 3/6/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Activities {
    
    var Name: String?
    var TransactionType : String?
    var TransactionDate : String?
    var Image : String?
    var Description : String?
    
    
    init(json:JSON) {
        
        self.Name = json["Name"].string ?? ""
        self.TransactionType = json["TransactionType"].string ?? ""
        self.TransactionDate = json["TransactionDate"].string ?? ""
        self.Description = json["Description"].string ?? ""
        self.Image = json["Image"].string ?? ""
    }
}
