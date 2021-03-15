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
    var transactionsData: TransactionsModel?
    var categoriesData: CategoryListModel?
    var categoryFilter = ""
    let transacitonsCellReuseIdentifier = "RecentTransactionsCell"
    
    @IBOutlet weak var transactionsTable: UITableView!
    var categoriesManager = CategoriesManager()
    var transactionsManager = TransactionsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionsTable.delegate = self
        transactionsTable.dataSource = self
        transactionsManager.delegate = self
        categoriesManager.delegate = self
        
        transactionsTable.register(UINib(nibName: "RecentTransactionsCell", bundle: nil), forCellReuseIdentifier: transacitonsCellReuseIdentifier)
        // Do any additional setup after loading the view.
        
        toDate = DateUtils.currentDate
        fromDate = DateUtils.currentMinusThirty
    }
    
    func loadTransactions() {
        transactionsManager.fetchTransactions(fromDate: fromDate!, toDate: toDate!, category: categoryFilter)
        categoriesManager.fetchCategories()
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
            formatter.dateFormat = K.commonDateFormat
            
            modalVC.fromDate = formatter.date(from: fromDate!)
            modalVC.toDate = formatter.date(from: toDate!)
            modalVC.categoryFilter = categoryFilter

            modalVC.categoriesData = createEmptyCategory()
            modalVC.presentationController?.delegate = self
            modalVC.delegate = self
        }
    }
    func createEmptyCategory() -> [CategoryData] {
        let decoder = JSONDecoder()
        do {
            var categoriesCopy = categoriesData?.categoriesList
            let dummyData = """
                {
                    "name": "None",
                    "id": -1,
                    "is_income":false,
                    "exclude_from_budget":false,
                    "exclude_from_totals":false,
                    "is_group":false
                }
            """.data(using: .utf8)!
            let emptyCategory = try decoder.decode(CategoryData.self, from: dummyData)
            categoriesCopy?.insert(emptyCategory, at: 0)
            return categoriesCopy!
            
        } catch {
            print("Failed to create empty category")
            return []
        }
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.loadTransactions()
    }
}

extension TransactionsViewController: CategoriesManagerDelegate {
    
    func didUpdateCategories(_ categoriesManager: CategoriesManager, categories: CategoryListModel) {
        self.categoriesData = categories
        DispatchQueue.main.async {
            self.transactionsTable.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension TransactionsViewController: TransactionsManagerDelegate {
    func didUpdateTransactions(_ transactionsManager: TransactionsManager, transactions: TransactionsModel) {
        self.transactionsData = transactions
        print(transactions.categorySpend)
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
        let transaction = self.transactionsData?.getAt(index: indexPath.row, reversed: true)
        let payee = transaction?.payee ?? ""
        let date = transaction?.date ?? ""
        let amount = transaction?.amount ?? ""
        
        let transactionCategory = categoriesData?.getCategoryNameFromId(id: transaction?.category_id ?? -1)

        if amount.contains("-") {
            cell.priceLabel!.textColor = .systemGreen
        } else {
            cell.priceLabel!.textColor = .white
        }
        
        cell.category!.text = transactionCategory
        cell.payee!.text = payee
        cell.dateLabel!.text = date
        cell.priceLabel.text = currencyFormatter.string(from: NSNumber(value: Float(amount)!))
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = UIColor(displayP3Red: 251.0/255, green: 184.0/255, blue: 0, alpha: 1)
        return cell
    }
}
