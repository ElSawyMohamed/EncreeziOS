//
//  MyFavourites.swift
//  Encreez App
//
//  Created by Razy Tech on 3/26/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MyFavourites {
    
    var Name : String?
    var Image : String?
    var Logo : String?
    var Id : String?
    var AvOffers : String?
  
    
    
    init(json:JSON) {
        
       
        self.Name = json["Name"].string ?? ""
        self.Image = json["Image"].string ?? ""
        self.Logo = json["Logo"].string ?? ""
        self.Id = json["Id"].string ?? ""
        self.AvOffers = json["AvOffers"].string ?? ""
    }
}
