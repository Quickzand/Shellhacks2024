//
//  ItemsView.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//  Refactored by Seth Lenhof on 9/28/24 :)

import SwiftUI

struct ItemsView: View {
    @EnvironmentObject var appState: AppState
    @State private var isEditingMode: Bool = false
    @State private var selectedItem: Item? = nil // Track the selected item for editing
    
    var body: some View {
        List {
            ForEach(appState.items, id: \.id) { item in
                ItemsListItemView(item: item)
                    .onTapGesture {
                        if isEditingMode {
                            selectedItem = item // Set the selected item for editing
                        }
                    }
            }
            .onDelete(perform: deleteItem) // Swipe-to-delete functionality
        }
        .navigationTitle("Items")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(isEditingMode ? "Done" : "Edit") {
                    isEditingMode.toggle()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ItemCreationView()) {
                    Image(systemName: "plus")
                }
            }
        }
        // If selectedItem is not nil, present the editing view for the selected item
        .sheet(item: $selectedItem) { selectedItem in
            ItemCreationView(item: selectedItem)
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

struct ItemsListItemView: View {
    var item: Item
    
    var body: some View {
        HStack {
            Text(item.name)
                .font(.headline)
            Spacer()
            Text("\(item.amount)")
            Text(item.unit)
        }
        .padding(.vertical, 8)
    }
}

struct ItemCreationView: View {
    // If an item is passed, we're editing; otherwise, we're creating a new item
    @State var item: Item? = nil
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Local state variables for form inputs
    @State private var name: String = ""
    @State private var amount: Double = 0
    @State private var unit: String = ""
    @State private var price: Double = 0
    
    let units = ["Teaspoon (tsp)", "Tablespoon (tbsp)", "Fluid Ounce (fl oz)", "Cup", "Pint", "Quart", "Ounce", "Pound (lb)"]

    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Item Name", text: $name)
                Stepper(value: $amount, in: 0...1000) {
                    Text("Amount: \(amount, specifier: "%.0f")")
                }
                Picker("Unit", selection: $unit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit).tag(unit)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.top, 4)
                TextField("Price", value: $price, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            Button(action: {
                if validateItem() {
                    saveItem()
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text(item == nil ? "Log Item" : "Save Changes") // Change button text based on context
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationTitle(item == nil ? "Log New Item" : "Edit Item") // Change title based on context
        .onAppear(perform: loadItemValues) // Load values if editing
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Missing Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Load values if we're editing an item
    private func loadItemValues() {
        if let item = item {
            self.name = item.name
            self.amount = item.amount
            self.unit = item.unit
            self.price = item.price
        }
    }
    
    // Save or update the item in AppState
    private func saveItem() {
        if let existingItem = item {
            // We're editing an existing item, so update it
            if let index = appState.items.firstIndex(where: { $0.id == existingItem.id }) {
                appState.items[index] = Item(id: existingItem.id, name: name, amount: amount, unit: unit, price: price)
            }
        } else {
            // We're creating a new item
            let newItem = Item(id: UUID().uuidString, name: name, amount: amount, unit: unit, price: price)
            appState.addItem(item: newItem)
        }
    }
    
    // Validation logic for new/edit items
    func validateItem() -> Bool {
        guard !name.isEmpty else {
            alertMessage = "Item name cannot be empty."
            showingAlert = true
            return false
        }

        guard amount > 0 else {
            alertMessage = "Amount must be greater than 0."
            showingAlert = true
            return false
        }

        guard !unit.isEmpty else {
            alertMessage = "Unit cannot be empty."
            showingAlert = true
            return false
        }

        guard price > 0 else {
            alertMessage = "Price must be greater than 0."
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
