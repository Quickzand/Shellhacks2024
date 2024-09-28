import SwiftUI

struct AddRecipeView: View {
    @EnvironmentObject var appState: AppState // Access AppState
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var details: String = ""
    @State private var ingredients: String = "" // For inputting ingredients
    @State private var steps: String = "" // For inputting steps
    @State private var showErrorAlert = false // State to control error alert
    @Environment(\.presentationMode) var presentationMode // To dismiss the popover

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Details", text: $details)
                }
                
                Section(header: Text("Ingredients (comma separated)")) {
                    TextField("Enter ingredients", text: $ingredients)
                }
                
                Section(header: Text("Steps (comma separated)")) {
                    TextField("Enter steps", text: $steps)
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarItems(trailing: Button("Done") {
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
        return !name.isEmpty && !description.isEmpty && !details.isEmpty && !ingredients.isEmpty && !steps.isEmpty
    }
    
    private func addRecipe() {
        // Split ingredients and steps by commas and trim whitespace
        let ingredientList = ingredients.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let stepList = steps.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        let newRecipe = Recipe(id: UUID().uuidString, name: name, description: description, details: details, ingredients: ingredientList, steps: stepList)
        appState.recipes.append(newRecipe) // Add the new recipe to the app state
        clearFields() // Clear fields after adding
    }
    
    private func clearFields() {
        name = ""
        description = ""
        details = ""
        ingredients = ""
        steps = ""
    }
}

#Preview {
    AddRecipeView().environmentObject(AppState()) // Provide the AppState instance for preview
}
