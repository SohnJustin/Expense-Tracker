//
//  ExpenseCardView.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/6/23.
//  CWID: 885830877

import SwiftUI

struct ExpenseCardView: View {
    @Bindable var expense: Expense
    var displayTag: Bool = true
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(expense.title)
                
                Text(expense.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                if let categoryName = expense.category?.categoryName, displayTag{
                    Text(categoryName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.blue.gradient, in: .capsule)
                }
            }
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            // Currency String
            Text(expense.currencyString)
                .font(.title3.bold())
        }
    }
}
