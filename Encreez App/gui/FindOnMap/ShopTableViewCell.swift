//
//  ShopTableViewCell.swift
//  Encreez App
//
//  Created by Razy Tech on 3/26/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageShop : UIImageView!
    

    @IBOutlet weak var nameLbl: UILabel!
    
    
    @IBOutlet weak var avOffers: UILabel!
    
    
    @IBOutlet weak var favBtn: UIButton!
    
    override func awakeFromNib()
    
    {
        super.awakeFromNib()
        // Initialization code
        
         imageShop.layer.cornerRadius = 0.5 * imageShop.bounds.size.width;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
