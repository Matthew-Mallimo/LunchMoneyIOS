//
//  ExpensesVsIncome.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 3/13/21.
//

import UIKit
import LinearProgressBar

class ExpensesVsIncome: UIView {
    
    let nibName = "ExpensesVsIncome"
    var contentView: UIView?
    
    var income: Float = 0
    var expenses: Float = 0
    
    @IBOutlet weak var expensesBar: LinearProgressBar!
    @IBOutlet weak var incomeBar: LinearProgressBar!
    @IBOutlet weak var barContainer: UIView!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setIncomeExpenses(income: Float, expenses: Float) {
        let total:Float = abs(income) + abs(expenses)
        let incomePercentage:Int = Int((abs(income) / total) * 100)
        let expensesPercentage:Int = Int((abs(expenses) / total) * 100)
        print(incomePercentage)
        incomeLabel.text = "$\(Int(income))"
        expensesLabel.text = "$\(Int(expenses))"
        expensesBar.progressValue = CGFloat(expensesPercentage)
        incomeBar.progressValue = CGFloat(incomePercentage)
    }
}
