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
    

    @Published var isLoading : Bool = false
    
    @Published var showScannedItems : Bool = false 

    @Published var recipes: [Recipe] = [
        Recipe(id: "1", name: "Spaghetti Bolognese", description: "A classic Italian pasta dish.", notes: "Quick and easy. SO GOOD.",
               ingredients: ["200g Spaghetti", "100g Ground Beef", "50g Tomato Sauce", "Salt", "Pepper"],
               steps: [
                   "Cook spaghetti according to package instructions.",
                   "In a pan, brown the ground beef.",
                   "Add tomato sauce and simmer.",
                   "Serve over spaghetti."
               ]),
        
        Recipe(id: "2", name: "Chicken Curry", description: "A flavorful curry with tender chicken.", notes: "Yum!",
               ingredients: ["300g Chicken", "200ml Coconut Milk", "1 Onion", "2 tbsp Curry Powder"],
               steps: [
                   "Chop the onion and sauté until golden.",
                   "Add chicken and cook until browned.",
                   "Stir in curry powder and coconut milk.",
                   "Simmer until chicken is cooked."
               ]),

        Recipe(id: "3", name: "Caesar Salad", description: "Crisp romaine with Caesar dressing.", notes: "cheap and quick",
               ingredients: ["1 Romaine Lettuce", "50g Croutons", "2 tbsp Caesar Dressing", "Parmesan Cheese"],
               steps: [
                   "Chop the romaine lettuce.",
                   "Add croutons and dressing.",
                   "Toss to combine.",
                   "Top with Parmesan cheese."
               ]),

        Recipe(id: "4", name: "Vegetable Stir Fry", description: "A colorful mix of vegetables stir-fried in a savory sauce.", notes: "Good for a quick meal.",
               ingredients: ["1 Bell Pepper", "100g Broccoli", "2 Carrots", "2 tbsp Soy Sauce", "1 tbsp Olive Oil"],
               steps: [
                   "Chop all vegetables into bite-sized pieces.",
                   "Heat olive oil in a pan over medium heat.",
                   "Add vegetables and stir-fry for 5-7 minutes.",
                   "Add soy sauce and stir well.",
                   "Serve hot over rice."
               ]),

        Recipe(id: "5", name: "Margherita Pizza", description: "A simple pizza topped with fresh tomatoes and basil.", notes: "Use homemade dough",
               ingredients: ["1 Pizza Dough", "100g Mozzarella Cheese", "2 Tomatoes", "Fresh Basil", "Olive Oil"],
               steps: [
                   "Preheat the oven to 250°C (482°F).",
                   "Roll out the pizza dough on a floured surface.",
                   "Top with sliced tomatoes and mozzarella.",
                   "Drizzle with olive oil and add fresh basil.",
                   "Bake for 10-12 minutes until crust is golden."
               ]),

        Recipe(id: "6", name: "Chocolate Chip Cookies", description: "Soft and chewy cookies loaded with chocolate chips.", notes: "fantastic!",
               ingredients: ["200g Flour", "100g Sugar", "100g Brown Sugar", "100g Butter", "1 Egg", "100g Chocolate Chips"],
               steps: [
                   "Preheat the oven to 180°C (350°F).",
                   "Cream together butter and sugars until light and fluffy.",
                   "Add the egg and mix well.",
                   "Stir in flour and chocolate chips.",
                   "Drop spoonfuls of dough onto a baking tray.",
                   "Bake for 10-12 minutes until golden."
               ]),

        Recipe(id: "7", name: "Pancakes", description: "Fluffy pancakes for a perfect breakfast.", notes: "the kids love these!",
               ingredients: ["150g Flour", "2 Eggs", "200ml Milk", "1 tbsp Baking Powder", "1 tbsp Sugar"],
               steps: [
                   "In a bowl, mix flour, baking powder, and sugar.",
                   "In another bowl, whisk eggs and milk.",
                   "Combine wet and dry ingredients until smooth.",
                   "Heat a non-stick pan and pour in batter.",
                   "Cook until bubbles form, then flip and cook until golden."
               ]),

        Recipe(id: "8", name: "Grilled Salmon", description: "Perfectly grilled salmon fillet.", notes: "so good",
               ingredients: ["2 Salmon Fillets", "1 Lemon", "2 tbsp Olive Oil", "Salt", "Pepper"],
               steps: [
                   "Preheat the grill to medium-high heat.",
                   "Drizzle salmon with olive oil and season with salt and pepper.",
                   "Place salmon on the grill skin-side down.",
                   "Grill for about 5-6 minutes on each side.",
                   "Serve with lemon wedges and asparagus."
               ]),

        Recipe(id: "9", name: "Beef Tacos", description: "Delicious tacos filled with seasoned beef.", notes: "taco tuesday hit!",
               ingredients: ["200g Ground Beef", "4 Taco Shells", "1 Onion", "2 tbsp Taco Seasoning", "Lettuce", "Tomato"],
               steps: [
                   "Brown ground beef in a skillet.",
                   "Add chopped onion and cook until translucent.",
                   "Stir in taco seasoning and cook for another 2 minutes.",
                   "Fill taco shells with beef and top with lettuce and tomato.",
                   "Serve with salsa if desired."
               ]),

        Recipe(id: "10", name: "Quinoa Salad", description: "A healthy salad with quinoa and vegetables.", notes: "didn't like this",
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
        let index = items.firstIndex(of: items.first(where: { $0.id == id })!)
        items.remove(at: index!)
    }
    
    
    func addItem(item : Item) {
        items.append(item)
    }
    
    func testRequest() {
//        Pick a number between 1 and 5
        var number = Int.random(in: 1...5)
        number = 1
        isLoading = true
        if let imageData = UIImage(named: "receipt\(number).png")?.pngData() {
            chatGPTAnalyzeImage(with: imageData, apiKey: apiKey, prompt: "[NO PROSE] [OUTPUT ONLY JSON] Based off this receipt, generate JSON corresponding to different paremeters the items in the list. It should look like [{itemName: name, amount: amount, unit: unit, price: price}], if you do not know the data for sure, give your best estimate. If an item is not a grocery, ignore it. If you can simplify something, please do so. For example, dont name something boneless, skinless, chicken breast, just name is chicken breast. Dont say organic onions, just say onions. For example, if you have a bag of rice, say it is rice. FOr units, never say packs of or bags of, give weights or volumes instead. Additionally, here is a list of items, if the item is already in the list, include the item id in the output. For example, if you see chicken breast in the list with an id of 123, the ouput should look like {itemName: chicken breast, amount: 1, unit: kg, price: 10, id: 123}. Ensure units stay consistent as well. Here are the items: \(items)")
            
        }
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
            "model": "gpt-4o-mini",
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
            "max_tokens": 300
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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   var content = message["content"] as? String {
                    // Remove the "```json" and "```" from the content
                    content = content.replacingOccurrences(of: "```json", with: "")
                    content = content.replacingOccurrences(of: "```", with: "")
                    content = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    
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
                                       let unit = item["unit"] as? String,
                                       let price = item["price"] as? Double {
                                        if let id = item["id"] as? String {
//                                           Find the index with that id and add the new ammount
                                            if let index = self.items.firstIndex(of: self.items.first(where: { $0.id == id })!) {
                                                self.items[index].amount += amount
                                                print("Updated item: \(self.items[index])")
                                            }
                                        } else {
                                            self.items.append(Item(name: itemName, amount: amount, unit: unit, price: price))
                                            print("Added item: \(self.items.last!)")
                                        }
                                        self.addedItems.append(Item(name: itemName, amount: amount, unit: unit, price: price))
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

}

