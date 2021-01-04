//
//  AccountsData.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/30/20.
//

import Foundation

struct AccountsList: Decodable {
    let plaid_accounts: [AccountData]
}

struct AccountData: Decodable {
    let id: Int?
    let date_linked: String?
    let name: String?
    let type: String?
    let subtype: String?
    let mask: String?
    let institution_name: String?
    let status: String?
    let last_import: String?
    let balance: String?
    let currency: String?
    let balance_last_update: String?
    let limit: Int?
}
