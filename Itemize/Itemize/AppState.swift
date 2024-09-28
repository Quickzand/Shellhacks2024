//
//  AppState.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import Foundation
import SwiftUI
import Combine

class AppState : ObservableObject {
    @Published var items : [Item] = [
        Item(ID: "1", name: "Rice", amount: 2, unit: "kg", price: 10.99),
        Item(ID: "2", name: "Pasta", amount: 3, unit: "packs", price: 5.49),
        Item(ID: "3", name: "Cereal", amount: 1, unit: "packs", price: 3.99),
        Item(ID: "4", name: "Flour",  amount: 5, unit: "kg", price: 7.49),
        Item(ID: "5", name: "Sugar",  amount: 2, unit: "kg", price: 4.99),
        Item(ID: "6", name: "Salt",  amount: 1, unit: "kg", price: 1.50),
        Item(ID: "7", name: "Beans",  amount: 6, unit: "cans", price: 8.99),
        Item(ID: "8", name: "Oats", amount: 1, unit: "kg", price: 4.79),
        Item(ID: "9", name: "Spaghetti",  amount: 2, unit: "packs", price: 5.29),
        Item(ID: "10", name: "Olive Oil", amount: 1, unit: "liters", price: 12.99)
    ]
    
    @Published var recipes: [Recipe] = [
        Recipe(id: "1", name: "Spaghetti Bolognese", description: "A classic Italian pasta dish.", details: "This hearty dish is made with ground beef, tomatoes, and a mix of spices. Serve with grated Parmesan cheese.",
               ingredients: ["200g Spaghetti", "100g Ground Beef", "50g Tomato Sauce", "Salt", "Pepper"],
               steps: [
                   "Cook spaghetti according to package instructions.",
                   "In a pan, brown the ground beef.",
                   "Add tomato sauce and simmer.",
                   "Serve over spaghetti."
               ]),
        
        Recipe(id: "2", name: "Chicken Curry", description: "A flavorful curry with tender chicken.", details: "Made with coconut milk, chicken, and a blend of spices. Best served with rice.",
               ingredients: ["300g Chicken", "200ml Coconut Milk", "1 Onion", "2 tbsp Curry Powder"],
               steps: [
                   "Chop the onion and sauté until golden.",
                   "Add chicken and cook until browned.",
                   "Stir in curry powder and coconut milk.",
                   "Simmer until chicken is cooked."
               ]),

        Recipe(id: "3", name: "Caesar Salad", description: "Crisp romaine with Caesar dressing.", details: "A refreshing salad with romaine lettuce, croutons, and Caesar dressing topped with Parmesan cheese.",
               ingredients: ["1 Romaine Lettuce", "50g Croutons", "2 tbsp Caesar Dressing", "Parmesan Cheese"],
               steps: [
                   "Chop the romaine lettuce.",
                   "Add croutons and dressing.",
                   "Toss to combine.",
                   "Top with Parmesan cheese."
               ]),

        Recipe(id: "4", name: "Vegetable Stir Fry", description: "A colorful mix of vegetables stir-fried in a savory sauce.", details: "Made with bell peppers, broccoli, carrots, and soy sauce, served over rice.",
               ingredients: ["1 Bell Pepper", "100g Broccoli", "2 Carrots", "2 tbsp Soy Sauce", "1 tbsp Olive Oil"],
               steps: [
                   "Chop all vegetables into bite-sized pieces.",
                   "Heat olive oil in a pan over medium heat.",
                   "Add vegetables and stir-fry for 5-7 minutes.",
                   "Add soy sauce and stir well.",
                   "Serve hot over rice."
               ]),

        Recipe(id: "5", name: "Margherita Pizza", description: "A simple pizza topped with fresh tomatoes and basil.", details: "Classic Neapolitan pizza with mozzarella cheese, fresh basil, and a drizzle of olive oil.",
               ingredients: ["1 Pizza Dough", "100g Mozzarella Cheese", "2 Tomatoes", "Fresh Basil", "Olive Oil"],
               steps: [
                   "Preheat the oven to 250°C (482°F).",
                   "Roll out the pizza dough on a floured surface.",
                   "Top with sliced tomatoes and mozzarella.",
                   "Drizzle with olive oil and add fresh basil.",
                   "Bake for 10-12 minutes until crust is golden."
               ]),

        Recipe(id: "6", name: "Chocolate Chip Cookies", description: "Soft and chewy cookies loaded with chocolate chips.", details: "These cookies are perfect for dessert or a snack.",
               ingredients: ["200g Flour", "100g Sugar", "100g Brown Sugar", "100g Butter", "1 Egg", "100g Chocolate Chips"],
               steps: [
                   "Preheat the oven to 180°C (350°F).",
                   "Cream together butter and sugars until light and fluffy.",
                   "Add the egg and mix well.",
                   "Stir in flour and chocolate chips.",
                   "Drop spoonfuls of dough onto a baking tray.",
                   "Bake for 10-12 minutes until golden."
               ]),

        Recipe(id: "7", name: "Pancakes", description: "Fluffy pancakes for a perfect breakfast.", details: "These pancakes are quick to make and delicious to eat.",
               ingredients: ["150g Flour", "2 Eggs", "200ml Milk", "1 tbsp Baking Powder", "1 tbsp Sugar"],
               steps: [
                   "In a bowl, mix flour, baking powder, and sugar.",
                   "In another bowl, whisk eggs and milk.",
                   "Combine wet and dry ingredients until smooth.",
                   "Heat a non-stick pan and pour in batter.",
                   "Cook until bubbles form, then flip and cook until golden."
               ]),

        Recipe(id: "8", name: "Grilled Salmon", description: "Perfectly grilled salmon fillet.", details: "Served with lemon and herbs, paired with a side of asparagus.",
               ingredients: ["2 Salmon Fillets", "1 Lemon", "2 tbsp Olive Oil", "Salt", "Pepper"],
               steps: [
                   "Preheat the grill to medium-high heat.",
                   "Drizzle salmon with olive oil and season with salt and pepper.",
                   "Place salmon on the grill skin-side down.",
                   "Grill for about 5-6 minutes on each side.",
                   "Serve with lemon wedges and asparagus."
               ]),

        Recipe(id: "9", name: "Beef Tacos", description: "Delicious tacos filled with seasoned beef.", details: "These tacos are quick to prepare and packed with flavor.",
               ingredients: ["200g Ground Beef", "4 Taco Shells", "1 Onion", "2 tbsp Taco Seasoning", "Lettuce", "Tomato"],
               steps: [
                   "Brown ground beef in a skillet.",
                   "Add chopped onion and cook until translucent.",
                   "Stir in taco seasoning and cook for another 2 minutes.",
                   "Fill taco shells with beef and top with lettuce and tomato.",
                   "Serve with salsa if desired."
               ]),

        Recipe(id: "10", name: "Quinoa Salad", description: "A healthy salad with quinoa and vegetables.", details: "Packed with nutrients and perfect as a side dish or light meal.",
               ingredients: ["100g Quinoa", "1 Cucumber", "200g Cherry Tomatoes", "1 Bell Pepper", "2 tbsp Olive Oil", "Lemon Juice"],
               steps: [
                   "Cook quinoa according to package instructions.",
                   "Chop cucumber, tomatoes, and bell pepper.",
                   "In a bowl, combine cooked quinoa and vegetables.",
                   "Drizzle with olive oil and lemon juice.",
                   "Toss to combine and serve chilled."
               ])
    ]

    func deleteRecipe(id: String) {
        // Find the index of the recipe with the given id
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes.remove(at: index) // Remove the recipe if found
        }
    }


    
    
    func deleteItem(id : String) {
        let index = items.firstIndex(of: items.first(where: { $0.ID == id })!)
        items.remove(at: index!)
    }
    
    
    func addItem(item : Item) {
        items.append(item)
    }
}
