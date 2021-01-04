//
//  Categories.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/29/20.
//

import Foundation

struct CategoriesList: Decodable {
    let categories: [CategoryData]
}

struct CategoryData: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let is_income: Bool
    let exclude_from_budget: Bool
    let exclude_from_totals: Bool
    let updated_at: String?
    let created_at: String?
    let is_group: Bool
    let group_id: Int?
}
