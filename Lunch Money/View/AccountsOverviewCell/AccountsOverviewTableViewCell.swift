//
//  AccountsOverviewTableViewCell.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/31/20.
//

import UIKit

class AccountsOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var accountCell: UIView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountBalance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
