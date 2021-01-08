//
//  CategoriesManager.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/30/20.
//

import Foundation

protocol TransactionsManagerDelegate {
    func didUpdateTransactions(_ transactionsManager: TransactionsManager, transactions: TransactionsList)
    func didFailWithError(error: Error)
}

struct TransactionsManager {
    let transactionsUrl = "https://dev.lunchmoney.app/v1/transactions"
    
    var delegate: TransactionsManagerDelegate?

    func fetchTransactions(fromDate: String = DateUtils.currentMinusThirty, toDate: String = DateUtils.currentDate, category: String = "") {
        var categoryParam = ""
        if category.count > 0 {
            categoryParam = "&category_id=\(category)"
        }
        let urlWithDate = "\(transactionsUrl)?start_date=\(fromDate)&end_date=\(toDate)\(categoryParam)"
        if let url = URL(string: urlWithDate) {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(K.lunchMoneyAccessToken)", forHTTPHeaderField: "Authorization")
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let transactions = self.parseJSON(safeData) {
                        self.delegate?.didUpdateTransactions(self, transactions: transactions)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ transactionsData: Data) -> TransactionsList? {
        let decoder = JSONDecoder()
        do {
//            let str = String(decoding: transactionsData, as: UTF8.self)
//            print("BODY \n \(str)")
            let decodedData = try decoder.decode(TransactionsList.self, from: transactionsData)
            return decodedData
            
        } catch {
            print("parse fail", error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

