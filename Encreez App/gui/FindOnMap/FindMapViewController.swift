//
//  FindMapViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 1/13/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit
import SDWebImage


class FindMapViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate , UISearchBarDelegate ,  UITabBarDelegate , UITabBarControllerDelegate{
    
    
    @IBOutlet weak var countNear: UILabel!
    
    let url : String = "\(Global.baseUrl)/api/customer/FindOnMap"
    
    let urlOffer : String = "\(Global.baseUrl)/api/customer/OffersOnMap"
    
    let imageProfile  =  UserDefaults.standard.string(forKey: "Image")
    
    let userID = UserDefaults.standard.string(forKey: "Id")
    
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    
    let genderType = UserDefaults.standard.string(forKey: "GenderType")
    
    var  messag : String = ""
    
    @IBOutlet weak var findLbl: UILabel!
    
    @IBOutlet weak var offerLbl: UILabel!
    
    @IBOutlet weak var shopLbl: UILabel!
    
    @IBOutlet weak var categoryName: UIButton!
    
    var categoryNameLbl : String = "Categories"
    
    @IBOutlet weak var proBtn: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchTxt: UISearchBar!
    
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var btnOutNear: UIButton!
    
    var branches : [BranchesOnMap] = []
    
    var categoryId : String = ""
    
    var idRetailMap : String = ""
    
    var BranchID : String = ""
    
    var locationManager: CLLocationManager?
    
    var male : String = ""
    
    var female : String = ""
    
    
    func searchBarSearchButtonClicked(_ searchBar : UISearchBar){
        
        performSegue(withIdentifier: "SearchView", sender: self)
    
    }
    @IBAction func findBtn(_ sender: UIBarButtonItem) {
        
        Global.loadIndicator(view: mapView)
        mapView.removeAnnotations(mapView.annotations)
        
        let latUser = UserDefaults.standard.string(forKey: "Lat")
        let longUser = UserDefaults.standard.string(forKey: "Long")
            

        let params : [String : String] = ["CategoryId" : "" , "UserId" : self.userID! , "Lang" : self.Lang! , "Lat" : latUser! , "Long" : longUser!]
        
        
        getRetailers(url: url , parameters: params)
        
        if self.Lang == "ar"
        {
            self.categoryName.setTitle("اقسام" , for: .normal)
        }
        else
        {
            self.categoryName.setTitle(categoryNameLbl , for: .normal)
            
        }
        }
  
    @IBAction func offersBtn(_ sender: UIBarButtonItem) {
        
        Global.loadIndicator(view: mapView)
        mapView.removeAnnotations(mapView.annotations)
        
        let latUser = UserDefaults.standard.string(forKey: "Lat")
        let longUser = UserDefaults.standard.string(forKey: "Long")
        
        let params : [String : String] = ["CategoryId" : self.categoryId , "UserId" : self.userID! , "Lang" : self.Lang! , "Lat" : latUser! , "Long" : longUser!]
        
        
        getOffers(url: urlOffer , parameters: params)

    }
    @IBAction func shopsBtn(_ sender: UIBarButtonItem) {
       
        performSegue(withIdentifier: "myShop", sender: self)
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        Global.loadIndicator(view: mapView)

        // to get location of the User
        
        self.locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.stopUpdatingLocation()
        
        let latLoc = locationManager?.location?.coordinate.latitude ?? 0
        
        let longLoc = locationManager?.location?.coordinate.longitude ?? 0
        
        let mokHQ = CLLocation(latitude:(latLoc), longitude: (longLoc))
        
        let radiosRegion : CLLocationDistance = 1000.0
        let regions = MKCoordinateRegionMakeWithDistance(mokHQ.coordinate, radiosRegion, radiosRegion)
        mapView.setRegion(regions, animated: true)
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        self.viewTop.layer.cornerRadius = 9
        self.viewTop.clipsToBounds = true
        self.btnOutNear.layer.cornerRadius = 0.5 * btnOutNear.bounds.size.width;
        
        self.proBtn.layer.cornerRadius = 0.5 * proBtn.bounds.size.width;
        self.proBtn.layer.borderWidth = 1
        self.proBtn.layer.borderColor = UIColor(red: 93/255 , green: 188/255 , blue: 210/255 , alpha: 1.0 ).cgColor
        
        
        searchTxt.delegate = self
        
        if self.Lang == "ar"
        {
            
            self.male  = "ذكر"
            self.female = "انثي"
            
        }
        else
        {
            self.male  = "Male"
            self.female = "Female"
        }
        
        if genderType == "1"
        {
            UserDefaults.standard.set(self.male, forKey: "Gender")
        }
        else
        {
            UserDefaults.standard.set(self.female, forKey: "Gender")
        }
        
        if self.Lang == "ar"
        {
            self.categoryName.setTitle("اقسام" , for: .normal)
        }
        else
        {
            self.categoryName.setTitle(categoryNameLbl , for: .normal)
            
        }
        
        if (imageProfile?.isEmpty)!
        {

            self.proBtn.setImage(UIImage(named: "avatar_profile" ), for: .normal)
        }
        else

        {
           self.proBtn.sd_setImage(with: URL(string: self.imageProfile!), for: .normal)

        }

        UserDefaults.standard.set(latLoc , forKey: "Lat")
        
        UserDefaults.standard.set(longLoc , forKey: "Long")
        
        let latUser = UserDefaults.standard.string(forKey: "Lat")
        
        let longUser = UserDefaults.standard.string(forKey: "Long")
        
        //  to get branches on Map
        
        let params : [String : String] = ["CategoryId" : self.categoryId , "UserId" : self.userID! , "Lang" : self.Lang! , "Lat" : latUser! , "Long" : longUser!]
        
        getRetailers(url: url , parameters: params)

        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    
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
  
    func locationManager(manager: CLLocationManager!,   didUpdateLocations locations: [AnyObject]!) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    func getRetailers (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
            Global.stopIndicator()
            let dataJSON = JSON(response.result.value!)
                self.branches = []
                let data = dataJSON["data"].arrayValue
                let stat = dataJSON["Status"].bool
                let mess = dataJSON["Message"].string ?? ""
                
                self.messag  =  mess
                
                if stat == false
                {
                self.performSegue(withIdentifier: "NoRetailers", sender: self )
                }
               else {
                    
                    for i in data
                    {
                        self.branches.append(BranchesOnMap(json: i))
                        let lat = i["Latitude"].string ?? ""
                        let long = i["Longitude"].string ?? ""
                        let name = i["Name"].string
                        let retailerId = i["retailerId"].string
                        let branchId = i["Id"].string
                        
                        let latCll = Double(lat) ?? 0
                        let longCll = Double(long) ?? 0
                        
                        self.addAnnotiations( idBranch : branchId! , idRetail : retailerId! , name: name! ,lat: latCll , long: longCll)
                    }
                    
                    self.countNear.text = "\(data.count)"
                }
            }
            else
            {
                if self.Lang == "en"
                { let alert = UIAlertController(title: "تحذير", message: "حاول مرة اخري", preferredStyle: .actionSheet)
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
    func addAnnotiations( idBranch : String , idRetail : String , name : String ,lat : CLLocationDegrees , long : CLLocationDegrees ) {

        
        let branchOnMap = CustomPointAnnotation()
        branchOnMap.title = name
        branchOnMap.id = idRetail
        self.idRetailMap = idRetail
        branchOnMap.branchId = idBranch
        self.idRetailMap = idBranch
        branchOnMap.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(branchOnMap)

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let id = (view.annotation as? CustomPointAnnotation)?.id
        {
          self.idRetailMap  = id
        }

        if let idBran = (view.annotation as? CustomPointAnnotation)?.branchId
        {
            self.BranchID  = idBran
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        performSegue(withIdentifier: "ShowRetailer", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dis = segue.destination as? BranchMapViewController
        {
            
            dis.idRetail = self.idRetailMap
            dis.idBranch = self.BranchID
        }
        
        if let dis2 = segue.destination as? SearchViewController
        {
            
            dis2.search = self.searchTxt.text!
            
        }
        
        if let dis3 = segue.destination as? NearByViewController
        {
            
            dis3.categoryID = self.categoryId
        }
        
        if let dis4 = segue.destination as? NoRetailerViewController

        {
            dis4.noRetailers = self.messag
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView =  UIButton.init(type: UIButtonType.detailDisclosure)
            annotationView?.image = UIImage(named: "EncreezIcon")
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    ///// Offers on Map
    
    func getOffers (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                Global.stopIndicator()
                let dataJSON = JSON(response.result.value!)
                self.branches = []
                let data = dataJSON["data"].arrayValue
                for i in data
                {
                    self.branches.append(BranchesOnMap(json: i))
                    let lat = i["Latitude"].string ?? ""
                    let long = i["Longitude"].string ?? ""
                    let name = i["Name"].string
                    let retailerId = i["retailerId"].string
                    let  branchId = i["Id"].string

                    let latCll = Double(lat) ?? 0
                    let longCll = Double(long) ?? 0
                    
                    self.addAnnotiations( idBranch : branchId! , idRetail : retailerId! , name: name! ,lat: latCll , long: longCll)
                }
                self.countNear.text = "\(data.count)"
            }
            else
            {
                if self.Lang == "en"
                {
                    let alert = UIAlertController(title: "Warning", message: "Please Try again Later", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "تحذير", message: "حاول مرة اخري", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }

    @IBAction func nearBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "showNearBy", sender: self )
    }
    

}
