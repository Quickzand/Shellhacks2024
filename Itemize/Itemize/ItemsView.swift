//
//  ItemsView.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//  Refactored by Seth Lenhof on 9/28/24 :)

import SwiftUI

import SwiftUI

struct ItemsView: View {
    @EnvironmentObject var appState : AppState
    @State var editEnabled : Bool = false
    var body: some View {
        List {
            ForEach(appState.items, id: \.id) { item in
                ItemEditView(item: item, editItem: $editEnabled)
            }
            .onDelete(perform: deleteItem) // Adds swipe-to-delete functionality
        }
        .navigationTitle("Items")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    editEnabled.toggle()
                } label: {
                    Text(editEnabled ? "Done" : "Edit")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ItemCreationView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    // Function to handle deletion of an item
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = appState.items[index]
            appState.deleteItem(id: item.id)
        }
    }
}

struct ItemCreationView: View {
@State var item: Item? = nil
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Local state variables for form inputs
    @State private var name: String = ""
    @State private var amount: Double = 0
    @State private var unit: String = ""
    
    let units = ["Teaspoon (tsp)", "Tablespoon (tbsp)", "Fluid Ounce (fl oz)", "Cup", "Pint", "Quart", "Ounce", "Pound (lb)"]
    
    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Item Name", text: $name)
                Stepper(value: $amount, in: 0...1000) {
                    Text("Amount: \(amount)")
                }
                Picker("Unit", selection: $unit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit).tag(unit)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.top, 4)
            }
            
            Button(action: {
                if validateItem() {
                    saveItem()
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text(item == nil ? "Log Item" : "Update Item")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("Log New Item")
        .onAppear(perform: loadItemValues)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Missing Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Load the values into the form when editing an existing item
    private func loadItemValues() {
        if let item = item {
            self.name = item.name
            self.amount = item.amount
            self.unit = item.unit
        }
    }
    
    // Save or update the item in AppState
    private func saveItem() {
        if let existingItem = item {
            // Update the existing item
            if let index = appState.items.firstIndex(where: { $0.id == existingItem.id }) {
                appState.items[index] = Item(id: existingItem.id, name: name, amount: amount, unit: unit)
            }
        } else {
            // Create a new item
            let newItem = Item(id: UUID().uuidString, name: name, amount: amount, unit: unit)
            appState.addItem(item: newItem)
        }
    }
    
    func validateItem() -> Bool {
        // Check if the name is empty
        guard !name.isEmpty else {
            alertMessage = "Item name cannot be empty."
            showingAlert = true
            return false
        }
        
        // Check if the amount is greater than 0
        guard amount > 0 else {
            alertMessage = "Amount must be greater than 0."
            showingAlert = true
            return false
        }
        
        // Check if the unit is empty
        guard !unit.isEmpty else {
            alertMessage = "Unit cannot be empty."
            showingAlert = true
            return false
        }
        
        
        return true
    }
}

#Preview {
    ItemsView()
        .environmentObject(AppState())
}
