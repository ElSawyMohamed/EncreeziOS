//
//  addTranscationViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 5/26/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit

class addTranscationViewController: UIViewController {
    
    
    var retailerImage : String = ""
    
    @IBOutlet weak var scanImage: UIImageView!
    
    @IBOutlet weak var scanBtnOutlet: UIButton!
    
    @IBOutlet weak var scanView: UIView!
    
    var imageStr : String = "qrcode"
    
    @IBAction func scanBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "scanQR", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        scanBtnOutlet.setImage(UIImage(named: imageStr), for: .normal)
        scanView.layer.borderColor = UIColor.gray.cgColor
        scanView.layer.borderWidth = 0.7
        scanView.layer.cornerRadius = 17
        
   
            
            let url = URL(string: (self.retailerImage))
            if url != nil
            {
                self.scanImage.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            }
   
        
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
    
    @IBAction func closeRed(_ sender: UIButton) {
        dismiss(animated: true , completion: nil )
    }
}
