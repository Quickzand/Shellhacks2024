//
//  AppState.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import Foundation
import SwiftUI
import Combine

let apiKey = "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"


class AppState : ObservableObject {
    @Published var items : [Item] = []
    
    @Published var addedItems : [Item] = []
    
    @Published var groceries : [Item] = []
    

    @Published var isLoading : Bool = false
    
    @Published var showScannedItems : Bool = false 

    @Published var recipes: [Recipe] = []


    func deleteRecipe(id: String) {
        // Find the index of the recipe with the given id
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes.remove(at: index) // Remove the recipe if found
        }
    }
    
    func addToGroceries(item: Item) {
        if !groceries.contains(where: { $0.id == item.id }) {
            groceries.append(item)
        }
    }

    func removeFromGroceries(item: Item) {
        if let index = groceries.firstIndex(where: { $0.id == item.id }) {
            groceries.remove(at: index)
        }
    }

    func deleteItem(id : String) {
        let index = items.firstIndex(of: items.first(where: { $0.id == id })!)
        items.remove(at: index!)
    }
    
    
    func addItem(item : Item) {
        items.append(item)
    }
    
    func testRequest() {
//        Pick a number between 1 and 5
        var number = Int.random(in: 1...5)
        isLoading = true
        print("Starting scan of receipt\(number).png")
        if let imageData = UIImage(named: "receipt\(number).png")?.pngData() {
            chatGPTAnalyzeImage(with: imageData, apiKey: apiKey, prompt: "[NO PROSE] [OUTPUT ONLY JSON] Based off this receipt, generate JSON corresponding to different paremeters the items in the list. It should look like [{itemName: name, amount: amount, unit: unit }], if you do not know the data for sure, give your best estimate. If an item is not a grocery, ignore it. If you can simplify something, please do so. For example, dont name something boneless, skinless, chicken breast, just name is chicken breast. Dont say organic onions, just say onions. For example, if you have a bag of rice, say it is rice. IF there are two of the same item on a receipt, combine them. Do NOT return multiple of the same item. FOr units, never say packs of or bags of, give weights or volumes instead. If you need to, you can provide a unit as a count, and give an estimate of the count. So rather than a dozen eggs, put a 12 count. USE IMPERIAL AMERICAN UNITS. Additionally, here is a list of items, if the item is already in the list, include the item id in the output. For example, if you see chicken breast in the list with an id of 123, the ouput should look like {itemName: chicken breast, amount: 1, unit: kg, price: 10, id: 123}. Ensure units stay consistent as well. If something is listed multiple times, DONT REPEAT IT, rather, combine multiple entries into one. Here are the items: \(items)")
            
        }
    }
    
    func receiptScanRequest(image : UIImage) {
//        Pick a number between 1 and 5
        isLoading = true
        print("Starting analysis of receipt...")
        if let imageData = image.pngData() {
            chatGPTAnalyzeImage(with: imageData, apiKey: apiKey, prompt: "[NO PROSE] [OUTPUT ONLY JSON] Based off this receipt, generate JSON corresponding to different paremeters the items in the list. It should look like [{itemName: name, amount: amount, unit: unit}], if you do not know the data for sure, give your best estimate. If an item is not a grocery, ignore it. If you can simplify something, please do so. For example, dont name something boneless, skinless, chicken breast, just name is chicken breast. Dont say organic onions, just say onions. For example, if you have a bag of rice, say it is rice. IF there are two of the same item on a receipt, combine them. DO NOT Say any brand names. Do NOT return multiple of the same item. FOr units, never say packs of or bags of, give weights or volumes instead. If you need to, you can provide a unit as a count, and give an estimate of the count. So rather than a dozen eggs, put a 12 count. USE IMPERIAL AMERICAN UNITS. Additionally, here is a list of items, if the item is already in the list, include the item id in the output. For example, if you see chicken breast in the list with an id of 123, the ouput should look like {itemName: chicken breast, amount: 1, unit: kg, price: 10, id: 123}. Ensure units stay consistent as well. If something is listed multiple times, DONT REPEAT IT, rather, combine multiple entries into one. Here are the items: \(items)")
            
        }
    }
    
    
    
    func generateRecipiesRequest() {
        let prompt = """
        [NO PROSE] [OUTPUT ONLY JSON] Based off the items provided, generate JSON corresponding to a single recipe for a meal made with them. It should look like:
        [{ name: name, description: short, 2 sentence maximum description, ingredients: [Item array of ingredients] (formatted like {itemName: name, recipeAmount: amount, unit: unit} and units should match what the item already uses), steps: [String array of steps]}].
        Here are the items: \(items)
        """
        
        isLoading = true
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 1000
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.isLoading = false
                return
            }
            
            guard let data = data else {
                print("No data received")
                self.isLoading = false
                return
            }
            
            do {
                print(try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   var content = message["content"] as? String {
                    content = content.replacingOccurrences(of: "```json", with: "")
                    content = content.replacingOccurrences(of: "```", with: "")
                    content = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if let jsonData = content.data(using: .utf8),
                       let recipeArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]],
                       let recipeDict = recipeArray.first {
                        
                        let name = recipeDict["name"] as? String ?? "Unnamed Recipe"
                        let description = recipeDict["description"] as? String ?? ""
                        let ingredientDicts = recipeDict["ingredients"] as? [[String: Any]] ?? []
                        let steps = recipeDict["steps"] as? [String] ?? []
                        
                        // Decode ingredients
                        let ingredients: [Item] = ingredientDicts.compactMap { dict in
                            if let itemName = dict["itemName"] as? String,
                                  let amount = dict["recipeAmount"] as? Double,
                                  let unit = dict["unit"] as? String {
                                      return Item(name: itemName, unit: unit, recipeAmount: amount)
                                  }
                            return Item()
                        }
                        
                        // Create the Recipe object
                        let newRecipe = Recipe(id: UUID().uuidString, name: name, description: description, notes: "", ingredients: ingredients, steps: steps)
                        
                        // Update the recipes on the main thread
                        DispatchQueue.main.async {
                            self.recipes.append(newRecipe)
                            self.isLoading = false
                        }
                    }
                    
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
        
        task.resume()
    }

    
    
    func chatGPTAnalyzeImage(with image: Data, apiKey: String, prompt: String) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set headers
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Base64 encode the image
        let base64Image = image.base64EncodedString()
        
        // Create the payload as a dictionary
        let payload: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 4096
        ]
        
        // Convert the payload to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Parse the response
            do {
                print(data)
                print(try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   var content = message["content"] as? String {
                    // Remove the "```json" and "```" from the content
                    content = content.replacingOccurrences(of: "```json", with: "")
                    content = content.replacingOccurrences(of: "```", with: "")
                    content = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    print("HERE2")
                    // The content is a JSON string, we need to decode it.
                    if let jsonData = content.data(using: .utf8) {
                        if let itemsArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                            // Example of how to use this data
                            DispatchQueue.main.async {
                                self.addedItems = []
                                // Now you have the array of items in Swift dictionaries
                                for item in itemsArray {
                                    if let itemName = item["itemName"] as? String,
                                       let amount = item["amount"] as? Double,
                                       let unit = item["unit"] as? String {
                                        self.addedItems.append(Item(name: itemName, amount: amount, unit: unit))
                                    }
                                }
                                self.isLoading = false
                                self.showScannedItems = true
                                
                            }
                        }
                    } else {
                        print("Error converting content to Data.")
                        self.isLoading = false
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                self.isLoading = false
            }
        }

        task.resume()
    }
    
    
    func completeRecipe(recipe: Recipe) {
        // Loop through each ingredient in the recipe
        for ingredient in recipe.ingredients {
            // Check if the item exists in the items list
            if let itemIndex = items.firstIndex(where: { $0.name == ingredient.name }) {
                var item = items[itemIndex]
                
                // Ensure the units match before subtracting
                if item.unit == ingredient.unit {
                    // Subtract the recipe amount from the item's current amount
                    item.amount -= ingredient.recipeAmount
                    
                    // If the item's amount is now zero or less, remove it from the list
                    if item.amount <= 0 {
                        items.remove(at: itemIndex)
                    } else {
                        // Otherwise, update the item in the list with the new amount
                        items[itemIndex] = item
                    }
                } else {
                    print("Units don't match for \(item.name) and \(ingredient.name)")
                }
            } else {
                print("Item \(ingredient.name) not found in the list.")
            }
        }
    }

    
    

}




