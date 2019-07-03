//
//  RegisterViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 1/9/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import SDWebImage

class RegisterViewController: UIViewController , GIDSignInDelegate , GIDSignInUIDelegate {
    
    var dict : [String : AnyObject]!

    var registerURL = "\(Global.baseUrl)/api/Account/SignUp"
    
    var langRig = UserDefaults.standard.string(forKey: "Lang")
    
    let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var phoneTxt: UITextField!
    
    @IBOutlet weak var txt_date: UITextField!
    
    @IBOutlet weak var passTxt: UITextField!
    
    @IBOutlet weak var confPassTxt: UITextField!
    
    @IBOutlet weak var genId: UISegmentedControl!
    
    @IBOutlet weak var faceBtn:  UIButton!
    
    @IBOutlet weak var faceView: UIView!
    
    @IBOutlet weak var gmailBtn:  UIButton!
    
    @IBOutlet weak var gmailView: UIView!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    var male : String = ""
    
    var female : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.langRig == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.backBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        
        
        if self.langRig == "ar"
        {
            self.male  = "ذكر"
            self.female = "انثي"
          
        }
         else
        {
            self.male  = "Male"
            self.female = "Female"
           
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        self.faceBtn.layer.cornerRadius = 17
        self.faceBtn.clipsToBounds = true

        self.gmailBtn.layer.cornerRadius = 17
        self.gmailBtn.clipsToBounds = true
        
        self.faceView.layer.cornerRadius = 17
        self.faceView.clipsToBounds = true
        
        self.gmailView.layer.cornerRadius = 17
        self.gmailView.clipsToBounds = true

        self.signUpBtn.layer.cornerRadius = 17
        self.signUpBtn.clipsToBounds = true
        self.signUpBtn.layer.borderWidth = 1
        self.signUpBtn.layer.borderColor = Global.anyColor().cgColor
        
        // tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapReconizer(tapRec:)))
        view.addGestureRecognizer(tapGesture)
        

        // Do any additional setup after loading the view.
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate=Date()
        let components: NSDateComponents = NSDateComponents()
        components.year = -100
        datePickerView.minimumDate=datePickerView.calendar.date(byAdding: components as DateComponents, to: Date())
        txt_date.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(dataPickerValueChanged(sender : )), for: UIControlEvents.valueChanged)
        
            }
   func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                  withError error: Error!) {
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                
                let fullName = user.profile.name
                let email = user.profile.email
      
                nameTxt.text = fullName
                emailTxt.text = email
            }
        }
    
    @IBAction func btn_back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_face(_ sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        
        loginManager.logIn(withReadPermissions: ["public_profile","email"] , from: self) { (loginResult , error ) in
            
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender,picture"], tokenString: FBSDKAccessToken.current()?.tokenString , version: nil, httpMethod: "GET")
            
            req?.start(completionHandler: { (connection , result , error) in
                if(error == nil)
                {
                    if let data = result as? NSDictionary
                    {
                        if let name  = data.object(forKey: "name") as? String
                        {
                            self.nameTxt.text = name
                        }
                        if let email = data.object(forKey: "email") as? String
                        {
                            self.emailTxt.text = email
                        }
                        else
                        {
                            // If user have signup with mobile number you are not able to get their email address
                            print("We are unable to access Facebook account details, please use other sign in methods.")
                        }
                    }
                  
                }
                else
                {
                    print("error \(String(describing: error))")
                }
            })
            
        }
        
       
    }
    @IBAction func btn_gmail(_ sender: UIButton) {

      GIDSignIn.sharedInstance().signIn()
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    @IBAction func btn_signup(_ sender: UIButton) {
        
     //  let genderId = Int(genId.selectedSegmentIndex)+1
     // new Changes
        
        
        
      
        if(nameTxt.text?.isEmpty)!{
            if self.langRig == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "لم يتم ادخال اسم المستخدم", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
           
            }
            else
            {
                let alert = UIAlertController(title: "Warning", message: "Your Name is Empty", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
            
         else if (emailTxt.text?.isEmpty)! {
            
            if self.langRig == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "لم يتم ادخال البريدالإلكتروني", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
          
            }
            else
            {
              
                let alert = UIAlertController(title: "Warning", message: "Your Email is Empty", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
            }
         }
        else if !(isValidEmail(testStr: emailTxt.text!)) {
            
            if self.langRig == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "البريدالإلكتروني غير صحيح", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
               
            }
            else
            {
            
                
                let alert = UIAlertController(title: "Warning", message: "Your Email is Invalid", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
         else if (phoneTxt.text?.isEmpty)! {
            
            if self.langRig == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "لم يتم ادخال رقم الهاتف", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
                
            }
            else
            {
                let alert = UIAlertController(title: "Warning", message: "Your Phone is Empty", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
            }
         }
//         else if (txt_date.text?.isEmpty)! {
//
//            let alert = UIAlertController(title: "Error", message: "Your birth date is Empty", preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            Global.FixIpadActionsheet(alert: alert, controller: self)
//            self.present(alert, animated: true, completion: nil)
//         }
         else if ((isPwdLenth(password: passTxt.text!)) == false) {
            
            if self.langRig == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "كلمة المرور لا تقل عن 6 رموز", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
          
            }
            else
            {
                let alert = UIAlertController(title: "Warning", message: "Password Shouldn't be less than 6 symbols", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
         else if ((isPasswordSame(password: passTxt.text!, confirmPassword: confPassTxt.text!)) == false ) {
            
            if self.langRig == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "كلمة المرور ليست مثل تأكيد كلمة المرور ", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                let alert = UIAlertController(title: "Warning", message: "Password don't match Confirm Password", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
               
            }
         }
            
        else {
            var dateText =  ""
            if (txt_date.text?.isEmpty)! {
               dateText =  ""
            }else {
                 dateText = txt_date.text!
            }
            
            Global.loadIndicator(view: view)
            if (self.deviceToken == nil )
            {
                registerFunc(url: registerURL , parameters: ["Name" : nameTxt.text! , "Email" : emailTxt.text! , "Phone" : phoneTxt.text! , "BirthDate" : dateText , "Password" : passTxt.text! , "Gender" : "" , "Lang" : langRig!])
                
            }
            else
            {
            registerFunc(url: registerURL , parameters: ["Name" : nameTxt.text! , "Email" : emailTxt.text! , "Phone" : phoneTxt.text! , "BirthDate" : dateText , "Password" : passTxt.text! , "Gender" : ""  , "DeviceToken" : self.deviceToken! , "Lang" : langRig!])
         }
            
            
        }
       
    }
    
    func registerFunc(url : String , parameters : [String : String]) {
        
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                let dataJSON = JSON(response.result.value!)
                 let logMess = dataJSON["Message"].string
                let logstat = dataJSON["Status"].bool
                 let ID = dataJSON["data"]["User"]["Id"].string
                let name = dataJSON["data"]["User"]["Name"].string
                 let email = dataJSON["data"]["User"]["Email"].string
                let phone = dataJSON["data"]["User"]["Mobile"].string
                 let birthDate = dataJSON["data"]["User"]["BirthDate"].string
                let countryId = dataJSON["data"]["User"]["CountryId"].string
                let Image = dataJSON["data"]["User"]["Image"].string
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
                UserDefaults.standard.set(ID, forKey: "Id")
                UserDefaults.standard.set(birthDate, forKey: "BirthDate")
                UserDefaults.standard.set(countryId, forKey: "CountryId")
                UserDefaults.standard.set(email, forKey: "Email")
                UserDefaults.standard.set(phone, forKey: "Mobile")
                UserDefaults.standard.set(token, forKey: "Token")
                UserDefaults.standard.set(Image , forKey: "Image")
    
                
                if logstat == true
                {
                     UserDefaults.standard.set(true, forKey: "Logedin")
                    self.performSegue(withIdentifier: "viewFind", sender: self)
                }
                else
                {
                    if self.langRig == "ar"
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
                print("The app is not Working\(response.result.error!)")
            }
  
        }
    }

    @objc func tapReconizer(tapRec : UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    @objc func dataPickerValueChanged(sender : UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        txt_date.text="\(selectedDate)"
    }
       func isValidEmail(testStr:String) -> Bool
       {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailTest.evaluate(with: testStr)
       }

    func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    func isPwdLenth(password: String) -> Bool {
        if ( password.count >= 6 && password.count <= 15 ) {
            return true
        }
        else {
            return false
        }
    }
}
