//
//  ChangePasswordViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/6/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {
    
    let url : String = "\(Global.baseUrl)/api/Account/ResetPassword"
    
    let Id  =  UserDefaults.standard.string(forKey: "Id")
    
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    
    @IBOutlet weak var changePassBtn: UIButton!


    @IBOutlet weak var oldPass: UITextField!
    
    @IBOutlet weak var backBtnCh: UIButton!
    
    @IBOutlet weak var newPass: UITextField!

    @IBOutlet weak var confPass: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.Lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.backBtnCh.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        
        backBtnCh.semanticContentAttribute = .forceLeftToRight
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapReconizer(tapRec:)))
        view.addGestureRecognizer(tapGesture)
        
        self.changePassBtn.layer.cornerRadius = 17
        self.changePassBtn.clipsToBounds = true

        
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
    
    @IBAction func changPassBtn(_ sender: Any) {
        
    Global.loadIndicator(view: view)
      
        if (oldPass.text?.isEmpty)!
        {
            if self.Lang == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "لم يتم ادخال كلمة المرور السابقة", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Warning", message: "Old Password is Empty", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
                
               
            }
            
        }
        else if (confPass.text?.isEmpty)!
        {
            if self.Lang == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message:"لم يتم ادخال تاكيد كلمة المرور", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                
                let alert = UIAlertController(title: "Warning", message: "Confirm Password is Empty", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
               
            }
            
        }
       else if (newPass.text?.isEmpty)!
        {
            if self.Lang == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message:"لم يتم ادخال كلمة المرور الجديدة", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Warning", message: "New Password is Empty" , preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                self.present(alert, animated: true, completion: nil)
              
            }
            
        }
        else if ((isPwdLenth(password: newPass.text!, confirmPassword: confPass.text!)) == false) {
            
            if self.Lang == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message:"كلمة المرور لا تقل عن 6 رموز", preferredStyle: .actionSheet)
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
            else if !(isPasswordSame(password: newPass.text!, confirmPassword: confPass.text!))
        {

            if self.Lang == "ar"
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
        else
        {
            let params : [String : String] = ["Id" : self.Id! , "OldPassword" : oldPass.text! , "Password" : newPass.text! ]
            changePassword(url: url , parameters: params)
        }
    }
    func changePassword (url : String , parameters :[String : String ])  {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                Global.stopIndicator()
                if self.Lang == "ar"
                {
                    let alert = UIAlertController(title: "تم", message: "تم تغيير كلمة السر بنجاح", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.dismissView ))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Suceess", message: "Password changed successfully", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.dismissView ))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                if self.Lang == "ar"
                {
                    let alert = UIAlertController(title: "تحذير", message: "حاول مرة اخري", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil ))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                
                    
                    let alert = UIAlertController(title: "Warning", message: "Please Try again Later", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil ))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    func isPwdLenth(password: String , confirmPassword : String) -> Bool {
        
        if password.characters.count <= 7 && confirmPassword.characters.count <= 7{
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func backBtnPass(_ sender: Any) {
  dismiss(animated: true , completion: nil )
    }
    
    @objc func tapReconizer(tapRec : UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    
    func dismissView(alert : UIAlertAction )  {
        dismiss(animated: true, completion: nil)
    }
}
