//
//  FishCell.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 12/1/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import UIKit

class FishCell: UITableViewCell {

    @IBOutlet weak var fishName: UILabel!
    @IBOutlet weak var fishType: UILabel!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var fishImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
