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
        case groceries
        case items
        case settings
    }
    
    @State private var selectedTab: TabSelection = .recipes
    
    @State private var isShowingScanner: Bool = false
    
    
    @State private var scannedImages: [UIImage] = []
    
    
    @State private var loadingViewOpacity : Double = 0.0
    
    @State private var currentNewItemIndex: Int = 0
    
    
    @State private var showingSplashScreen : Bool = true
    
    
    func isSimulator() -> Bool {
           #if targetEnvironment(simulator)
           return true
           #else
           return false
           #endif
       }
    
    var body: some View {
        if showingSplashScreen {
            LoadingView(baseMessage: "").onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    withAnimation {
                                        showingSplashScreen = false
                                    }
                                }
            }
        }
        else {
            NavigationView {
                
                if appState.isLoading {
                    LoadingView()
                        .opacity(loadingViewOpacity)
                        .onAppear {
                            loadingViewOpacity = 0.0
                            withAnimation(.easeInOut(duration: 0.5)) {
                                loadingViewOpacity = 1.0
                            }
                        }
                }
                else {
                    switch selectedTab {
                    case .recipes:
                        RecipesView()
                    case .groceries:
                        GroceriesView()
                    case .items:
                        ItemsView()
                    case .settings:
                        SettingsView()
                        
                    }
                    
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                DocumentScannerView { scannedImages in
                    self.scannedImages = scannedImages
                    appState.receiptScanRequest(image: scannedImages[0])
                }
            }
            .sheet(isPresented: $appState.shouldShowSheet) {
                VStack {
                    Text("Here's what was added from your scan:")
                        .font(.headline)
                        .padding()
                    
                    // State variable to track the current page
                    
                    
                    TabView(selection: $currentNewItemIndex) {
                        ForEach(Array(appState.addedItems.enumerated()), id: \.element.id) { index, item in
                            AddedItemView(item: item)
                                .tag(index) // Tag each view with its index
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    
                    Button {
                        // Go to the next page
                        withAnimation {
                            
                            if (currentNewItemIndex >= (appState.addedItems.count - 1 )) {
                                //                                Go through each index of added items
                                for item in appState.addedItems {
                                    if self.appState.items.contains(where: { $0.id == item.id }) {
                                        if let index = self.appState.items.firstIndex(of: self.appState.items.first(where: { $0.id == item.id })!) {
                                            self.appState.items[index].amount += item.amount
                                            print("Updated item: \(self.appState.items[index])")
                                        }
                                    }
                                    else if self.appState.items.contains(where: {$0.name == item.name}) {
                                        if let index = self.appState.items.firstIndex(of: self.appState.items.first(where: { $0.name == item.name })!) {
                                            self.appState.items[index].amount += item.amount
                                            print("Updated item: \(self.appState.items[index])")
                                        }
                                    }
                                    else {
                                        self.appState.items.append(Item(name: item.name, amount: item.amount, unit: item.unit))
                                        print("Added item: \(self.appState.items.last!)")
                                    }
                                }
                                
                                appState.showScannedItems = false
                                currentNewItemIndex = 0
                            }
                            else {
                                currentNewItemIndex += 1
                            }
                        }
                    }
                    label: {
                        Text(currentNewItemIndex < appState.addedItems.count - 1 ? "Next" : "Done")
                            .font(.system(size:25, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(Color.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding()
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            appState.showScannedItems = false
                        }
                    }
                }
                .background(
                    GeometryReader { geometry in
                        let columns = Int(geometry.size.width / 50)
                        let rows = Int(geometry.size.height / 50)
                        
                        VStack {
                            ForEach(0..<rows, id: \.self) { row in
                                HStack {
                                    ForEach(0..<columns, id: \.self) { column in
                                        Text(currentNewItemIndex < appState.addedItems.count ?  appState.addedItems[currentNewItemIndex].emoji : "")
                                            .font(.system(size: 30))
                                    }
                                }
                            }
                        }
                        //                            pick a random rotation
                        .rotationEffect(Angle(degrees: Double.random(in: 0...360) ))
                        .scaleEffect(2.5)
                    }
                        .opacity(0.1) // Adjust the opacity to make the emoji subtle
                )
            }
            
            
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    HStack(alignment:.bottom) {
                        Spacer()
                        Button() {
                            selectedTab = .recipes
                        } label: {
                            VStack (spacing: 10) {
                                Image(systemName: "cooktop")
                                Text("Recipes")
                            }
                        }.foregroundStyle(selectedTab == .recipes ? Color.blue : Color.primary)
                        Spacer()
                        Button() {
                            selectedTab = .groceries
                        } label: {
                            VStack (spacing: 10) {
                                Image(systemName: "cart.badge.plus")
                                
                                Text("Groceries")
                            }
                        }.foregroundStyle(selectedTab == .groceries ? Color.blue : Color.primary)
                        Spacer()
                        
                        Button() {
                            if(appState.isLoading) {
                                return
                            }
                            if isSimulator() {
                                appState.testRequest()
                            } else {
                                isShowingScanner = true
                            }
                        } label: {
                            VStack (spacing: 0){
                                ZStack {
                                    Circle().fill(Color.orange).frame(width:75 , height: 75)
                                        .shadow(color: .gray, radius: 1, x: 0, y: 4)
                                    Image(systemName: "barcode.viewfinder")
                                        .foregroundStyle( Color.white)
                                        .font(.system(size: 30))
                                }
                                //                            Text("Scan")
                            }
                        }.foregroundStyle(Color.primary)
                            .padding(.horizontal, 10)
                            .disabled(appState.isLoading)
                        Spacer()
                        Button() {
                            selectedTab = .items
                        } label: {
                            VStack (spacing: 10){
                                Image(systemName: "list.bullet.rectangle.portrait")
                                Text("Items")
                            }
                        }.foregroundStyle(selectedTab == .items ? Color.blue : Color.primary)
                        Spacer()
                        Button() {
                            selectedTab = .settings
                        } label: {
                            VStack (spacing: 10){
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                        }.foregroundStyle(selectedTab == .settings ? Color.blue : Color.primary)
                        Spacer()
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal)
                    .font(.system(size: 12))
                }
            }
        }
    }
}


struct AddedItemView : View {
    @State var item : Item
    @EnvironmentObject var appState : AppState

    static let formatter = NumberFormatter()

    var binding: Binding<String> {
        .init(get: {
            "\(self.item.amount)"
        }, set: {
            self.item.amount = Double($0) ?? self.item.amount
        })
    }
    
    var body : some View {
        VStack {
            Text(item.name)
                .font(.headline)
                .textCase(.uppercase)
                .multilineTextAlignment(.leading)
            HStack {
                TextField("Amount:", text: binding)
                    .keyboardType(.numberPad)
                Stepper("", onIncrement: {
                    self.item.amount += 1
                }, onDecrement: {
                    self.item.amount -= 1
                })
            }
            .font(.subheadline)
            
            HStack {
                TextField("Unit:", text: $item.unit)
            }
            .font(.subheadline)
            
            
        }.onChange(of: item.amount) {
            var index = self.appState.addedItems.firstIndex(where: { $0.id == item.id }) ?? 0
            appState.addedItems[index] = self.item
        }
        .onChange(of: item.unit) {
            var index = self.appState.addedItems.firstIndex(where: { $0.id == item.id }) ?? 0
            appState.addedItems[index] = self.item
        }
        .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .padding(.horizontal)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
