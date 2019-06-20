//
//  NoRetailerViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 4/22/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit

class NoRetailerViewController: UIViewController {

    
    @IBOutlet weak var noRetailer: UILabel!
    
     var  noRetailers : String?
    
  
    
    @IBAction func backBtnClick(_ sender: UIButton) {
         exit(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.noRetailer.text = noRetailers
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
