//
//  CategoriesView.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/5/23.
//  CWID: 885830877

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var content
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    //Category Delete Request
    @State private var deleteReq: Bool = false
    @State private var reqCategory: Category?
    var body: some View {
        NavigationStack{
            List{
                ForEach(allCategories.sorted(by:{
                    ($0.expenses?.count ?? 0) > ($1.expenses?.count ?? 0)
                })) { category in
                    DisclosureGroup{
                        if let expenses = category.expenses, !expenses.isEmpty{
                            ForEach(expenses){expense in
                                ExpenseCardView(expense: expense, displayTag: false)
                            }
                        }else{
                            ContentUnavailableView{
                                Label("No Expenses", systemImage: "tray.fill")
                            }
                        }
                    } label:{
                        Text(category.categoryName)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false){
                        Button{
                            deleteReq.toggle()
                            reqCategory = category
                        }label:{
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle("Categories")
            .overlay{
                if allCategories.isEmpty{
                    ContentUnavailableView{
                        ContentUnavailableView{
                            Label("No Categories", systemImage: "tray.fill")
                        }

                    }
                }
            }
            // add a new catgetory button
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        addCategory.toggle()
                    }label:{
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $addCategory){
                categoryName = ""
            }content:{
                NavigationStack{
                    List{
                        Section("Title"){
                            TextField("General", text: $categoryName)
                        }
                    }
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    // Add and Cancel Button
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading){
                            Button ("Cancel"){
                                addCategory = false
                            }
                            .tint(.red)
                        }
                        ToolbarItem(placement: .topBarTrailing){
                            Button ("Add"){
                                // adding new category
                                let category = Category(categoryName: categoryName)
                                content.insert(category)
                                // closing view
                                categoryName = ""
                                addCategory = false
                            }
                            .disabled(categoryName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.height(180)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
            }

        }
        .alert("If you delete this category, all expenses will be deleted as well.", isPresented: $deleteReq){
            Button(role: .destructive){
                //deleteing the entire category
                if let reqCategory{
                    content.delete(reqCategory)
                    self.reqCategory = nil
                }
            }label:{
                Text("Delete")
            }
            Button(role: .cancel){
                reqCategory = nil
            }label:{
                Text("Cancel")
            }
        }
    }
}

#Preview {
    CategoriesView()
}
