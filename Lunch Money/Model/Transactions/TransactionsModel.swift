//
//  TransactionsModel.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 1/10/21.
//

import Foundation
import Charts

struct TransactionsModel {
    let transactionsList: [TransactionData]?
    
    var transactionsReversed: [TransactionData]? {
        return transactionsList?.reversed()
    }
    
    var count: Int {
        return transactionsList!.count
    }
    
    var categorySpend: Dictionary<Int, Float> {
        var categorySpendDict = [Int: Float]()
        
        for transaction in transactionsList! {
            let transactionAmount = transactionAmountToFloat(transaction: transaction)
            if let category = categorySpendDict[transaction.category_id!] {
                if transactionAmount > 0 {
                    categorySpendDict[transaction.category_id!] = transactionAmount + category
                }
            } else {
                if transactionAmount > 0 {
                    categorySpendDict[transaction.category_id!] = transactionAmount
                }
            }
        }
        return categorySpendDict
    }
    
    func getAt(index: Int, reversed: Bool) -> TransactionData {
        if reversed {
            return transactionsReversed![index]
        } else {
            return transactionsList![index]
        }
    }
    
    func getNumberOfTransactions(numberOfTransactions: Int, reversed: Bool) -> [TransactionData] {
        if reversed {
            return Array(transactionsReversed!.prefix(numberOfTransactions))
        } else {
            return Array(transactionsList!.prefix(numberOfTransactions))
        }
    }
    
    func transactionAmountToFloat(transaction: TransactionData) -> Float {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: transaction.amount!)
        return number!.floatValue
    }
    
    func getCategorySpendForChart(categories: CategoryListModel) -> [PieChartDataEntry]{
        var categoryChartDataArray = [PieChartDataEntry]()
        for (categoryId, categorySpendAmount) in categorySpend {
            let label = "\(categories.getCategoryNameFromId(id: categoryId)) - $\(Int(categorySpendAmount))"
            let categoryEntry = PieChartDataEntry(value: Double(Int(categorySpendAmount)), label: label)
            categoryChartDataArray.append(categoryEntry)
        }
        return categoryChartDataArray
    }
    
    func getIncomeVsExpenses(categories: CategoryListModel) -> [Float] {
        var income: Float = 0.0
        var expenses: Float = 0.0
        for transaction in transactionsList! {
            let transactionAmount = transactionAmountToFloat(transaction: transaction)
            if !categories.getExcludeFromTotalsById(id: transaction.category_id!) {
                if categories.getIsIncomeFromId(id: transaction.category_id!) {
                    income += transactionAmount
                } else {
                    expenses += transactionAmount
                }
            }
        }
        return [income, expenses]
    }
}
