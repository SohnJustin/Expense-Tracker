//
//  AddExpenseView.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/5/23.
//  CWID: 885830877

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    // View Properties
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
    //Categories
    @Query(animation: .snappy) private var allCategories: [Category]
    var body: some View {
        NavigationStack{
            List{
                Section("Title"){
                    TextField("Title of Expense", text: $title)
                }
                Section("Description"){
                    TextField("This is the description of the Expense", text: $subTitle)
                }
                Section("Amount Spent"){
                    HStack(spacing: 4){
                        Text("$")
                            .fontWeight(.semibold)
                        
                        TextField("0.0", value: $amount, formatter: formatter)
                            .keyboardType(.numberPad)
                    }
                }
                Section("Date"){
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                // Category Picker
                if !allCategories.isEmpty{
                    HStack{
                        Text("Category")
                        Spacer()
                        Menu{
                            ForEach(allCategories){category in
                                Button(category.categoryName){
                                    self.category = category
                                }
                            }
                            //
                            Button("None"){
                                category = nil
                            }
                        }label:{
                            if let categoryName = category?.categoryName{
                                Text(categoryName)
                            }else{
                                Text("None")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                // Cancel and Add button
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                    .tint(.red)
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add", action: addExpense)
                        .disabled(disableAddButton)
                }
            }
        }
    }
    // Disable add button til every data entries have been entered
    var disableAddButton: Bool{
        return title.isEmpty || subTitle.isEmpty || amount == .zero
    }
    
    // Adding Expense to the Data
    func addExpense(){
        let expense = Expense(title: title, subTitle: subTitle, amount: amount, date: date, category: category)
        context.insert(expense)
        // Close view once the data has been inserted
        dismiss()
    }
    // Formats $  in decimals
    var formatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    AddExpenseView()
}
