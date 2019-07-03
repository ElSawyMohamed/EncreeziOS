//
//  ForgetPasswordController.swift
//  Encreez App
//
//  Created by Razy Tech on 1/9/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPasswordController: UIViewController {
    
    let forgUrl : String = "\(Global.baseUrl)/api/Account/ForgetPassword"
   
    var langRig = UserDefaults.standard.string(forKey: "Lang")
    
    @IBOutlet weak var forPassBtn: UIButton!
    
    @IBOutlet weak var emailForget: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.langRig == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.backBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapReconizer(tapRec:)))
        view.addGestureRecognizer(tapGesture)
        
        self.forPassBtn.layer.cornerRadius = 17
        self.forPassBtn.clipsToBounds = true
        self.forPassBtn.layer.borderWidth = 1
        self.forPassBtn.layer.borderColor = Global.anyColor().cgColor
        
        // Do any additional setup after loading the view.
    }

    @IBAction func resetBtn(_ sender: Any) {
        
        Global.loadIndicator(view: view)
        
        if emailForget.text?.isEmpty == true
        {
         
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
        
      else if !isValidEmail(testStr: emailForget.text!)  {
            if self.langRig == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "البريدالإلكتروني غير صحيح", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                
                let alert = UIAlertController(title: "Warning", message: "Email is Invalid", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
            }
        
          
        }
        else
        {
         resetPass(url: forgUrl, parameters: ["Email" : emailForget.text!])
         
        }
        
    }

    @IBAction func btn_back(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    
    func resetPass (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON { response in
            if response.result.isSuccess
            {
                Global.stopIndicator()
                let dataJSON = JSON(response.result.value!)
                let forgMess = dataJSON["Message"].string!
                let stat = dataJSON["Status"].bool
                
                if stat == true
                {
                    if self.langRig == "ar"
                    {
                        let alert = UIAlertController(title: "تم", message: forgMess, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.dismissView))
                        Global.FixIpadActionsheet(alert: alert, controller: self)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Done", message: forgMess, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.dismissView))
                        Global.FixIpadActionsheet(alert: alert, controller: self)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                 else
                 {
                if self.langRig == "ar"
                {
                    let alert = UIAlertController(title: "تحذير", message: "البريدالإلكتروني غير صحيح", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                    
                    let alert = UIAlertController(title: "Warning", message: "Email is Invalid", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    self.present(alert, animated: true, completion: nil)
                }

              }
            }
            else
            {
                if self.langRig == "ar"
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
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @objc func tapReconizer(tapRec : UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    func dismissView(alert : UIAlertAction )  {
        dismiss(animated: true, completion: nil)
    }
}
