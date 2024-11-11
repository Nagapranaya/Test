//
//  TableViewCell.swift
//  Test
//
//  Created by Pranaya on 11/11/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
