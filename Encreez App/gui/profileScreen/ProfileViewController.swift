//
//  ProfileViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/4/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    var Lang = UserDefaults.standard.string(forKey: "Lang")
  
    @IBOutlet weak var imageViewPro: UIImageView!

    @IBOutlet weak var chPassBtn: UIButton!

    @IBOutlet weak var updatInfoAction: UIButton!
    
    @IBOutlet weak var namePro: UILabel!
    
    @IBOutlet weak var emailPro: UILabel!
    
    @IBOutlet weak var proView: UIView!
    
    @IBOutlet weak var phonePro: UILabel!
    
    @IBOutlet weak var datePro: UILabel!
    
    @IBOutlet weak var genderPro: UILabel!
    
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var langBtn: UIButton!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.Lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.back.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        if self.Lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.logoutBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
    
        self.imageViewPro.layer.borderWidth = 1
        self.imageViewPro.layer.borderColor = UIColor(red: 93/255 , green: 188/255 , blue: 210/255 , alpha: 1.0 ).cgColor
        Global.loadIndicator(view: view)
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        
        self.chPassBtn.layer.cornerRadius = 17
        self.chPassBtn.clipsToBounds = true
        
        
        self.proView.layer.cornerRadius = 14
        self.proView.clipsToBounds = true


        self.updatInfoAction.layer.cornerRadius = 17
        self.updatInfoAction.clipsToBounds = true
        self.updatInfoAction.layer.borderWidth = 1
        self.updatInfoAction.layer.borderColor = Global.anyColor().cgColor
        
        self.imageViewPro.layer.cornerRadius = 0.5 * imageViewPro.bounds.size.width;
        
              //   Do any additional setup after loading the view.
        
        
        namePro.text = UserDefaults.standard.string(forKey: "Name")
        emailPro.text = UserDefaults.standard.string(forKey: "Email")
        phonePro.text = UserDefaults.standard.string(forKey: "Mobile")
        datePro.text = UserDefaults.standard.string(forKey: "BirthDate")
        genderPro.text = UserDefaults.standard.string(forKey: "Gender")
        
        
        let urls = URL(string: UserDefaults.standard.string(forKey: "Image")!)
        self.imageViewPro.sd_setImage(with: urls, placeholderImage: UIImage(named: "avatar_profile"))
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        
        Global.stopIndicator()
        
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
    
    func logoutBtnYes(alert : UIAlertAction )  {
        
        UserDefaults.standard.removeObject(forKey: "Id")
        UserDefaults.standard.removeObject(forKey: "BirthDate")
        UserDefaults.standard.removeObject(forKey: "CountryId")
        UserDefaults.standard.removeObject(forKey: "Email")
        UserDefaults.standard.removeObject(forKey: "Mobile")
        UserDefaults.standard.removeObject(forKey: "Token")
        UserDefaults.standard.removeObject(forKey: "Logedin")
        UserDefaults.standard.removeObject(forKey: "Lat")
        UserDefaults.standard.removeObject(forKey: "Long")
        UserDefaults.standard.removeObject(forKey: "deviceToken")
        UserDefaults.standard.removeObject(forKey: "Lat")
        UserDefaults.standard.removeObject(forKey: "Long")
        
        UserDefaults.standard.set(false, forKey: "Logedin")
        
        performSegue(withIdentifier: "Logout", sender: self)
        
    }
    
    @IBAction func backProBtn(_ sender: Any) {
         // dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "ShowMapBack", sender: self)
    }
    @IBAction func logoutBtn(_ sender: Any) {
        
        if self.Lang == "ar"
        {
            let alert = UIAlertController(title: "تسجيل الخروج", message: "تأكيد تسجيل الخروج؟", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "لا", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "نعم", style: UIAlertActionStyle.default, handler: self.logoutBtnYes))
            Global.FixIpadActionsheet(alert: alert, controller: self)
            self.present(alert, animated: true, completion: nil)
     
    }
        else
        {
            let alert = UIAlertController(title: "Logout", message: "Are you sure to logout", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.logoutBtnYes))
            Global.FixIpadActionsheet(alert: alert, controller: self)
            self.present(alert, animated: true, completion: nil)
           
        }
    }

    @IBAction func lang(_ sender: UIButton) {
        
        performSegue(withIdentifier: "selcLangPro", sender: self)
    }
}
