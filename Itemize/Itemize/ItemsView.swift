//
//  ItemsView.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//  Refactored by Seth Lenhof on 9/28/24 :)

import SwiftUI

struct ItemsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        List {
            ForEach(appState.items, id: \.id) { item in
                ItemsListItemView(item: item)
            }
            .onDelete(perform: deleteItem) // Swipe-to-delete functionality
        }
        .navigationTitle("Items")
        .toolbar {
            // Add button for logging a new item
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

struct ItemsListItemView: View {
    var item: Item
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            Text(item.name)
                .font(.headline)
            Spacer()
            Text(String(item.amount))
            Text(item.unit)
        }
        .padding(.vertical, 8)
    }
}

// Integrated ItemCreationView into this file
struct ItemCreationView: View {
    @State var item = Item()
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let units = ["Teaspon (tsp)", "Tablespoon (tbsp)", "Fluid Ounce (fl oz)", "Cup", "Pint", "Quart", "Ounce", "Pound (lb)"]

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
    
    // Validation logic for new items
    func validateItem() -> Bool {
        guard !item.name.isEmpty else {
            alertMessage = "Item name cannot be empty."
            showingAlert = true
            return false
        }
        
        guard item.amount > 0 else {
            alertMessage = "Amount must be greater than 0."
            showingAlert = true
            return false
        }
        
        guard !item.unit.isEmpty else {
            alertMessage = "Unit cannot be empty."
            showingAlert = true
            return false
        }
        
        guard item.price > 0 else {
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
