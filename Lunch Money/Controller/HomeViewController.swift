//
//  HomeViewController.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/30/20.
//

import UIKit
import Charts

class HomeViewController: UIViewController {
    
    var categoriesManager = CategoriesManager()
    var transactionsManager = TransactionsManager()
    var accountsManager = AccountsManager()
    var accountsData: AccountsList?
    var transactionsData: TransactionsModel?
    var categoriesData: CategoryListModel?
    @IBOutlet weak var expensesVsIncome: ExpensesVsIncome!
    let cellReuseIdentifier = "AccountsOverviewTableViewCell"
    let transacitonsCellReuseIdentifier = "RecentTransactionsCell"
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountsManager.delegate = self
        transactionsManager.delegate = self
        categoriesManager.delegate = self
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        monthLabel.text = "\(nameOfMonth) Overview"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountsManager.fetchAccounts()
        transactionsManager.fetchTransactions()
        categoriesManager.fetchCategories()
    }
    
    func calcIncomeVsExpensesData() {
        let expensesIncomeTotals = self.transactionsData?.getIncomeVsExpenses(categories: self.categoriesData!)
        if expensesIncomeTotals != nil {
            expensesVsIncome.setIncomeExpenses(income: expensesIncomeTotals?[0] ?? 0, expenses: expensesIncomeTotals?[1] ?? 0)
        }
    }
    
}

extension HomeViewController: CategoriesManagerDelegate {
    
    func didUpdateCategories(_ categoriesManager: CategoriesManager, categories: CategoryListModel) {
        self.categoriesData = categories
        DispatchQueue.main.async {
            self.calcIncomeVsExpensesData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension HomeViewController: AccountsManagerDelegate {
    
    func didUpdateAccounts(_ accountsManager: AccountsManager, accounts: AccountsList) {
        self.accountsData = accounts
        DispatchQueue.main.async {
            // self.accountsTable.reloadData()
        }
    }
}

extension HomeViewController: TransactionsManagerDelegate {
    
    func didUpdateTransactions(_ transactionsManager: TransactionsManager, transactions: TransactionsModel) {
        self.transactionsData = transactions
        DispatchQueue.main.async {
            self.calcIncomeVsExpensesData()
        }
    }
}
