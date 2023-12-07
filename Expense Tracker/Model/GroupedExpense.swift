//
//  GroupedExpense.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/5/23.
//  CWID: 885830877

import SwiftUI

struct GroupedExpenses: Identifiable{
    var id: UUID = .init()
    var date: Date
    var expenses: [Expense]
    
    // Group Title
    var groupTitle: String{
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date){
            return "Today"
        }
        else if calendar.isDateInYesterday(date){
            return "Yesterday"
        }
        else{
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
