//
//  ItemTableViewCell.swift
//  Makestagram
//
//  Created by Aaron Brown on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var isCompostableLabel: UILabel!
    
    var item:Item? {
        didSet {
            // 1
            if let item = item {
                //2
                // bind the image of the post to the 'itemImage' view
                item.image ->> itemImageView
                //itemLabel = item.nameLabel
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
