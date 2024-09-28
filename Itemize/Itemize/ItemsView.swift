//
//  ItemsView.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import SwiftUI

struct ItemsView: View {
    @EnvironmentObject var appState : AppState
    @State var editMode : Bool = false
    var body: some View {
        List {
            ForEach(appState.items , id: \.id) { item in
                ItemsListItemView(item: item, editMode: $editMode)
            }
        }
        .navigationTitle("Items")
        .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        editMode.toggle()
                    } label: {
                        Text(editMode ? "Done" : "Edit")
                    }
            }
                 ToolbarItem(placement: .navigationBarTrailing) {
                     NavigationLink(destination: ItemCreationView()) {
                         Image(systemName: "plus")
                     }
                 }
             }
    }
}

struct ItemsListItemView : View {
    var item : Item
    @Binding var editMode : Bool
    @EnvironmentObject var appState : AppState
    @State private var showDeleteAlert : Bool = false
    var body : some View {
        HStack {
            Text(item.name)
                .font(.headline)
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
    ItemsView()
        .environmentObject(AppState())
}
