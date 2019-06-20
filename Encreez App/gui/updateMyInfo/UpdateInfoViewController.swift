//
//  UpdateInfoViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 2/7/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class UpdateInfoViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    var male : String = ""
    
    var female : String = ""
    
    @IBOutlet weak var backBtnUp: UIBarButtonItem!
    
    @IBOutlet weak var back: UIButton!
    var imageData:Data? = nil
    
    let  imagePicker =  UIImagePickerController()
   
    @IBOutlet weak var txt_date: UITextField!
    
    let url : String = "\(Global.baseUrl)/api/Account/EditProfile"
    
    let Id = UserDefaults.standard.string(forKey: "Id")
    
    var Lang = UserDefaults.standard.string(forKey: "Lang")
    
    var namePro = UserDefaults.standard.string(forKey: "Name")
    
    var emailPro = UserDefaults.standard.string(forKey: "Email")
    
    var mobiPro  = UserDefaults.standard.string(forKey: "Mobile")
    
    var birthPro = UserDefaults.standard.string(forKey: "BirthDate")
    
    var genderPro = UserDefaults.standard.string(forKey: "Gender")
    
    @IBOutlet weak var imageView : UIImageView!
    
    @IBOutlet weak var capIBtn: UIButton!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var phonTxt: UITextField!
    
    @IBOutlet weak var genId: UISegmentedControl!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var   chooseImage :String = "" ,cameratxt :String = "" ,gallerytxt :String = "",canceltxt:String = ""
    
    @IBAction func capImg(_ sender: UIButton) {
        
        self.capIBtn.setTitleColor(UIColor.white, for: .normal)
        self.capIBtn.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: chooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: cameratxt, style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: gallerytxt, style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: canceltxt , style: .destructive , handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageData = UIImageJPEGRepresentation(image_data!, 0.4)
        imageView.image=image_data
        
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func backBtnUpdat(_ sender: UIButton) {
         performSegue(withIdentifier: "ShowProfile", sender: self )
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
        let genderId = Int(genId.selectedSegmentIndex)+1
        
        Global.loadIndicator(view: view)

      if !(isValidEmail(testStr: emailTxt.text!))
        {
            if self.Lang == "ar"
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
    else if (txt_date.text?.isEmpty)! {
        
        if self.Lang == "ar"
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
      else
        {
            Global.loadIndicator(view: view)
                  let params : [String : String] = ["Name" : nameTxt.text! , "Phone" : phonTxt.text! , "Id" : self.Id! , "Email" : emailTxt.text! , "ConsumerImg" : "" , "Lang" : self.Lang! , "Gender" : String(genderId) , "BirthDate" : txt_date.text!]
            requestWith(endUrl: url , imageData: imageData , parameters: params )
          
           
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().clearDisk()
            
        }
    }
    
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
            self.male  = "ذكر"
            self.female = "انثي"
        }
        else
        {
            self.male  = "Male"
            self.female = "Female"
        }
        
        if (UserDefaults.standard.string(forKey: "Lang") == "ar"){
     
            chooseImage = "اختر الملف"
            cameratxt   = "تصوير"
            gallerytxt  = "اختر من الهاتف"
            canceltxt = "إلغاء"
        }
        else
        {
            chooseImage = "Choose Image"
            cameratxt   = "Camera"
            gallerytxt  = "Gallary"
            canceltxt = "Cancel"
            
         
        
        }
        
        imagePicker.delegate = self
    
        nameTxt.text = namePro
        emailTxt.text = emailPro
        phonTxt.text = mobiPro
        txt_date.text = birthPro
        let genderId = genderPro
        
        
        if ( genderId == "Male" || genderId == "ذكر")
        {
            genId.selectedSegmentIndex = 0
            
        }
        else
        {
            genId.selectedSegmentIndex = 1
            
        }
        
        if (txt_date.text?.isEmpty)!
        {
             txt_date.isUserInteractionEnabled = true
            
        }
        else
        {
        
             txt_date.isUserInteractionEnabled = false
        }
        
         let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdateInfoViewController.tapReconizer(tapRec:)))
        
        view.addGestureRecognizer(tapGestureRecognizer)
        self.saveBtn.layer.cornerRadius = 17
        self.saveBtn.clipsToBounds = true
        
        self.imageView.layer.cornerRadius = 0.5 * imageView.bounds.size.width;
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor(red: 93/255 , green: 188/255 , blue: 210/255 , alpha: 1.0 ).cgColor
        
        // Do any additional setup after loading the view.
        
        let urls = URL(string: UserDefaults.standard.string(forKey: "Image")!)
        self.imageView.sd_setImage(with: urls, placeholderImage: UIImage(named: "avatar_profile"))
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate=Date()
        let components: NSDateComponents = NSDateComponents()
        components.year = -100
        datePickerView.minimumDate=datePickerView.calendar.date(byAdding: components as DateComponents, to: Date())
        txt_date.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(dataPickerValueChanged(sender : )), for: UIControlEvents.valueChanged)
    }
    
    @objc func dataPickerValueChanged(sender : UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        txt_date.text="\(selectedDate)"
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let dis = segue.destination as? ProfileViewController
        {
            dis.namePro?.text = UserDefaults.standard.string(forKey: "Name")
            dis.emailPro?.text = UserDefaults.standard.string(forKey: "Email")
            dis.phonePro?.text = UserDefaults.standard.string(forKey: "Mobile")
            dis.genderPro?.text = UserDefaults.standard.string(forKey: "Gender")
            dis.datePro?.text = UserDefaults.standard.string(forKey: "BirthDate")
        }
    }
    
    func backToPro(alert : UIAlertAction )  {
        performSegue(withIdentifier: "ShowProfile", sender: self )
    }
    
    func stopIndicator(alert : UIAlertAction )  {
        Global.stopIndicator()
    }
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

    
    @objc func tapReconizer(tapRec : UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = "\(Global.baseUrl)/api/Account/EditProfile"

        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = self.imageData {
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post ) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
              
                        Global.stopIndicator()
                    
             
                        let dataJSON = JSON(response.result.value!)
                        let logMess = dataJSON["Message"].string
                        let logstat = dataJSON["Status"].bool
                        let ID = dataJSON["data"]["User"]["Id"].string
                        let name = dataJSON["data"]["User"]["Name"].string
                        let email = dataJSON["data"]["User"]["Email"].string
                        let phone = dataJSON["data"]["User"]["Mobile"].string
                        let birthDate = dataJSON["data"]["User"]["BirthDate"].string
                        let countryId = dataJSON["data"]["User"]["CountryId"].string
                        let genderID = dataJSON["data"]["User"]["Gender"].int
                        let image = dataJSON["data"]["User"]["Image"].string
                        let token = dataJSON["data"]["Token"].string
                    
                        if logstat == true
                        {
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
                            UserDefaults.standard.set(image, forKey: "Image")
                            UserDefaults.standard.set(phone, forKey: "Mobile")
                            UserDefaults.standard.set(token, forKey: "Token")
                            
                            if self.Lang == "ar"
                            {
                                let alert = UIAlertController(title: "تم", message: logMess, preferredStyle: .actionSheet)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.backToPro))
                                Global.FixIpadActionsheet(alert: alert, controller: self)
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                let alert = UIAlertController(title: "DONE", message: logMess, preferredStyle: .actionSheet)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.backToPro))
                                Global.FixIpadActionsheet(alert: alert, controller: self)
                                self.present(alert, animated: true, completion: nil)
                               
                            }
                            
                           
                        }
                        else
                        {
                           
                            if self.Lang == "ar"
                            {
                                let alert = UIAlertController(title: "تحذير", message: logMess, preferredStyle: .actionSheet)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.backToPro))
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

                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }

    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            if self.Lang == "ar"
            {
                let alert = UIAlertController(title: "تحذير", message: "ليس لديك كاميرا", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                
                let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                Global.FixIpadActionsheet(alert: alert, controller: self)
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}
