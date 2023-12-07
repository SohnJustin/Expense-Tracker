//
//  Category.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/5/23.
//  CWID: 885830877

import SwiftUI
import SwiftData

@Model
class Category{
    var categoryName: String
    
    //Expenses
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    
    init(categoryName: String){
        self.categoryName = categoryName
    }
}
