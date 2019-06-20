//
//  DetailsViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/26/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit


class DetailsViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate {
    

    @IBOutlet weak var detailMap: MKMapView!
    
    @IBOutlet weak var branchPoints: UILabel!

    @IBOutlet weak var branchRedems: UILabel!
    
    @IBOutlet weak var branchPhone: UILabel!
    
    @IBOutlet weak var telPhone: UIButton!
    
    
    var detailRetail : String = ""
    
    var branchID : String = ""
    
    var phoneNumber : String = ""
    
    let userID = UserDefaults.standard.string(forKey: "Id")
    
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    
    let url : String = "\(Global.baseUrl)/api/Transaction/ConsumerDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.Lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.telPhone.transform = CGAffineTransform(scaleX: -1, y: 1)
            })
        }
        
        
        // Do any additional setup after loading the view.
        
    let params : [String : String ] = ["RetailerId" : self.detailRetail , "CustomerId" :  self.userID! , "BranchId" : self.branchID , "Lang" : self.Lang! ]
        
        getDetails(url: url , parameters: params)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func addAnnotiations(  name : String ,lat : CLLocationDegrees , long : CLLocationDegrees ) {
        
        let branchOnMap = CustomPointAnnotation()
        branchOnMap.title = name
        branchOnMap.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        detailMap.addAnnotation(branchOnMap)
        
        let radiosRegion : CLLocationDistance = 500.0
        let regions = MKCoordinateRegionMakeWithDistance(branchOnMap.coordinate, radiosRegion, radiosRegion)
        detailMap.setRegion(regions, animated: true)
        detailMap.delegate = self
        
        
    }
    
    @IBAction func callPhone(_ sender: Any) {
        
        makeCall()
    }
    func  getDetails(url : String , parameters : [String : String])
    {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                let dataJSON = JSON(response.result.value!)
                let lat = dataJSON["data"]["lat"].string ?? ""
                let long =  dataJSON["data"]["lng"].string ?? ""
                let name = dataJSON["data"]["Name"].string ?? ""
                let points = dataJSON["data"]["Cust_Point"].int ?? 0
                let redeems = dataJSON["data"]["Redeems"].int ?? 0
                let phone = dataJSON["data"]["Phone"].string ?? ""
            
                
                let latCll = Double(lat) ?? 0
                let longCll = Double(long) ?? 0
                
                
                self.addAnnotiations( name: name , lat: latCll , long: longCll )
                self.branchPoints.text = "\(points)"
                self.branchRedems.text = "\(redeems)"
                self.branchPhone.text = phone
                self.phoneNumber = phone
                
            }
            else
            {
               
                if self.Lang == "ar"
                {
                    let alert = UIAlertController(title: "تحذير", message: "حاول مرة اخري", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    
                    
                    let alert = UIAlertController(title: "Warning", message: "Please Try again Later", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }

    func makeCall()
    {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
}
