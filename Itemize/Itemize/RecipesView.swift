//
//  RecipesView.swift
//  Itemize
//
//  Created by Seth Lenhof on 9/28/24.
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var appState: AppState // Access the AppState
    @State private var showingAddRecipe = false // State to control popover visibility
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Recipes")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 16)

                List(appState.recipes) { recipe in
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .navigationBarItems(trailing: Button(action: {
                showingAddRecipe.toggle() // Toggle the popover
            }) {
                Image(systemName: "plus") // Plus icon
            })
            .popover(isPresented: $showingAddRecipe) {
                AddRecipeView() // Show the AddRecipeView in the popover
                    .environmentObject(appState) // Pass the AppState to the popover
            }
        }
    }
}

#Preview {
    RecipesView().environmentObject(AppState()) // Provide the AppState instance for preview
}
