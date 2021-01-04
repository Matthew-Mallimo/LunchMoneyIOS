//
//  TransactionsData.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/30/20.
//

import Foundation

struct TransactionsList: Decodable {
    let transactions: [TransactionData]
}

struct TransactionData: Decodable {
    let id: Int?
    let date: String?
    let payee: String?
    let amount: String?
    let currency: String?
    let notes: String?
    let category_id: Int?
    let asset_id: Int?
    let plaid_account_id: Int?
    let status: String?
    let parent_id: Int?
    let is_group: Bool
    let group_id: Int?
    let tags: [Tag]?
    let external_id: String?
}

struct Tag: Decodable {
    let id: Int?
    let name: String?
    let description: String?
}
