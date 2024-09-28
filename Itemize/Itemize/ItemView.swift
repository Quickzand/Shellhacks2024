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
