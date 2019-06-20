//
//  RewardsViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/26/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class RewardsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var emptyTable: UIView!
    
    @IBOutlet weak var branchTable: UITableView!

    @IBOutlet weak var emptLbl: UILabel!
    
    var height = 120

    let userID = UserDefaults.standard.string(forKey: "Id")

    let Lang = UserDefaults.standard.string(forKey: "Lang")

    var index:IndexPath?

    var rewardsRetail : String = ""
    
    var rewardsData : [Rewards] = []
    
    var rewardsDataRetail : [Rewards] = []

     let urlRewards : String = "\(Global.baseUrl)/api/Transaction/ConsumerRewards"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        
        let params : [String : String ] = ["RetailerId" : self.rewardsRetail , "CustomerId" : self.userID! , "Lang" : self.Lang! ]

        getRewards( url: urlRewards , parameters: params )

     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
    func  getRewards(url : String , parameters : [String : String])
    {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                let dataJSON = JSON(response.result.value!)
                self.rewardsData = []
                let data = dataJSON["data"].arrayValue
                
                for i in data
                {
                    self.rewardsData.append(Rewards(json: i))
                    
                    Global.stopIndicator()
                }
                if self.rewardsData.count == 0
                {
                    self.branchTable.separatorStyle = UITableViewCellSeparatorStyle.none
                    self.branchTable.backgroundView = self.emptyTable
                }
                self.branchTable.reloadData()
            }
            else
            {
                print("my Error\(response.result.error!)")
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCell", for: indexPath) as! RewardsViewControllerCell
    
        cell.giftName.text = rewardsData[indexPath.row].Name
        cell.descCell.text = rewardsData[indexPath.row].Description
        cell.giftType.text = rewardsData[indexPath.row].GiftType
        cell.expirDate.text = rewardsData[indexPath.row].ExpirationDate
        cell.imgCell.layer.cornerRadius = 0.5 * cell.imgCell.bounds.size.width
        let url = URL(string: rewardsData[indexPath.row].Image!)
        if url != nil {

            cell.imgCell.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
          }
        
     
         return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rewardsData.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    performSegue(withIdentifier: "addRedeem", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRedeem"{
            if let indexPath = self.branchTable.indexPathForSelectedRow {
                let controller = segue.destination as! ScanQRViewController
                
                controller.rewardsDetail = rewardsData[indexPath.row]
            }
   }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(height)
    }
}
