//
//  OTMTableViewCell.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/3/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMTableViewCell: UITableViewCell {

    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var studentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
