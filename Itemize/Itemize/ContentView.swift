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
        case items
    }
    
    @State private var selectedTab: TabSelection = .recipes
    
    @State private var isShowingScanner: Bool = false
    
    
    @State private var scannedImages: [UIImage] = []
    
    
    func isSimulator() -> Bool {
           #if targetEnvironment(simulator)
           return true
           #else
           return false
           #endif
       }
    
    var body: some View {
        NavigationView {
            if appState.isLoading {
                VStack {
                    HStack {
                        Text("Processing Scan...")
                        ProgressView().progressViewStyle(.circular)
                    }
                }
            }
            else {
                switch selectedTab {
                case .recipes:
                    RecipesView()
                case .items:
                    ItemsView()
                }
            }
                
        }
        .sheet(isPresented: $isShowingScanner) {
              DocumentScannerView { scannedImages in
                  self.scannedImages = scannedImages
              }
          }
        .sheet(isPresented: $appState.showScannedItems) {
            VStack {
                Text("Here's what was added from your scan:")
                    .font(.headline)
                    .padding()
                List {
                    ForEach(appState.addedItems , id: \.id) { item in
                        ItemsListItemView(item: item, isEditingMode: .constant(false))
                    }
                }.frame(maxHeight: .infinity)
            }
            .toolbar {
                               ToolbarItem(placement: .cancellationAction) {
                                   Button("Done") {
                                       appState.showScannedItems = false
                                   }
                               }
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
                    Spacer()
                    Button() {
                        if isSimulator() {
                            appState.testRequest()
                        } else {
                            isShowingScanner = true
                        }
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
                    Spacer()
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
                .padding(.bottom, 15)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
