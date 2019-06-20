//
//  BranchMapTableViewCell.swift
//  Encreez App
//
//  Created by Razy Tech on 3/4/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit

class RewardsViewControllerCell: UITableViewCell {
    

    @IBOutlet weak var imgCell: UIImageView!
    
    @IBOutlet weak var giftName: UILabel!
    
    @IBOutlet weak var descCell: UILabel!
    
    @IBOutlet weak var giftType: UILabel!
    
    @IBOutlet weak var expirDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        giftName.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        giftName.numberOfLines = 0
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
