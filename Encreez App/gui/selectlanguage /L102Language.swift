//
//  L102Language.swift
//  Encreez App
//
//  Created by Razy Tech on 5/14/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit

// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// L102Language
class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        let currentWithoutLocale = current.substring(to: current.characters.index(current.startIndex, offsetBy: 2))
        return currentWithoutLocale
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(_ lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
    
}
