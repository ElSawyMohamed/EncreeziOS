//
//  ShopsViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 3/26/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ShopsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
 
    let url : String = "\(Global.baseUrl)/api/customer/GetMyFavourite"
    
    let urlFav : String = "\(Global.baseUrl)/api/customer/AddToFavourite"
    
    let userID = UserDefaults.standard.string(forKey: "Id")
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    
    @IBOutlet var emptView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    var shopsData : [MyFavourites] = []
    
    @IBOutlet weak var shopTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.Lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.backBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        
        
        Global.loadIndicator(view: view)
        
        
        
        let params : [String : String ] = ["CustomerId": self.userID! , "Lang" : self.Lang!]
        
        getFavouriteShops(url: url , parameters: params)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func getFavouriteShops (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                Global.stopIndicator()
                let dataJSON = JSON(response.result.value!)
                self.shopsData = []
                let data = dataJSON["data"].arrayValue
                for i in data
                {
                    self.shopsData.append(MyFavourites(json: i))
                    
                    Global.stopIndicator()
                }
                if self.shopsData.count == 0
                {
                     self.shopTable.separatorStyle = UITableViewCellSeparatorStyle.none
                    self.shopTable.backgroundView = self.emptView
                }
                self.shopTable.reloadData()
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shopsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopTableViewCell
        
        cell.nameLbl.text = shopsData[indexPath.row].Name
        cell.avOffers.text = shopsData[indexPath.row].AvOffers
        cell.imageShop.layer.cornerRadius = 0.5 * cell.imageShop.bounds.size.width
        cell.favBtn.addTarget(self, action: #selector(favorBtn(sender:)), for: .touchUpInside)
        
        shopTable.backgroundView?.isHidden = true
        let url = URL(string: shopsData[indexPath.row].Image!)
        if url != nil {
            
            cell.imageShop.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            
        }
        
        return cell
        
    }
    @objc func favorBtn(sender:UIButton)  {
        
       
        
        Global.stopIndicator()
        
        let params : [String : String ] = ["RetailerId" : shopsData[sender.tag].Id! , "CustomerId" : self.userID! ]
        
        addToFav(url: urlFav , parameters: params  , position: sender.tag)
      
         self.shopsData.remove(at: sender.tag)
        
        self.shopTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       dismiss(animated: true, completion: nil)
        
    }
    @IBAction func backBtn(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    func addToFav (url : String , parameters :[String : String ] ,  position :Int)  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                Global.stopIndicator()
            }
            else
            {
                print("my Error\(response.result.error!)")
            }
        }
    }
}
