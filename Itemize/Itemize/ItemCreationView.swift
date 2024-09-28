//
//  ItemCreationView.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import SwiftUI

struct ItemCreationView: View {
    @State var item = Item()
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let units = ["Teaspon (tsp)", "Tablespoon(tbsp)", "Fluid Ounce (fl oz)", "Cup", "Pint", "Quart", "Ounce", "Pound (lb)"]
    

    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Item Name", text: $item.name)
                Stepper(value: $item.amount, in: 0...1000) {
                    Text("Amount: \(item.amount)")
                }
                Picker("Unit", selection: $item.unit) {
                                        ForEach(units, id: \.self) { unit in
                                            Text(unit).tag(unit)
                                        }
                                    }
                .pickerStyle(MenuPickerStyle())
                                    .padding(.top, 4)
                TextField("Price", value: $item.price, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            Button(action: {
                if validateItem() {
                    appState.addItem(item: item)
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Log Item")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("Log New Item")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Missing Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func validateItem() -> Bool {
        // Check if the name is empty
        guard !item.name.isEmpty else {
            alertMessage = "Item name cannot be empty."
            showingAlert = true
            return false
        }
        
        // Check if the amount is greater than 0
        guard item.amount > 0 else {
            alertMessage = "Amount must be greater than 0."
            showingAlert = true
            return false
        }
        
        // Check if the unit is empty
        guard !item.unit.isEmpty else {
            alertMessage = "Unit cannot be empty."
            showingAlert = true
            return false
        }
        
        // Check if the price is greater than 0
        guard item.price > 0 else {
            alertMessage = "Price must be greater than 0."
            showingAlert = true
            return false
        }
        
        return true
    }
}

#Preview {
    ItemCreationView()
        .environmentObject(AppState())
}
