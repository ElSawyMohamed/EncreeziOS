//
//  ScanQRViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 3/10/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class ScanQRViewController: UIViewController  {
    
    var rewardsDetail : Rewards?
    
    var retailerImage : String = ""
    
    var  flagBranch : Bool?
    
    @IBOutlet weak var scanImage: UIImageView!
    
    @IBOutlet weak var redName: UILabel!
    
    @IBOutlet weak var redDes: UILabel!
    
    @IBOutlet weak var scanBtnOutlet: UIButton!
    
    @IBOutlet weak var scanView: UIView!
    
    @IBOutlet weak var cancel: UIButton!
    
    var imageStr : String = "qrcode"
    
    @IBAction func scanBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ScanQR", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cancel.semanticContentAttribute = .forceLeftToRight
        
        // Do any additional setup after loading the view.
        
        scanBtnOutlet.setImage(UIImage(named: imageStr), for: .normal)
        scanView.layer.borderColor = UIColor.gray.cgColor
        scanView.layer.borderWidth = 0.7
        scanView.layer.cornerRadius = 17
        
   
        redName.text = rewardsDetail?.Name
        redDes.text = rewardsDetail?.Description
        
        let url = URL(string: (self.rewardsDetail?.Image)!)
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
