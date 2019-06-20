//
//  CategoriesViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/3/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class CategoriesViewController: UIViewController , UITableViewDataSource,UITableViewDelegate  {
    
    
    @IBOutlet weak var emptView: UILabel!
    
    
    @IBOutlet weak var allCat: UIImageView!
    
    @IBOutlet weak var CatTableView: UITableView!
    
    var catogriesData : [Categories] = []
    
    var catURl = "\(Global.baseUrl)/api/customer/GetCategories"
    
    var catLang = UserDefaults.standard.string(forKey: "Lang")
    
    var index:IndexPath?

    var categoryId : String = ""
    
    var categoryName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.loadIndicator(view: view)
        // Do any additional setup after loading the view.
      self.allCat.layer.cornerRadius = 0.5 * allCat.bounds.size.width;
    
    
        let lat = UserDefaults.standard.string(forKey: "Lat")
        
        let long = UserDefaults.standard.string(forKey: "Long")
        
        let params : [String : String ] = ["Lang": catLang! , "Lat" : lat! , "Long" : long! ]
        
        getCategories(url: catURl, parameters: params)
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnExit(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   

    func getCategories(url : String , parameters :[String : String ])
    {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
               
                let dataJSON = JSON(response.result.value!)
                 self.catogriesData = []
                let data = dataJSON["data"].arrayValue
 
                for i in data
                {
                  self.catogriesData.append(Categories(json: i))
                  self.CatTableView.separatorStyle = UITableViewCellSeparatorStyle.none
                 
                    Global.stopIndicator()
                }
                
                if self.catogriesData.count == 0
                {
                    self.CatTableView.separatorStyle = UITableViewCellSeparatorStyle.none
                    self.CatTableView.backgroundView = self.emptView
                }
                self.CatTableView.reloadData()
            }
            else
            {
                if self.catLang == "ar"
                {
                    let alert = UIAlertController(title: "تحذير", message: "حاول مرة اخري", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                   
                }
                else
                { let alert = UIAlertController(title: "Warning", message: "Please Try again Later", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }

        }
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CategoryTableViewCell
    
        cell.NameLbl.text = catogriesData[indexPath.row].CategoryName
        cell.countLbl.text = "\(catogriesData[indexPath.row].Count!)"
        cell.imageLbl.layer.cornerRadius = 0.5 * cell.imageLbl.bounds.size.width
        let url = URL(string: catogriesData[indexPath.row].Image!)
         if url != nil {
        
        cell.imageLbl.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        
         }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.categoryId = catogriesData[indexPath.row].CategoryId!
        
        self.categoryName = catogriesData[indexPath.row].CategoryName!
        
        performSegue(withIdentifier: "showMap", sender: self)
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catogriesData.count
    }
//
//    @objc func tapReconizer(tapRec : UITapGestureRecognizer)  {
//        view.endEditing(true)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dis = segue.destination  as? FindMapViewController {
            
            dis.categoryNameLbl = self.categoryName
            dis.categoryId = self.categoryId

           
        }
    }

}
