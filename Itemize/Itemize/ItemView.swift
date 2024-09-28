//
//  ItemView.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import SwiftUI

struct ItemView : View {
    var item : Item
    @Binding var editMode : Bool
    @EnvironmentObject var appState : AppState
    @State private var showDeleteAlert : Bool = false
    var body : some View {
        HStack {
            Text(item.name)
                .font(.headline)
                .textCase(.uppercase)
            Spacer()
            Text(String(item.amount))
            Text(item.unit)
            if(editMode) {
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
            }
            }
        .alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text("Delete Item"),
                                message: Text("Are you sure you want to delete \(item.name)?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    // Confirm deletion
                                    appState.deleteItem(id: item.id)
                                },
                                secondaryButton: .cancel()
                            )
                        }
        }
    }

#Preview {
    ItemView(item:Item(), editMode:.constant(false))
}



struct ItemEditView: View {
    var item: Item
    @Binding var editItem: Bool
    @EnvironmentObject var appState: AppState
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        HStack {
            if editItem {
                // When in edit mode, the item is clickable and navigates to the editing view
                NavigationLink(destination: ItemCreationView(item: item)) {
                    itemRow
                }
            } else {
                itemRow // Non-clickable row when not in edit mode
            }
        }
    }
    
    // Extracted row view for reuse
    private var itemRow: some View {
        HStack {
            Text(item.name)
                .font(.headline)
            Spacer()
            Text(String(item.amount))
            Text(item.unit)
        }
    }
}
