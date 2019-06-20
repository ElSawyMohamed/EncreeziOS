//
//  SelectLangController.swift
//  Encreez App
//
//  Created by Razy Tech on 1/8/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SelectLangController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource  {
    
    

    var key : String?
    
    var langArray : [WebLang]  = []
    
    var Lang_url = "\(Global.baseUrl)/api/Customer/GetLanguages"
    
    var lang = UserDefaults.standard.string(forKey: "Lang")
    
    var   titlestr:String = "" ,messagestr:String = "" ,okstr:String = "",langua = "" ,nonetwork = "",
    alerttitle = "" , alertMessage = "" , actionone = "" , actiontwo = ""
    
    var   selected = false
    
    @IBOutlet weak var selecImag: UIImageView!
    
    @IBOutlet weak var viewselect: UIView!
    
    @IBOutlet weak var txt_language: UILabel!
    
    @IBOutlet weak var picker_view: UIPickerView!
    
    @IBOutlet weak var conBtn: UIView!
    
    @IBOutlet weak var conBTN: UIButton!
    
    @IBOutlet weak var choosLang: UIButton!
    
    @IBOutlet weak var sceLbl: UILabel!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return langArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
       let rowstr  = langArray[row].value
       
        return rowstr
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
       selected = true
       txt_language.text =  langArray[row].value
       self.key = langArray[row].key
       UserDefaults.standard.set(self.key , forKey: "Lang")
        
   
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.selecImag.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        
        if self.lang == "ar"{
            
            titlestr = "تنبيه"
            messagestr  = "خطأ في تحميل البيانات "
            nonetwork  = "لا يوجد اتصال بالشبكه"
            okstr = "موافق"
            alerttitle = "تغير اللغة"
            alertMessage = "تغير اللغة يتطلب إغلاق  التطبيق وإعادة فتحه مرة أخرى . هل أنت متأكد أنك تريد أن تفعل ذلك ؟"
            actionone = "نعم"
            actiontwo = "لا"
        }
        else
        {
            titlestr = "Alert"
            messagestr  = "Server error occured, please try again later"
            nonetwork  = "no Network Available"
            okstr = "OK"
            alerttitle = "Change Language"
            alertMessage = "Changing language requires closing the app and re-opening it again . Are you sure you want to do that ?"
            actionone = "Yes"
            actiontwo = "No"
        }

        self.conBtn.layer.cornerRadius = 17
        self.conBtn.clipsToBounds = true
        
        self.conBTN.layer.cornerRadius = 17
        self.conBTN.clipsToBounds = true


        // Do any additional setup after loading the view.

        viewselect.layer.borderWidth = 1
        
        viewselect.layer.borderColor = UIColor.gray.cgColor
        
        

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let dis = segue.destination as? WelcomeViewController {
            dis.SelectedItem = self.txt_language.text
        }
      }
        
 
    @IBAction func btn_con(_ sender: Any) {
        
        if (self.key == "ar"){
            
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        } else
        {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
       
        if selected {
            
              self.showMessageResetApp()
              performSegue(withIdentifier: "welcomesegue", sender: self.txt_language.text)
        }
        else {
    
            if self.lang == "ar"
            {
                show_dialoug(title: "تحذير", message: "برجاء تحديد اللغة", action: "تم")
            }
            else
            {
                 show_dialoug(title: "Warning", message: "You should choose language", action: "OK")
            }
        }
        
        
        }
  
    @IBAction func btn_chooise(_ sender: Any) {
       
        Global.loadIndicator(view: view)

        getLanguage()
        
        picker_view.isHidden =  false
    }
    
    func  show_dialoug(title:String , message:String ,action :String )  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getLanguage()
    {
        
        Alamofire.request(Lang_url, method: .post ).responseJSON {
            response in
           if response.result.isSuccess
            {
                Global.stopIndicator()
                let langData : JSON = JSON(response.result.value!)
                let data = langData["data"].arrayValue
                self.langArray = []
                for lang in data
                {
                    self.langArray.append(WebLang(json: lang))
                }
                self.picker_view.reloadAllComponents()
                self.txt_language.text =  self.langArray[0].value
                self.key = self.langArray[0].key
                UserDefaults.standard.set(self.key , forKey: "Lang")
                self.selected = true
           }
            else
            {
              print("my Error\(response.result.error!)")
            }
        }
    }
    
    func showMessageResetApp(){
        let exitAppAlert = UIAlertController(title: alerttitle ,
                                             message: alertMessage ,
                                             preferredStyle: .alert)
        
        let resetApp = UIAlertAction(title: actionone , style: .destructive) {
            (alert) -> Void in
            // home button pressed programmatically - to thorw app to background
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // terminaing app in background
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                exit(EXIT_SUCCESS)
                
                })
        }
        
        let laterAction = UIAlertAction(title: actiontwo , style: .cancel) {
            (alert) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        exitAppAlert.addAction(resetApp)
        exitAppAlert.addAction(laterAction)
        present(exitAppAlert, animated: true, completion: nil)
        
    }
}
