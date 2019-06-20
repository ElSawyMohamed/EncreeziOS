//
//  WelcomeViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 1/9/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON


class WelcomeViewController: UIViewController , CLLocationManagerDelegate {
    
    var wel_url = "\(Global.baseUrl)/api/customer/Welcome"
    
    var  SelectedItem : String?
    
    var app_Lang  = UserDefaults.standard.string(forKey: "Lang")
    
    @IBOutlet weak var signBtn: UIButton!

   @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var welLab: UILabel!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        
        self.signBtn.layer.cornerRadius = 17
        self.signBtn.clipsToBounds = true



        self.signUpBtn.layer.cornerRadius = 17
        self.signUpBtn.clipsToBounds = true
        self.signUpBtn.layer.borderWidth = 1
        self.signUpBtn.layer.borderColor = Global.anyColor().cgColor
    
         Global.loadIndicator(view: view)
        
        let params : [String : String] = ["Lang" : self.app_Lang!]

        getWelcomeLanguge(url: wel_url, parameters: params)
    }
    
    // Get Language Function thats the Whole app depends on it.
    
    func getWelcomeLanguge (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
             response in
            if response.result.isSuccess
            {
                Global.stopIndicator()
                let dataJSON = JSON(response.result.value!)
                let welMess = dataJSON["Message"].string
                self.welLab.text = welMess
                
            }
            else
            {
               print("my Error\(response.result.error!)")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.stopUpdatingLocation()
        
       let latLoc = locationManager?.location?.coordinate.latitude ?? 0
        
       let longLoc = locationManager?.location?.coordinate.longitude ?? 0
        
        
        if (self.app_Lang == "ar") {
            
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
           
        } else {
            
            
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        self.viewDidLoad()
        
    }

    
}

