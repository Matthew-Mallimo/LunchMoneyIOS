//
//  CategoriesManager.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/29/20.
//

import Foundation

protocol CategoriesManagerDelegate {
    func didUpdateCategories(_ categoriesManager: CategoriesManager, categories: CategoriesList)
    func didFailWithError(error: Error)
}

struct CategoriesManager {
    let categoriesUrl = "https://dev.lunchmoney.app/v1/categories"
    
    var delegate: CategoriesManagerDelegate?
    
    func fetchCategories() {
        if let url = URL(string: categoriesUrl) {
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
                    if let categories = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCategories(self, categories: categories)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ categoriesData: Data) -> CategoriesList? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CategoriesList.self, from: categoriesData)
            return decodedData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}

