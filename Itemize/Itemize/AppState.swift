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
        Item(ID: "1", name: "Rice", description: "Staple grain for many meals.", amount: 2, unit: "kg", price: 10.99),
        Item(ID: "2", name: "Pasta", description: "Dried pasta for various dishes.", amount: 3, unit: "packs", price: 5.49),
        Item(ID: "3", name: "Cereal", description: "Quick and easy breakfast option.", amount: 1, unit: "packs", price: 3.99),
        Item(ID: "4", name: "Flour", description: "All-purpose flour for baking.", amount: 5, unit: "kg", price: 7.49),
        Item(ID: "5", name: "Sugar", description: "Granulated sugar for cooking and baking.", amount: 2, unit: "kg", price: 4.99),
        Item(ID: "6", name: "Salt", description: "Table salt for seasoning.", amount: 1, unit: "kg", price: 1.50),
        Item(ID: "7", name: "Beans", description: "Canned beans for quick meals.", amount: 6, unit: "cans", price: 8.99),
        Item(ID: "8", name: "Oats", description: "Healthy oats for breakfast.", amount: 1, unit: "kg", price: 4.79),
        Item(ID: "9", name: "Spaghetti", description: "Durum wheat pasta.", amount: 2, unit: "packs", price: 5.29),
        Item(ID: "10", name: "Olive Oil", description: "High-quality olive oil.", amount: 1, unit: "liters", price: 12.99)
    ]
}
