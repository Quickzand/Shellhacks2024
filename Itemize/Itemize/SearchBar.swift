//
//  SearchBar.swift
//  Itemize
//
//  Created by Seth Lenhof on 9/28/24.
//

import SwiftUI


struct SearchBar: View {
    @Binding var text: String // Binding to the search text

    var body: some View {
        HStack {
            TextField("Search recipes...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        Spacer()
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.top, 10)
    }
}
