//
//  TransactionsFilterViewController.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 1/2/21.
//

import UIKit

class TransactionsFilterViewController: UIViewController {

    var delegate: TransactionsViewController?
    var fromDate: Date?
    var toDate: Date?
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fromDatePicker.date = fromDate!
        toDatePicker.date = toDate!
    }

    @IBAction func fromDateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        fromDate = sender.date
        delegate?.fromDate = formatter.string(from: sender.date)
    }
    @IBAction func toDateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        toDate = sender.date
        delegate?.toDate = formatter.string(from: sender.date)
    }
}
