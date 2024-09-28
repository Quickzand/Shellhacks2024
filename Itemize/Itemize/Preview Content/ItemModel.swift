//
//  ItemModel.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import Foundation


struct Item : Hashable {
    var ID : String
    var name : String
    var description : String
    var amount : Int
    var unit : String
    var price : Double
}
