//
//  Rewards.swift
//  Encreez App
//
//  Created by Razy Tech on 3/4/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Rewards {
    
    var Id: String?
    var Name : String?
    var Image : String?
    var Description : String?
    var GiftType : String?
    var ExpirationDate : String?

    
    init(json:JSON) {
        
        self.Id = json["Id"].string ?? ""
        self.Name = json["Name"].string ?? ""
        self.Image = json["Image"].string ?? ""
        self.Description = json["Description"].string ?? ""
        self.GiftType = json["GiftType"].string ?? ""
        self.ExpirationDate = json["ExpirationDate"].string ?? ""
    }
}
