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
                
                if(appState.recipes.isEmpty) {
                    Text("No Recipies Yet! Scan some receipts or add items to get srated.")
                        .padding()
                        .foregroundStyle(.gray)
                }
                List {
                    ForEach(filteredRecipes, id: \.id) { recipe in
                        RecipeListItemView(recipe: recipe)
                    }.onDelete(perform: deleteRecipe)
                }
                .navigationTitle("Recipes")
                .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Menu {
                                        Button(action: {
                                            showingAddRecipe.toggle()
                                        }) {
                                            Label("Add Recipe", systemImage: "plus")
                                        }
                                        Button(action: {
                                            appState.generateRecipiesRequest()
                                        }) {
                                            Label("Generate Recipe", systemImage: "sparkles")
                                        }
                                    } label: {
                                        Image(systemName: "plus") // Plus icon
                                    }
                                }
                            }
                .popover(isPresented: $showingAddRecipe) {
                    AddRecipeView()
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
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode // To dismiss the popover
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
                    HStack {
                        Text("• \(ingredient.name)")
                        Spacer()
                        Text("\(String(format: "%.2f", ingredient.recipeAmount))")
                        Text(ingredient.unit.lowercased() == "count" ? "" :  ingredient.unit.lowercased())
                        
                    }
                        .font(.body)
                        .textCase(.uppercase)
                }
                
                Text("Steps:")
                    .font(.headline)
                ForEach(recipe.steps.indices, id: \.self) { index in
                    Text("\(index + 1). \(recipe.steps[index])")
                        .font(.body)
                        .lineLimit(nil) // Allow multiple lines
                }
                
                Button {
                    appState.completeRecipe(recipe: recipe)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Complete Recipe")
                        .font(.system(size:25, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(Color.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
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
    @State private var ingredients: [Item] = [] // Array for ingredients
    @State private var steps: [String] = [] // Array for steps
    @State private var newIngredient: Item = Item() // For inputting a new ingredient
    @State private var newStep: String = "" // For inputting a new step
    @State private var showErrorAlert = false // State to control error alert
    @State private var selectedIngredient: Item? = nil // Selected ingredient from the picker
    @State private var selectedAmount: String = "" // Selected ingredient amount input
    @Environment(\.presentationMode) var presentationMode // To dismiss the popover

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe notes")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Notes", text: $notes)
                }

                // Ingredients Section with Picker, Amount, Unit, and Plus Button
                Section(header: Text("Ingredients")) {
                    HStack {
                        // Ingredient Picker in the first column
                        Picker("Ingredient", selection: $selectedIngredient) {
                            ForEach(appState.items, id: \.self) { ingredient in
                                Text(ingredient.name).tag(Optional(ingredient))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity) // Make it flexible to adjust based on space
                        .labelsHidden()

                        // Amount TextField in the second column
                        TextField("Amount", text: $selectedAmount)
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: .infinity)

                        // Unit in the third column
                        if let ingredient = selectedIngredient {
                            Text(ingredient.unit)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        // Compact Plus Button to add the ingredient
                        Button(action: addIngredient) {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Make the button smaller and less intrusive
                        .padding(.leading, 8)
                    }

                    // List showing current ingredients
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text("\(ingredient.name): \(ingredient.amount, specifier: "%.2f") \(ingredient.unit)")
                    }
                    .onDelete(perform: { indexSet in
                        ingredients.remove(atOffsets: indexSet)
                    })
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                clearFields()
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Done") {
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

    // Function to check if fields are valid
    private func validateFields() -> Bool {
        return !name.isEmpty && !description.isEmpty && !notes.isEmpty && !ingredients.isEmpty && !steps.isEmpty
    }

    // Function to add a recipe to the app state
    private func addRecipe() {
        let newRecipe = Recipe(id: UUID().uuidString, name: name, description: description, notes: notes, ingredients: ingredients, steps: steps)
        appState.recipes.append(newRecipe) // Add the new recipe to the app state
        clearFields() // Clear fields after adding
    }

    // Function to add an ingredient to the list
    private func addIngredient() {
        if let ingredient = selectedIngredient, let amount = Double(selectedAmount), !selectedAmount.isEmpty {
            var newIngredient = ingredient
            newIngredient.amount = amount
            ingredients.append(newIngredient)
            // Reset after adding
            selectedIngredient = nil
            selectedAmount = ""
        }
    }

    // Function to add a step to the list
    private func addStep() {
        if !newStep.isEmpty {
            steps.append(newStep.trimmingCharacters(in: .whitespaces))
            newStep = "" // Clear the input field
        }
    }

    // Function to clear all fields
    private func clearFields() {
        name = ""
        description = ""
        notes = ""
        ingredients = []
        steps = []
        newIngredient = Item()
        newStep = ""
        selectedIngredient = nil
        selectedAmount = ""
    }
}


struct EditRecipeView: View {
    @EnvironmentObject var appState: AppState
    var recipeID: String // Use recipe ID instead of binding to the recipe
    
    // Local state variables to hold inputs
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var notes: String = ""
    @State private var ingredients: [Item] = []
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
                    TextField("Ingredient", text: $ingredients[index].name)
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
        ingredients.append(Item()) // Add an empty ingredient
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
