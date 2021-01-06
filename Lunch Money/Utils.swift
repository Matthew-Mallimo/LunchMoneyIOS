//
//  Utils.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 1/3/21.
//

import Foundation

struct DateUtils {
    
    static var currentDate: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat =  K.commonDateFormat
        return formatter.string(from: date)
    }
    
    static var currentMinusThirty: String {
        let date = Date()
        let duration = DateComponents(calendar: Calendar.current, month: -1)
        let minusThirty = Calendar.current.date(byAdding: duration, to: date)!
        let formatter = DateFormatter()
        formatter.dateFormat =  K.commonDateFormat
        return formatter.string(from: minusThirty)
    }
}
