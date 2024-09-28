//
//  ItemModel.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import Foundation


struct Item : Hashable {
    var ID : String = UUID().uuidString
    var name : String = ""
    var amount : Int = 0
    var unit : String = ""
    var price : Double = 0
}
