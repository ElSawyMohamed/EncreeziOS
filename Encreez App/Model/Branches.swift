//
//  NearByBranch.swift
//  Encreez App
//
//  Created by Razy Tech on 2/14/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Branches {

    var retailerId: String?
    var Name : String?
    var Image : String?
    var Logo : String?
    var Id : String?
    var Latitude : String?
    var Longitude : String?
    var Distance : String?
    var AvOffers : String?
    var IsFavorite : Bool?
    

    init(json:JSON) {
        
        self.retailerId = json["retailerId"].string ?? ""
        self.Name = json["Name"].string ?? ""
        self.Image = json["Image"].string ?? ""
        self.Logo = json["Logo"].string ?? ""
        self.Id = json["Id"].string ?? ""
        self.Latitude = json["Latitude"].string ?? ""
        self.Longitude = json["Longitude"].string ?? ""
        self.Distance = json["Distance"].string ?? ""
        self.AvOffers = json["Longitude"].string ?? ""
        self.IsFavorite = json["Distance"].bool ?? false
      }
}
