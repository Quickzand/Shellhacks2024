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
        case recipes
        case scan
        case items
    }
    
    @State private var selectedTab: TabSelection = .recipes
    
    @State private var isShowingScanner: Bool = false
    @State private var scannedImages: [UIImage] = []
    
    
    var body: some View {
        NavigationView {
                switch selectedTab {
                case .recipes:
                    RecipesView()
                case .items:
                    ItemsView()
                }
                
        }
        .sheet(isPresented: $isShowingScanner) {
              DocumentScannerView { scannedImages in
                  self.scannedImages = scannedImages
              }
          }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack(alignment:.bottom) {
                    Spacer()
                    Button() {
                        selectedTab = .recipes
                    } label: {
                        VStack (spacing: 10) {
                            Image(systemName: "list.bullet.rectangle")
                            Text("Reipies")
                        }
                    }.foregroundStyle(selectedTab == .recipes ? Color.blue : Color.primary)
                    
                    Button() {
                        isShowingScanner = true
                    } label: {
                        VStack (spacing: 10){
                            Image(systemName: "barcode.viewfinder")
                                .background(Circle().fill(Color.orange).frame(width:75 , height: 75))
                                .foregroundStyle( Color.white)
                                .font(.system(size: 40))
                            Text("Scan")
                        }
                    }.foregroundStyle(Color.primary)
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
