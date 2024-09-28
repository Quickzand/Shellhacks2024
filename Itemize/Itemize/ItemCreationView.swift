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
    
    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Item Name", text: $item.name)
                Stepper(value: $item.amount, in: 0...1000) {
                    Text("Amount: \(item.amount)")
                }
                TextField("Unit", text: $item.unit)
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
      
        
        return true
    }
}

#Preview {
    ItemCreationView()
        .environmentObject(AppState())
}
