//
//  NearByViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/14/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NearByViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var emptTable: UIView!
    
    @IBOutlet weak var nearByTable: UITableView!
    
    let userID = UserDefaults.standard.string(forKey: "Id")
    
    let lang = UserDefaults.standard.string(forKey: "Lang")
    
    let lat = UserDefaults.standard.string(forKey: "Lat")
    
    let long = UserDefaults.standard.string(forKey: "Long")
    
    let imageFav = UIImage(named: "favorite")
    
    let imageNotFav = UIImage(named: "favorite_restaurant")
    
    let urlFav : String = "\(Global.baseUrl)/api/customer/AddToFavourite"
    
    let urlNear : String = "\(Global.baseUrl)/api/customer/FindOnMap"
    
    var categoryID : String = ""
    
    var indexPath:IndexPath!
  
    var index:IndexPath?
    
    var retailId : String = ""
    
    var branchId : String = ""

    var nearByBranches : [BranchesOnMap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.nearByTable.separatorStyle = UITableViewCellSeparatorStyle.none
      self.nearByTable.estimatedSectionHeaderHeight = 40
        
        Global.loadIndicator(view: view)
        
        let params : [String : String ] = ["CategoryID" : "" , "UserId" : self.userID! , "Lang" : self.lang! , "Lat" : self.lat! , "Long" : self.long!]
  
        nearBy(url: urlNear , parameters: params)
        
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    

    @IBAction func closeNearBy(_ sender: UIButton) {
        
        dismiss(animated: true , completion: nil )
    }
    
    func nearBy(url : String , parameters :[String : String ])
    {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {  
                let dataJSON = JSON(response.result.value!)
                let data = dataJSON["data"].arrayValue
                for i in data
                {
                    self.nearByBranches.append(BranchesOnMap(json: i))
                    Global.stopIndicator()
                }
                if self.nearByBranches.count == 0
                {
                    self.nearByTable.backgroundView = self.emptTable
                }
                self.nearByTable.reloadData()
            }
            else
            {
                if self.lang == "ar"
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearTable", for: indexPath) as! NearByViewControllerCell
        
        cell.nameBranch.text = nearByBranches[indexPath.row].Name
        cell.distBranch.text = "\(nearByBranches[indexPath.row].Distance!)"
        cell.imgBranch.layer.cornerRadius = 0.5 * cell.imgBranch.bounds.size.width
        
        

        print(nearByBranches[indexPath.row].IsFavorite as Any)
        cell.favBtnOut.addTarget(self, action: #selector(favorBtn(sender:)), for: .touchUpInside)
       
        let url = URL(string: nearByBranches[indexPath.row].Image!)
        if url  !=  nil {
            
            cell.imgBranch.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        cell.flag = nearByBranches[indexPath.row].IsFavorite
        
        if !(nearByBranches[indexPath.row].IsFavorite)
        {
            cell.favBtnOut.setImage(self.imageNotFav , for: .normal)
        }
        else
        {
            cell.favBtnOut.setImage(self.imageFav , for: .normal)
            
        }

                cell.favBtnOut.tag = indexPath.row

        return cell
    }
    
    @objc func favorBtn(sender:UIButton)  {
        
      
        let params : [String : String ] = ["RetailerId" : nearByBranches[sender.tag].retailerId! , "CustomerId" : self.userID! ]

        addToFav(url: urlFav , parameters: params  , position: sender.tag)
        
            }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         self.retailId = nearByBranches[indexPath.row].retailerId!
         self.branchId = nearByBranches[indexPath.row].Id!
        
       performSegue(withIdentifier: "showBranch", sender: self )
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearByBranches.count
    }
    
    func addToFav (url : String , parameters :[String : String ] ,  position :Int)  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                if  self.nearByBranches[position].IsFavorite ==  true {
                    self.nearByBranches[position].IsFavorite = false
                }else {
                    self.nearByBranches[position].IsFavorite = true
                }
                 self.nearByTable.reloadData()
                
            }
            else
            {
               
                if self.lang == "ar"
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
        
        if let dis = segue.destination as? BranchMapViewController
        {
            
            dis.idRetail = self.retailId
            dis.idBranch = self.branchId
            
        
        }
    }
}

