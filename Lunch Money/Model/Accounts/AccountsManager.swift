//
//  AccountsManager.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/30/20.
//

import Foundation

protocol AccountsManagerDelegate {
    func didUpdateAccounts(_ accountsManager: AccountsManager, accounts: AccountsList)
    func didFailWithError(error: Error)
}

struct AccountsManager {
    let accountsUrl = "https://dev.lunchmoney.app/v1/plaid_accounts"
    
    var delegate: AccountsManagerDelegate?
    
    func fetchAccounts() {
        if let url = URL(string: accountsUrl) {
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
                    if let accounts = self.parseJSON(safeData) {
                        self.delegate?.didUpdateAccounts(self, accounts: accounts)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ accountsData: Data) -> AccountsList? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(AccountsList.self, from: accountsData)
            return decodedData
            
        } catch {
            print("parse fail", error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

