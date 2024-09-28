//
//  ItemizeApp.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import SwiftUI

@main
struct ItemizeApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
