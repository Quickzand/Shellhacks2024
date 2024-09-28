//
//  groceriesView.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import SwiftUI

struct GroceriesView: View {
    @EnvironmentObject var appState: AppState
    @State private var showItemsSheet: Bool = false
    @State private var tempGroceries: [Item] = []
    
    var body: some View {
        ScrollView(.vertical) {
            // Sort items so that acquired items appear at the bottom
            ForEach(appState.groceries.sorted(by: { !$0.acquired && $1.acquired }), id: \.id) { item in
                GroceryItemView(item: item)
            }
            
            if appState.groceries.isEmpty {
                Button {
                    // Initialize tempGroceries when the sheet is presented
                    tempGroceries = appState.groceries
                    showItemsSheet = true
                } label: {
                    Text("You dont currently have a grocery list. Would you like to start one?")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .frame(maxWidth:.infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Groceries")
        .sheet(isPresented: $showItemsSheet) {
            NavigationView {
                List {
                    // List only items that are not in the tempGroceries list
                    ForEach(appState.items, id: \.id) { item in
                        AddToTempGroceriesItemView(item: item, tempGroceries: $tempGroceries)
                    }
                }
                .navigationTitle("Add Items")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            appState.groceries = tempGroceries
                            showItemsSheet = false
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showItemsSheet = false
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Update") {
//                    Remove any acquired items from the grocery list
                    appState.groceries.removeAll(where: \.acquired) 
                }
            }
        }
    }
}


struct AddToTempGroceriesItemView: View {
    var item: Item
    @Binding var tempGroceries: [Item]

    var isInTempGroceries: Bool {
        tempGroceries.contains(where: { $0.id == item.id })
    }

    var body: some View {
        Button {
            if isInTempGroceries {
                tempGroceries.removeAll(where: { $0.id == item.id })
            } else {
                tempGroceries.append(item)
            }
        } label: {
            HStack {
                Image(systemName: isInTempGroceries ? "minus.circle.fill" : "plus.circle.fill")
                Text(item.name)
            }
        }
    }
}


struct GroceryItemView : View {
    @State var item : Item
    @State private var isAcquired : Bool = false
    @EnvironmentObject var appState : AppState
    var body : some View {
        Button {
            isAcquired.toggle()
        } label:
        {
            HStack {
                Image(systemName: isAcquired ? "checkmark.circle.fill" : "circle")
                Text(item.name)
                Spacer()
            }.onChange(of: isAcquired) { newValue in
                item.acquired = newValue
                let index = appState.groceries.firstIndex(of: appState.groceries.first(where: { $0.id == item.id })!)
                appState.groceries[index!].acquired = newValue
            }
            .onAppear {
                isAcquired = item.acquired
            }
        }
        .foregroundStyle(isAcquired ? Color.orange : .primary )
        .toggleStyle(.button)
        .frame(maxWidth:.infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}

#Preview {
    GroceriesView()
        .environmentObject(AppState())
}
