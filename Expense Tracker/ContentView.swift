//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/5/23.
//  CWID: 885830877

import SwiftUI

struct ContentView: View {
    @State private var currentTab: String = "Expenses"
    var body: some View{
        TabView(selection: $currentTab){
            ExpenseView()
                .tag("Expenses")
                .tabItem{
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            CategoriesView()
                .tag("Categories")
                .tabItem{
                    Image(systemName: "list.clipboard.fill")
                    Text("Categories")
                }
        }
    }
}

#Preview {
    ContentView()
}
