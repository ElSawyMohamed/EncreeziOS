//
//  LoginViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 1/9/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class LoginViewController : UIViewController {
    
    
    var loginUrl  = "\(Global.baseUrl)/api/account/Login"
    
    let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
    
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    
    @IBOutlet weak var signInBtn: UIButton!

    @IBOutlet weak var signUpBtn: UIButton!

    @IBOutlet weak var emailOrPhoneTxt: UITextField!
    
    @IBOutlet weak var passTxt: UITextField!
    
    var male : String = ""
    
    var female : String = ""
    
    @IBAction func btnLogin(_ sender: Any) {
        
         if (emailOrPhoneTxt.text?.isEmpty)!||(passTxt.text?.isEmpty)!
        {
            if self.Lang == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "لم يتم ادخال بيانات صحيحة", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "تم", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                
                self.present(alert, animated: true, completion: nil)
          }
            else
            {
          
                
                let alert = UIAlertController(title: "Warning", message: "Please enter valid Data", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                
                self.present(alert, animated: true, completion: nil)
                
            }
         }
        else
        {
            
            Global.loadIndicator(view: view)
            if (self.deviceToken == nil)
            {
                 loginWithEmailOrPass(url: loginUrl, parameters: ["EmailORPhone" : emailOrPhoneTxt.text! , "password" : passTxt.text! , "Lang" : self.Lang! ])
            }
            else
            {
            loginWithEmailOrPass(url: loginUrl, parameters: ["EmailORPhone" : emailOrPhoneTxt.text! , "password" : passTxt.text! , "DeviceToken" : self.deviceToken! , "Lang" : self.Lang! ])
            }
        }
        
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.Lang == "en"
        {
            self.male  = "ذكر"
            self.female = "انثي"
        }
        else
        {
            
            self.male  = "Male"
            self.female = "Female"
           
        }
        
        
        // Do any additional setup after loading the view.
        
        self.signInBtn.layer.cornerRadius = 17
        self.signInBtn.clipsToBounds = true
        self.signUpBtn.layer.cornerRadius = 17
        self.signUpBtn.clipsToBounds = true
        self.signUpBtn.layer.borderWidth = 1
        self.signUpBtn.layer.borderColor = Global.anyColor().cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapReconizer(tapRec:)))
        view.addGestureRecognizer(tapGesture)
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    
    //Working with Alamofire
    func loginWithEmailOrPass (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                let dataJSON = JSON(response.result.value!)
                let logMess = dataJSON["Message"].string
                let logStat = dataJSON["Status"].bool
                let ID = dataJSON["data"]["User"]["Id"].string
                let name = dataJSON["data"]["User"]["Name"].string
                let email = dataJSON["data"]["User"]["Email"].string
                let phone = dataJSON["data"]["User"]["Mobile"].string
                let birthDate = dataJSON["data"]["User"]["BirthDate"].string
                let Image = dataJSON["data"]["User"]["Image"].string
                let countryId = dataJSON["data"]["User"]["CountryId"].string
                let genderID = dataJSON["data"]["User"]["Gender"].int
                let token = dataJSON["data"]["Token"].string
                
                
                UserDefaults.standard.set(name, forKey: "Name")
                if genderID == 1
                {
                    UserDefaults.standard.set(self.male, forKey: "Gender")
                }
                else
                {
                    UserDefaults.standard.set(self.female, forKey: "Gender")
                }
                UserDefaults.standard.set(ID , forKey: "Id")
                UserDefaults.standard.set(birthDate , forKey: "BirthDate")
                UserDefaults.standard.set(countryId , forKey: "CountryId")
                UserDefaults.standard.set(email, forKey: "Email")
                UserDefaults.standard.set(phone, forKey: "Mobile")
                UserDefaults.standard.set(token, forKey: "Token")
                UserDefaults.standard.set(Image , forKey: "Image")
                UserDefaults.standard.set(genderID , forKey: "GenderType")
                
                if  logStat == true
                {
                    UserDefaults.standard.set(true, forKey: "Logedin")
                    self.performSegue(withIdentifier: "ShowFindMap", sender: self)
                }
                else
                {
                   
                    if self.Lang == "ar"
                    {
                        let alert = UIAlertController(title: "تحذير", message: logMess, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        Global.FixIpadActionsheet(alert: alert, controller: self)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
              
                        let alert = UIAlertController(title: "Warning", message: logMess, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        Global.FixIpadActionsheet(alert: alert, controller: self)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                
                Global.stopIndicator()
            }
            else
            {
              print("my Error\(response.result.error!)")
            }
        }
        
    }
    @objc func tapReconizer(tapRec : UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
