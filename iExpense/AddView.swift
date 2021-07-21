//
//  AddView.swift
//  iExpense
//
//  Created by Soumyattam Dey on 07/07/21.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name=""
    @State private var type="Personal"
    @State private var amount=""
    
    @State private var showAlert=false
    
    @ObservedObject var expense = Expences()
    
    static let types=["Business","Personal"]
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                    .autocapitalization(.none)
                Picker("Type",selection:$type){
                    ForEach(AddView.types,id: \.self){
                        Text($0)
                    }
                }
                TextField("Amount",text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save"){
                if let actualAmount=Int(amount){
                    let item=ExpenseItem(name: name, type: type, amount: actualAmount)
                    expense.items.append(item)
                    presentationMode.wrappedValue.dismiss()
                }else{
                    showAlert=true
                }
            })
            .alert( isPresented: $showAlert){
                Alert(title: Text("Error"), message: Text("Enter a number"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expense: Expences())
    }
}
