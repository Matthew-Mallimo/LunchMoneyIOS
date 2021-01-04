//
//  RecentTransactionsCell.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 1/1/21.
//

import UIKit

class RecentTransactionsCell: UITableViewCell {

    @IBOutlet weak var payee: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
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
