//
//  ContentView.swift
//  iExpense
//
//  Created by Soumyattam Dey on 07/07/21.
//

import SwiftUI

struct ExpenseItem:Identifiable,Codable{
    var id=UUID()
    let name:String
    let type:String
    let amount:Int
}

class Expences:ObservableObject{
    @Published var items=[ExpenseItem](){
        didSet{
            let encoder=JSONEncoder()
            if let encoded=try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey:"Items")
            }
        }
    }
    
    init(){
        if let items=UserDefaults.standard.data(forKey: "Items"){
            let decoder=JSONDecoder()
            if let decoded=try? decoder.decode([ExpenseItem].self, from: items){
                self.items=decoded
                return
            }
        }
        items=[]
    }
}

struct ContentView: View {
    
    @ObservedObject var expenses=Expences()
    @State private var showingAddView=false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(expenses.items){ item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        if (item.amount)<=1000{
                            Text("₹\(item.amount)")
                                .font(.title3)
                                .foregroundColor(.green)
                                
                        }else if (item.amount)>1000 && (item.amount)<=10000{
                            Text("₹\(item.amount)")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }else{
                            Text("₹\(item.amount)")
                                .foregroundColor(.red)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        }
                        
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .sheet(isPresented: $showingAddView){
                AddView(expense: expenses)
            }
            .navigationBarItems(trailing: HStack{
                EditButton()
                Spacer()
                Button(action: {
                    showingAddView=true
                }, label: {
                    Text("+ Add")
                        .padding(4)
                        .border(Color.blue)
                })
            })
        }
    }
    
    func removeItems(at offsets:IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
