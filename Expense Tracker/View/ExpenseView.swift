//
//  ExpenseView.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/5/23.
//  CWID: 885830877

import SwiftUI
import SwiftData

struct ExpenseView: View {
    
    // Grouped Expennse Properties
    @Query(sort:[
        SortDescriptor(\Expense.date, order:.reverse)
    ],animation: .snappy) private var allExpenses: [Expense]
    @Environment(\.modelContext) private var content
    // Grouped Expenses
    @State private var groupedExpenses: [GroupedExpenses] = []
    @State private var addExpense: Bool = false
    var body: some View {
        NavigationStack{
            List{
                ForEach($groupedExpenses){ $group in
                    Section(group.groupTitle){
                        ForEach(group.expenses){ expense in
                            // Card View
                            ExpenseCardView(expense: expense)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                    // Delete by swiping Expense
                                    Button{
                                        content.delete(expense)
                                        withAnimation{
                                            group.expenses.removeAll(where:{ $0.id == expense.id})
                                            if group.expenses.isEmpty{
                                                groupedExpenses.removeAll(where:{ $0.id == group.id})
                                            }
                                        }
                                    }label: {
                                        Image(systemName: "trash")
                                        
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
            .navigationTitle("Your Expenses")
            .overlay{
                if allExpenses.isEmpty || groupedExpenses.isEmpty{
                    ContentUnavailableView{
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            // add a new catgetory button
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        addExpense.toggle()
                    }label:{
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
        .onChange(of:allExpenses, initial:true){oldValue, newValue in
            if newValue.count > oldValue.count || groupedExpenses.isEmpty{
                createGroupedExpenses(newValue)
            }
        }
        .sheet(isPresented: $addExpense){
            AddExpenseView()
                .interactiveDismissDisabled()
        }
    }
    // Grouped Expenses (Grouped by date)
    func createGroupedExpenses(_ expenses: [Expense]){
        Task.detached(priority: .high){
            let groupedDict = Dictionary(grouping: expenses){expense in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from:expense.date)
                
                return dateComponents
            }
            // Sorting Dictionary in Descending order
            let sortedDict = groupedDict.sorted{
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            // Adding into Grouped Expenses Array
            await MainActor.run{
                groupedExpenses = sortedDict.compactMap({ dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                })
            }
        }
    }
}

#Preview {
    ExpenseView()
}
