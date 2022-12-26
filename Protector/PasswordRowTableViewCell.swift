//
//  PasswordRowTableViewCell.swift
//  Protector
//
//  Created by BusranurOK on 14.10.2022.
//

import UIKit

class PasswordRowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewCategoryImage: UIImageView!
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var labelSiteName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
