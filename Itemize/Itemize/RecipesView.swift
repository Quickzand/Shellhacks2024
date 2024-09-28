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
            }.onDelete(perform: deleteRecipe)
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
    private func deleteRecipe(at offsets: IndexSet) {
            for index in offsets {
                let recipe = appState.recipes[index] // Get the recipe to be deleted
                appState.deleteRecipe(id: recipe.id) // Call the delete method in AppState
            }
        }
}



struct RecipeListItemView: View {
    var recipe: Recipe // Recipe model
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}


// THIS NEEDS TO BE FIXED , when you add a random length recipe its like half the page. Add the ability to edit recipes
struct RecipeDetailView: View {
    var recipe: Recipe // The selected recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(recipe.description)
                    .font(.body)
                
                Text("Ingredients")
                    .font(.headline)
                    .fontWeight(.bold)
                ForEach(recipe.ingredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                        .font(.body)
                }
                
                Text("Details:")
                    .font(.headline)
                Text(recipe.details)
                    .font(.body)

                Text("Steps:")
                    .font(.headline)
                ForEach(recipe.steps.indices, id: \.self) { index in
                    Text("\(index + 1). \(recipe.steps[index])")
                        .font(.body)
                        .lineLimit(nil) // Allow multiple lines
                }
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline) // Keep the title inline
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    RecipesView().environmentObject(AppState()) // Provide the AppState instance for preview
}
