//
//  TransactionsFilterViewController.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 1/2/21.
//

import UIKit

class TransactionsFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var delegate: TransactionsViewController?
    var fromDate: Date?
    var toDate: Date?
    var categoryFilter = ""
    var categoriesData: [CategoryData]?
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var categorySelector: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fromDatePicker.date = fromDate!
        toDatePicker.date = toDate!
        categorySelector.dataSource = self
        categorySelector.delegate = self
        if let categorySelected = categoriesData?.firstIndex(where: {$0.id == Int(categoryFilter)}) {
            categorySelector.selectRow(categorySelected, inComponent: 0, animated: true)
        }
    }

    @IBAction func fromDateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = K.commonDateFormat
        fromDate = sender.date
        delegate?.fromDate = formatter.string(from: sender.date)
    }
    @IBAction func toDateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = K.commonDateFormat
        toDate = sender.date
        delegate?.toDate = formatter.string(from: sender.date)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesData!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesData![row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let id = categoriesData![row].id!
        if id == -1 {
            delegate?.categoryFilter = ""
        } else {
            delegate?.categoryFilter = String(id)
        }
        
    }
}
