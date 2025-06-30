//
//  MunchMateApp.swift
//  MunchMate
//
//  Created by Matthew Dudzinski on 6/26/25.
//

import SwiftUI
import SwiftData

@main
struct MunchMateApp: App {
    @Query(sort: [.init(\DietEntry.date, order: .forward)]) private var dietEntries: [DietEntry]
    @State private var gradientStart = 0.0
    @State private var gradientEnd = 1.0
    var body: some Scene {
        WindowGroup {
            TabView{
                NavigationStack {
                    ContentView()
                        .navigationTitle("MunchMate")
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                NavigationStack {
                    MealGraphView()
                        .navigationTitle("Meal Graph")
                }
                .tabItem{
                    Image(systemName: "chart.bar")
                    Text("Meal Graph")
                }
            }
            .tabViewStyle(.sidebarAdaptable)
        }
        .modelContainer(for: [DietEntry.self])
    }
    
}
