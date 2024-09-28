//
//  RecipeModel.swift
//  Itemize
//
//  Created by Seth Lenhof on 9/28/24.
//

import Foundation

struct Recipe: Hashable {
    var id : String = UUID().uuidString
    var name: String
    var description: String
    var details: String
    var ingredients: [String]
    var steps: [String]
}
