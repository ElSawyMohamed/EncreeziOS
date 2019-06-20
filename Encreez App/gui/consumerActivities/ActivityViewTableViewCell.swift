//
//  ActivityViewTableViewCell.swift
//  Encreez App
//
//  Created by Razy Tech on 3/6/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit

class ActivityViewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var activImg: UIImageView!
    
    @IBOutlet weak var activName: UILabel!
    
    @IBOutlet weak var activDes: UILabel!
    
    @IBOutlet weak var activType: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
