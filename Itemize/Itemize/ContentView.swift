//
//  ContentView.swift
//  Itemize
//
//  Created by Matthew Sand on 9/28/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    enum TabSelection  {
        case recipies
        case scan
        case items
    }
    
    @State private var selectedTab: TabSelection = .recipies
    
    
    var body: some View {
        NavigationView {
                switch selectedTab {
                case .recipies:
                    RecipesView()
                case .scan:
                    ScanView()
                case .items:
                    ItemsView()
                }
                
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack(alignment:.bottom) {
                    Spacer()
                    Button() {
                        selectedTab = .recipies
                    } label: {
                        VStack (spacing: 10) {
                            Image(systemName: "list.bullet.rectangle")
                            Text("Reipies")
                        }
                    }.foregroundStyle(selectedTab == .recipies ? Color.blue : Color.primary)
                    
                    Button() {
                        selectedTab = .scan
                    } label: {
                        VStack (spacing: 10){
                            Image(systemName: "barcode.viewfinder")
                                .background(Circle().fill(Color.orange).frame(width:75 , height: 75))
                                .foregroundStyle(selectedTab == .scan ? Color.blue : Color.white)
                                .font(.system(size: 40))
                            Text("Scan")
                        }
                    }.foregroundStyle(selectedTab == .scan ? Color.blue : Color.primary)
                    .padding(.horizontal, 10)
                    
                    Button() {
                        selectedTab = .items
                    } label: {
                        VStack (spacing: 10){
                            Image(systemName: "cart.badge.plus")
                            Text("Items")
                        }
                    }.foregroundStyle(selectedTab == .items ? Color.blue : Color.primary)
                    Spacer()
                }
            }
        }
        .environmentObject(AppState())
    }
}

#Preview {
    ContentView()
}
