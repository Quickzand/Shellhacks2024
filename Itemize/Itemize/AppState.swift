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
    
    
    func deleteItem(id : String) {
        let index = items.firstIndex(of: items.first(where: { $0.ID == id })!)
        items.remove(at: index!)
    }
    
    
    func addItem(item : Item) {
        items.append(item)
    }
}
