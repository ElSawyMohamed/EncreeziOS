//
//  SearchViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 3/19/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class SearchViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate {
  
    @IBOutlet weak var backBtn: UIButton!
    
     let searchURL : String = "\(Global.baseUrl)/api/customer/Search"
    
     var index:IndexPath?
    
     var searchData : [SearchData] = []
    
    @IBOutlet weak var bckBtn: UIButton!
    
    
    @IBOutlet weak var searchTable: UITableView!
    
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    let latUser = UserDefaults.standard.string(forKey: "Lat")
    let longUser = UserDefaults.standard.string(forKey: "Long")

    @IBOutlet weak var searchTxt: UISearchBar!
    
     var search : String = ""

    @IBAction func BackToMap(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.Lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.bckBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        
        
        backBtn.semanticContentAttribute = .forceLeftToRight
        
        
        Global.loadIndicator(view: view)

        // Do any additional setup after loading the view.
        
        
        searchTxt.delegate = self
        searchTxt.text = search
        
        let params : [String : String] = ["RetailerName" : self.search , "CategoryID" : "" , "Lang" : self.Lang! , "Lat" : latUser! , "Long" : longUser! ]
        
        searchBarAPI(url: searchURL, parameters: params)
        
        
//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.tapReconizer(tapRec:)))
//                view.addGestureRecognizer(tapGesture)
//
        
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let params : [String : String] = ["RetailerName" : searchTxt.text! , "CategoryID" : "" , "Lang" : self.Lang! , "Lat" : latUser!, "Long" :longUser!]
        
        searchBarAPI(url: searchURL, parameters: params)
        
        Global.loadIndicator(view: view)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func searchBarAPI (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                Global.stopIndicator()
                let dataJSON = JSON(response.result.value!)
                let data = dataJSON["data"].arrayValue
                
                
                for i in data
                {
                    self.searchData.append(SearchData(json: i))
                    
                    Global.stopIndicator()
                }
                self.searchTable.reloadData()
                
            }
            else
            {
               
                if self.Lang == "en"
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
        
       return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        cell.retailerName.text = searchData[indexPath.row].Name
        cell.distance.text = "\(searchData[indexPath.row].Distance!) KM"
        cell.offers.text = searchData[indexPath.row].AvOffers
        cell.imagelbl.layer.cornerRadius = 0.5 * cell.imagelbl.bounds.size.width
        let url = URL(string: searchData[indexPath.row].Image!)
        if url != nil {
            
            cell.imagelbl.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          performSegue(withIdentifier: "ShowRetailer", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.searchTable.indexPathForSelectedRow {
            let controller = segue.destination as! BranchMapViewController
            
            controller.idRetail = searchData[indexPath.row].retailerId!
            controller.idBranch = searchData[indexPath.row].Id!
            
        }
    }
    @objc func tapReconizer(tapRec : UITapGestureRecognizer)  {
        view.endEditing(true)
    }
}
