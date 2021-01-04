//
//  TransactionsViewController.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 1/2/21.
//

import UIKit

class TransactionsViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    var fromDate: String?
    var toDate: String?
    var transactionsData: [TransactionData]?
    let transacitonsCellReuseIdentifier = "RecentTransactionsCell"
    
    @IBOutlet weak var transactionsTable: UITableView!
    var transactionsManager = TransactionsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransactionsViewController")
        transactionsTable.delegate = self
        transactionsTable.dataSource = self
        transactionsManager.delegate = self
        
        transactionsTable.register(UINib(nibName: "RecentTransactionsCell", bundle: nil), forCellReuseIdentifier: transacitonsCellReuseIdentifier)
        // Do any additional setup after loading the view.
        
        toDate = DateUtils.currentDate
        fromDate = DateUtils.currentMinusThirty
    }
    
    func loadTransactions() {
        transactionsManager.fetchTransactions(fromDate: fromDate!, toDate: toDate!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTransactions()
    }

    @IBAction func openFilterModal(_ sender: Any) {
        self.performSegue(withIdentifier: "filterSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "filterSegue" {
            let modalVC = segue.destination as! TransactionsFilterViewController
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            modalVC.fromDate = formatter.date(from: fromDate!)
            modalVC.toDate = formatter.date(from: toDate!)
            modalVC.presentationController?.delegate = self
            modalVC.delegate = self
        }
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.loadTransactions()
    }
}

extension TransactionsViewController: TransactionsManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateTransactions(_ transactionsManager: TransactionsManager, transactions: TransactionsList) {
        var transactionsCopy = transactions.transactions
        transactionsCopy.reverse()
        self.transactionsData = transactionsCopy
        DispatchQueue.main.async {
            self.transactionsTable.reloadData()
        }
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionsData?.count ?? 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: fix this to use an account model that will take care of currecy formatting
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
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
