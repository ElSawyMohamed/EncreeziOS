//
//  BranchMapViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/19/19.
//  Copyright © 2019 Razy Tech. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class BranchMapViewController: UIViewController  {
    
    var infos : RewardsViewController!
    
    var activView : ActivitiesViewController!
    
    var detailView : DetailsViewController!                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    
    var rewardsBranchData : [Rewards] = []
    
    var retailer : [BranchesOnMap] = []
    
    var idBranch : String = ""
    
    var idRetail : String = ""
    
    var retailerImg : String = ""
    
    var  flag : Bool = false
    
    let url : String = "\(Global.baseUrl)/api/customer/FindOnMap"
    
    let urlFav : String = "\(Global.baseUrl)/api/customer/AddToFavourite"
    
    let userID = UserDefaults.standard.string(forKey: "Id")
    
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    
    let imageFav = UIImage(named: "favorite")
    
    let imageNotFav = UIImage(named: "favorite_restaurant")
    
    @IBOutlet weak var segemntView: UIView!
    
    @IBOutlet weak var firstView : UIView!
    
     @IBOutlet weak var secondView : UIView!
    
     @IBOutlet weak var thirdView : UIView!

    @IBOutlet weak var favorOutlet: UIButton!
    
    @IBOutlet weak var retailName: UILabel!
    
    @IBOutlet weak var retailImg: UIImageView!
    
    @IBOutlet weak var avOffersLbl: UILabel!
    
    @IBOutlet weak var retailDist: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var addTransBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func addTrans(_ sender: UIButton) {
        
        performSegue(withIdentifier: "addTrans", sender: self )
    }
    
    @IBAction func favBtn(_ sender: Any) {
        
        if (!flag)
        {
            //for add Favourite
            flag = true
            self.favorOutlet.setImage(self.imageFav , for: .normal)
        }
        else
        {
            //for remove Favourite
            flag = false
            self.favorOutlet.setImage(self.imageNotFav , for: .normal)
        }
        let params : [String : String ] = ["RetailerId" : self.idRetail , "CustomerId" : self.userID!]
        
         addToFav(url: urlFav , parameters: params)
    }
  
    
    
    @IBAction func segmentCtrSwitch(_ sender: UISegmentedControl) {


        if  sender.selectedSegmentIndex == 0  {
            firstView.alpha = 1
            secondView.alpha = 0
            thirdView.alpha = 0
            
        }
        else if sender.selectedSegmentIndex == 1 {
            firstView.alpha = 0
            secondView.alpha = 1
            thirdView.alpha = 0
            
        }
        else if sender.selectedSegmentIndex == 2  {
            firstView.alpha = 0
            secondView.alpha = 0
            thirdView.alpha = 1
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retailImg.image = UIImage(named: "logo-1")
        
        if self.Lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.backBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        
        Global.loadIndicator(view: view)
        
        let userID = UserDefaults.standard.string(forKey: "Id")
        let latUser = UserDefaults.standard.string(forKey: "Lat")
        let longUser = UserDefaults.standard.string(forKey: "Long")
        
        let params : [String : String] = ["CategoryId" : "" , "UserId" : userID! , "Lang" : Lang! , "Lat" : latUser! , "Long" : longUser! ]
        
        getRetailers(url: url , parameters: params)
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIButton) {
        
        dismiss(animated: true , completion: nil )
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getRetailers (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                let dataJSON = JSON(response.result.value!)
                self.retailer = []
                let data = dataJSON["data"].arrayValue
                

                for i in data
                {
                    self.retailer.append(BranchesOnMap(json: i))

                    let name = i["Name"].string
                    let image = i["Image"].string
                    let retailerid = i["retailerId"].string
                    let dist = i["Distance"].string
                    let avOffers = i["AvOffers"].string
                    let isFavorite = i["IsFavorite"].bool

                    if self.idRetail == retailerid {
                        
                        
                        if  isFavorite == true  {
                            
                            self.favorOutlet.setImage(self.imageFav , for: .normal)
                            self.flag = isFavorite!
                        }
                        else
                        {
                            self.flag = false
                        }
                        ////////////////////////////////////////
                        if self.Lang == "ar"
                        {
                            self.retailDist.text = "\(dist!) كم"
                        }
                        else
                        {
                          self.retailDist.text = "Dist: \(dist!) km"
                        }
                        ////////////////////////////////////////
                        if avOffers == "0"
                        {
                           
                            self.avOffersLbl.isHidden = true
                            
                        }
                        else
                        {
                            
                            if self.Lang == "ar"
                            {
                                if avOffers == "1"
                                {
                                        self.avOffersLbl.text = "عرض واحد"
                                }
                                else
                                {
                                        self.avOffersLbl.text = "\(avOffers!) عروض"
                                }

                            }
                            else
                            {
                                 self.avOffersLbl.text = "\(avOffers!) Offer"
                                
                            }
                            
                        }
                        
                        
                        self.retailName.text = name
                        self.retailerImg = image!
                        
                        let url = URL(string: image!)
                        if url != nil {
                            
                            self.retailImg.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
                        }
                        Global.stopIndicator()
                    }
                   
                }
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
    //  Change the State of Favorite Button
    func addToFav (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
          
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dis = segue.destination  as? RewardsViewController {

            dis.rewardsRetail = self.idRetail
            dis.rewardsDataRetail = self.rewardsBranchData
        }
        if let dis2 = segue.destination  as? ActivitiesViewController {
            
            dis2.activRetail1 = self.idRetail
            
        }
        if let dis3 = segue.destination  as? DetailsViewController {
            
            dis3.detailRetail = self.idRetail
            dis3.branchID = self.idBranch
        
            
        }
        if let dis4 = segue.destination  as? addTranscationViewController {
            
       
              dis4.retailerImage = self.retailerImg
          
            
        }
    }
    
}



