//
//  RecipesView.swift
//  Itemize
//
//  Created by Seth Lenhof on 9/28/24.
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddRecipe = false
    @State private var searchString: String = ""
    
    var filteredRecipes: [Recipe] {
        if searchString.isEmpty {
                return appState.recipes // Return all recipes if search text is empty
            } else {
                return appState.recipes.filter { $0.name.lowercased().contains(searchString.lowercased()) } // Filter recipes by name
            }
        }
    
    var body: some View {
        
            VStack{
                SearchBar(text: $searchString)
                
                List {
                    ForEach(filteredRecipes, id: \.id) { recipe in
                        RecipeListItemView(recipe: recipe)
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
                
                Text("Notes:")
                    .font(.headline)
                Text(recipe.notes)
                    .font(.body)
                
                Text("Ingredients")
                    .font(.headline)
                    .fontWeight(.bold)
                ForEach(recipe.ingredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                        .font(.body)
                }
                
                Text("Steps:")
                    .font(.headline)
                ForEach(recipe.steps.indices, id: \.self) { index in
                    Text("\(index + 1). \(recipe.steps[index])")
                        .font(.body)
                        .lineLimit(nil) // Allow multiple lines
                }
            }
            .padding(.leading)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: EditRecipeView(recipeID: recipe.id)) {
                            Text("Edit")
                        }
                    }
                }
    }
}

struct AddRecipeView: View {
    @EnvironmentObject var appState: AppState // Access AppState
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var notes: String = ""
    @State private var ingredients: [String] = [] // Array for ingredients
    @State private var steps: [String] = [] // Array for steps
    @State private var newIngredient: String = "" // For inputting a new ingredient
    @State private var newStep: String = "" // For inputting a new step
    @State private var showErrorAlert = false // State to control error alert
    @Environment(\.presentationMode) var presentationMode // To dismiss the popover

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe notes")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Notes", text: $notes)
                }

                Section(header: Text("Ingredients")) {
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                    }
                    HStack {
                        TextField("New Ingredient", text: $newIngredient)
                        Button(action: addIngredient) {
                            Image(systemName: "plus")
                        }
                    }
                }

                Section(header: Text("Steps")) {
                    ForEach(steps, id: \.self) { step in
                        Text("• \(step)")
                    }
                    HStack {
                        TextField("New Step", text: $newStep)
                        Button(action: addStep) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarItems(leading: Button("Cancel"){
                clearFields()
                presentationMode.wrappedValue.dismiss()
            },trailing: Button("Done") {
                if validateFields() {
                    addRecipe() // Add the recipe when Done is pressed
                    presentationMode.wrappedValue.dismiss() // Dismiss the popover
                } else {
                    showErrorAlert = true // Show error alert
                }
            })
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Missing Information"),
                    message: Text("Please fill in all fields."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func validateFields() -> Bool {
        return !name.isEmpty && !description.isEmpty && !notes.isEmpty && !ingredients.isEmpty && !steps.isEmpty
    }
    
    private func addRecipe() {
        let newRecipe = Recipe(id: UUID().uuidString, name: name, description: description, notes: notes, ingredients: ingredients, steps: steps)
        appState.recipes.append(newRecipe) // Add the new recipe to the app state
        clearFields() // Clear fields after adding
    }
    
    private func addIngredient() {
        if !newIngredient.isEmpty {
            ingredients.append(newIngredient.trimmingCharacters(in: .whitespaces))
            newIngredient = "" // Clear the input field
        }
    }

    private func addStep() {
        if !newStep.isEmpty {
            steps.append(newStep.trimmingCharacters(in: .whitespaces))
            newStep = "" // Clear the input field
        }
    }
    
    private func clearFields() {
        name = ""
        description = ""
        notes = ""
        ingredients = []
        steps = []
        newIngredient = ""
        newStep = ""
    }
}

struct EditRecipeView: View {
    @EnvironmentObject var appState: AppState
    var recipeID: String // Use recipe ID instead of binding to the recipe
    
    // Local state variables to hold inputs
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var notes: String = ""
    @State private var ingredients: [String] = []
    @State private var steps: [String] = []
    
    var body: some View {
        Form {
            Section(header: Text("Recipe Details")) {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
                TextField("Notes", text: $notes)
            }
            
            Section(header: Text("Ingredients")) {
                ForEach(0..<ingredients.count, id: \.self) { index in
                    TextField("Ingredient", text: $ingredients[index])
                }
                .onDelete(perform: deleteIngredient)
                Button(action: addIngredient) {
                    Label("Add Ingredient", systemImage: "plus")
                }
            }
            
            Section(header: Text("Steps")) {
                ForEach(0..<steps.count, id: \.self) { index in
                    TextField("Step", text: $steps[index])
                }
                .onDelete(perform: deleteStep)
                Button(action: addStep) {
                    Label("Add Step", systemImage: "plus")
                }
            }
        }
        .onAppear(perform: loadRecipe)
        .navigationTitle("Edit Recipe")
        .navigationBarItems(trailing: Button("Save") {
            saveRecipe() // Call saveRecipe when done
        })
    }
    
    private func loadRecipe() {
        if let recipe = appState.recipes.first(where: { $0.id == recipeID }) {
            // Load the existing recipe details into local state variables
            name = recipe.name
            description = recipe.description
            notes = recipe.notes
            ingredients = recipe.ingredients
            steps = recipe.steps
        }
    }
    
    private func saveRecipe() {
        // Update the recipe in AppState
        if let index = appState.recipes.firstIndex(where: { $0.id == recipeID }) {
            // Replace the recipe with the updated values
            appState.recipes[index] = Recipe(id: recipeID, name: name, description: description, notes: notes, ingredients: ingredients, steps: steps)
        }
    }
    
    private func addIngredient() {
        ingredients.append("") // Add an empty ingredient
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets) // Remove the ingredient
    }
    
    private func addStep() {
        steps.append("") // Add an empty step
    }
    
    private func deleteStep(at offsets: IndexSet) {
        steps.remove(atOffsets: offsets) // Remove the step
    }
}


#Preview {
    ContentView().environmentObject(AppState()) // Provide the AppState instance for preview
}
