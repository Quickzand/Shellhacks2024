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
        List {
            ForEach(appState.recipes, id: \.id) { recipe in
                RecipeListItemView(recipe: recipe) // Use a separate view for each recipe
            }
        }
        .navigationTitle("Recipes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddRecipe.toggle() // Toggle the popover
                }) {
                    Image(systemName: "plus") // Plus icon
                }
            }
        }
        .popover(isPresented: $showingAddRecipe) {
            AddRecipeView() // Show the AddRecipeView in the popover
                .environmentObject(appState) // Pass the AppState to the popover
        }
    }
}

struct RecipeListItemView: View {
    var recipe: Recipe // Recipe model
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.headline)
            Text(recipe.description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    RecipesView().environmentObject(AppState()) // Provide the AppState instance for preview
}
