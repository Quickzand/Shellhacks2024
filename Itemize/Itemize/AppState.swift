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
        Recipe(id: "1", name: "Spaghetti Bolognese", description: "A classic Italian pasta dish.", details: "This hearty dish is made with ground beef, tomatoes, and a mix of spices. Serve with grated Parmesan cheese."),
        Recipe(id: "2", name: "Chicken Curry", description: "A flavorful curry with tender chicken.", details: "Made with coconut milk, chicken, and a blend of spices. Best served with rice."),
        Recipe(id: "3", name: "Caesar Salad", description: "Crisp romaine with Caesar dressing.", details: "A refreshing salad with romaine lettuce, croutons, and Caesar dressing topped with Parmesan cheese."),
        Recipe(id: "4", name: "Beef Tacos", description: "Delicious tacos filled with seasoned beef.", details: "Soft or hard shell tacos filled with ground beef, lettuce, cheese, and salsa."),
        Recipe(id: "5", name: "Vegetable Stir Fry", description: "A colorful mix of vegetables stir-fried in a savory sauce.", details: "Made with bell peppers, broccoli, carrots, and soy sauce, served over rice."),
        Recipe(id: "6", name: "Margherita Pizza", description: "A simple pizza topped with fresh tomatoes and basil.", details: "Classic Neapolitan pizza with mozzarella cheese, fresh basil, and a drizzle of olive oil."),
        Recipe(id: "7", name: "Pancakes", description: "Fluffy pancakes for a perfect breakfast.", details: "Made with flour, milk, eggs, and served with maple syrup and fresh berries."),
        Recipe(id: "8", name: "Grilled Salmon", description: "Perfectly grilled salmon fillet.", details: "Served with lemon and herbs, paired with a side of asparagus."),
        Recipe(id: "9", name: "Chocolate Chip Cookies", description: "Classic cookies with chocolate chips.", details: "Soft and chewy cookies loaded with chocolate chips, great for dessert."),
        Recipe(id: "10", name: "Quinoa Salad", description: "A healthy salad with quinoa and vegetables.", details: "Made with quinoa, cherry tomatoes, cucumbers, and a lemon vinaigrette dressing.")
    ]

    
    
    func deleteItem(id : String) {
        let index = items.firstIndex(of: items.first(where: { $0.ID == id })!)
        items.remove(at: index!)
    }
    
    
    func addItem(item : Item) {
        items.append(item)
    }
}
