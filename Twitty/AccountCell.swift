//
//  AccountCell.swift
//  Twitty
//
//  Created by Lia Zadoyan on 10/7/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var accountScreenname: UILabel!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountSelectedCheckmark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
