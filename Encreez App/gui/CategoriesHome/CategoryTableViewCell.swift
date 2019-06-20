//
//  CategoryTableViewCell.swift
//  Encreez App
//
//  Created by Razy Tech on 2/3/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageLbl: UIImageView!
    
    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var countLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
          
       imageLbl.layer.cornerRadius = 0.5 * imageLbl.bounds.size.width;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
