//
//  ActivitiesViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/26/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ActivitiesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

   @IBOutlet weak var activTable: UITableView!
    
    @IBOutlet var emptyTable: UIView!
    
    @IBOutlet weak var emptLbl: UILabel!
    
    var activRetail1: String = ""
    
    var height = 120
    
    let userID = UserDefaults.standard.string(forKey: "Id")
    
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    
    let urlActiv : String = "\(Global.baseUrl)/api/Transaction/ConsumerActivities"
    
    var activityData : [Activities] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let params : [String : String ] = ["RetailerId" : self.activRetail1 , "CustomerId" : self.userID! , "Lang" : self.Lang! ]
        
        getActivity(url: urlActiv , parameters: params)
        
        // Do any additional setup after loading the view.
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
    
//
    func  getActivity(url : String , parameters : [String : String])
    {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                let dataJSON = JSON(response.result.value!)
                self.activityData = []
                let data = dataJSON["data"].arrayValue
              
                for i in data
                {
                    self.activityData.append(Activities(json: i))

                    Global.stopIndicator()
                }
                
                if self.activityData.count == 0
                {
                     self.activTable.separatorStyle = UITableViewCellSeparatorStyle.none
                    self.activTable.backgroundView = self.emptyTable
                }
               
                self.activTable.reloadData()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityViewTableViewCell

        cell.activName.text = activityData[indexPath.row].Name
        cell.activDes.text = activityData[indexPath.row].TransactionDate
        cell.activType.text = activityData[indexPath.row].TransactionType
        cell.activImg.layer.cornerRadius = 0.5 * cell.activImg.bounds.size.width
        let url = URL(string: activityData[indexPath.row].Image!)
        if url != nil {
            cell.activImg.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
     return activityData.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(height)
    }
    
}
