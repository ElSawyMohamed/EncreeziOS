//
//  NearByViewControllerCell.swift
//  Encreez App
//
//  Created by Razy Tech on 2/14/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class NearByViewControllerCell: UITableViewCell {
    

    
    var flag : Bool = true
 
    let imageFav = UIImage(named: "favorite")
    
    let imageNotFav = UIImage(named: "favorite_restaurant")
    
    
    @IBOutlet weak var nameBranch: UILabel!
    
    @IBOutlet weak var imgBranch: UIImageView!
    
    @IBOutlet weak var distBranch: UILabel!

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var favBtnOut: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if (!flag)
     
        {
            favBtnOut.setImage(self.imageFav , for: .selected)
            
        }
       else
        {
            favBtnOut.setImage(self.imageFav , for: .selected)
            
        }
        
       
        imgBranch.layer.cornerRadius = 0.5 * imgBranch.bounds.size.width;
        cellView.layer.cornerRadius = 13
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
