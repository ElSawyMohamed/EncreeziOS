//
//  WeLanguage.swift
//  Encreez App
//
//  Created by Razy Tech on 1/13/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WebLang {
    
    var key : String = ""
    var value :String = ""
    
    
    init(json:JSON) {
        
        self.key=json["Key"].string!
        self.value=json["Value"].string!
     
    }
    
    
    
}

