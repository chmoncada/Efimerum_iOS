//
//  TagsCell.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 05/03/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class TagsCell: UITableViewCell {

    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var frameView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.frameView.layer.cornerRadius = self.frameView.bounds.size.height / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
