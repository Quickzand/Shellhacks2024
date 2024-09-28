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
                ItemView(item: item, editMode: $editMode)
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




#Preview {
    ItemsView()
        .environmentObject(AppState())
}
