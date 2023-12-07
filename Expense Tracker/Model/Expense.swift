//
//  Expense.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/5/23.
//  CWID: 885830877

import SwiftUI
import SwiftData

@Model
class Expense {
    // Properties
    var title: String
    var subTitle: String
    var amount: Double
    var date: Date
    // Categories
    var category: Category?
    
    init(title: String, subTitle: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.amount = amount
        self.date = date
        self.category = category
        
    }
    
    // Currency String
    @Transient
    var currencyString: String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(for: amount) ?? ""
    }
}
