//
//  HomeViewController.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/30/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    var categoriesManager = CategoriesManager()
    var transactionsManager = TransactionsManager()
    var accountsManager = AccountsManager()
    var accountsData: AccountsList?
    var transactionsData: [TransactionData]?
    let cellReuseIdentifier = "AccountsOverviewTableViewCell"
    let transacitonsCellReuseIdentifier = "RecentTransactionsCell"
    

    @IBOutlet weak var accountsTable: UITableView!
    @IBOutlet weak var transactionsTable: UITableView!
    @IBOutlet weak var accountsOverviewView: UIView!
    @IBOutlet weak var recentTransactionsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountsManager.delegate = self
        transactionsManager.delegate = self
        accountsTable.delegate = self
        accountsTable.dataSource = self
        transactionsTable.delegate = self
        transactionsTable.dataSource = self
        transactionsTable.register(UINib(nibName: "RecentTransactionsCell", bundle: nil), forCellReuseIdentifier: transacitonsCellReuseIdentifier)
        accountsTable.register(UINib(nibName: "AccountsOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        accountsOverviewView.layer.cornerRadius = 10
        recentTransactionsView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountsManager.fetchAccounts()
        transactionsManager.fetchTransactions()
    }
}

extension HomeViewController: AccountsManagerDelegate {
    
    func didUpdateAccounts(_ accountsManager: AccountsManager, accounts: AccountsList) {
        self.accountsData = accounts
        DispatchQueue.main.async {
            self.accountsTable.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension HomeViewController: TransactionsManagerDelegate {
    
    func didUpdateTransactions(_ transactionsManager: TransactionsManager, transactions: TransactionsList) {
        var transactionsCopy = transactions.transactions
        transactionsCopy.reverse()
        self.transactionsData = Array(transactionsCopy.prefix(5))
        DispatchQueue.main.async {
            self.transactionsTable.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.accountsTable {
            return self.accountsData?.plaid_accounts.count ?? 0
        } else {
            return self.transactionsData?.count ?? 0
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: fix this to use an account model that will take care of currecy formatting
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        if tableView === self.accountsTable {
            // create a new cell if needed or reuse an old one
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! AccountsOverviewTableViewCell
            
            let accountName = self.accountsData?.plaid_accounts[indexPath.row].name ?? ""
            let accountInstitution = self.accountsData?.plaid_accounts[indexPath.row].institution_name ?? ""
            let accountBalance = currencyFormatter.string(from: NSNumber(value: Float(self.accountsData?.plaid_accounts[indexPath.row].balance ?? "")!))
            cell.accountName?.text = "\(accountInstitution) \(accountName)"
            cell.accountBalance?.text = accountBalance
            return cell
        } else {
            // create a new cell if needed or reuse an old one
            let cell = tableView.dequeueReusableCell(withIdentifier: transacitonsCellReuseIdentifier, for: indexPath) as! RecentTransactionsCell
            let payee = self.transactionsData?[indexPath.row].payee ?? ""
            let date = self.transactionsData?[indexPath.row].date ?? ""
            let amount = self.transactionsData?[indexPath.row].amount ?? ""
            
            
            
            cell.payee!.text = payee
            cell.dateLabel!.text = date
            cell.priceLabel.text = currencyFormatter.string(from: NSNumber(value: Float(amount)!))
            cell.backgroundColor = .darkGray
            cell.textLabel?.textColor = UIColor(displayP3Red: 251.0/255, green: 184.0/255, blue: 0, alpha: 1)
            return cell
        }
    }
}
