//
//  CategoriesDataModel.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 1/9/21.
//

import Foundation

struct CategoryListModel {

    let categoriesList: [CategoryData]?
    
    func getCategoryNameFromId(id: Int) -> String {
        if let category = categoriesList?.first(where: {$0.id == id}) {
            return category.name ?? ""
        }
        return ""
    }
    
    func getIsIncomeFromId(id: Int) -> Bool {
        if let category = categoriesList?.first(where: {$0.id == id}) {
            return category.is_income
        }
        return false
    }
    
    func getExcludeFromTotalsById(id: Int) -> Bool {
        if let category = categoriesList?.first(where: {$0.id == id}) {
            return category.exclude_from_totals
        }
        return false
    }
}
