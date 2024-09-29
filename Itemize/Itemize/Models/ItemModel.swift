//
//  ItemModel.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import Foundation

struct Item : Hashable, Identifiable {
    var id : String = UUID().uuidString
    var name : String = ""
    var amount : Double = 0
    var unit : String = ""
    var acquired = false
    var recipeAmount : Double = 0
    var emoji : String = ""
}
