import SwiftUI

struct AddRecipeView: View {
    @EnvironmentObject var appState: AppState // Access AppState
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var details: String = ""
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
            }
            .navigationTitle("Add Recipe")
            .navigationBarItems(trailing: Button("Add") {
                if validateFields() {
                    addRecipe() // Add the recipe if fields are valid
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
        return !name.isEmpty && !description.isEmpty && !details.isEmpty // Check if all fields are filled
    }
    
    private func addRecipe() {
        let newRecipe = Recipe(id: UUID().uuidString, name: name, description: description, details: details)
        appState.recipes.append(newRecipe) // Add the new recipe to the app state
        clearFields() // Clear fields after adding
    }
    
    private func clearFields() {
        name = ""
        description = ""
        details = ""
    }
}

#Preview {
    AddRecipeView().environmentObject(AppState()) // Provide the AppState instance for preview
}
	
