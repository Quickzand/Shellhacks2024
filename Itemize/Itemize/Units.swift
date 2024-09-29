//
//  Units.swift
//  Itemize
//
//  Created by Seth Lenhof on 9/28/24.
//

import Foundation

enum Units : String, CaseIterable, Identifiable {
    case count = "Count"
    case teaspoon = "Teaspoon (tsp)"
    case tbsp = "Tablespoon (tbsp)"
    case floz = "Fluid Ounce (fl oz)"
    case cup = "Cup"
    case pint = "Pint"
    case quart = "Quart"
    case ounce = "Ounce"
    case lb = "Pound (lb)"
    
    var id: String { rawValue }
    
    static func from(caseName: String) -> Units? {
           return Units.allCases.first { "\($0)" == caseName }
       }
}
