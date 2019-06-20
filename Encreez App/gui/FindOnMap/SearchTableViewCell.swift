//
//  SearchTableViewCell.swift
//  Encreez App
//
//  Created by Razy Tech on 3/19/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagelbl : UIImageView!
    
    
    @IBOutlet weak var retailerName: UILabel!
    
    
    
    
    
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var offers: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imagelbl.layer.cornerRadius = 0.5 * imagelbl.bounds.size.width;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
