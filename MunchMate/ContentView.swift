//
//  ContentView.swift
//  MunchMate
//
//  Created by Matthew Dudzinski on 6/27/25.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [.init(\DietEntry.date, order: .forward)]) private var dietEntries: [DietEntry]
    @State var isFormPresented: Bool = false
    var body: some View {
            VStack {
                List {
                    Section("Recent Meals") {
                        ForEach(dietEntries, id: \.self) { entry in
                            NavigationLink(destination: DietExtendedView(entry: entry)) {
                                DietEntryRowView(entry: entry) {
                                    modelContext.delete(entry)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("MunchMate")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        isFormPresented.toggle()
                    } label: {
                        Label("Add Meal", systemImage: "plus")
                    }
                }
            }
            
            .sheet(isPresented: $isFormPresented, content: {
                DietLog()
            })

        }
    private func removeDietEntry(at indexSet: IndexSet) {
        for index in indexSet {
            let entry = dietEntries[index]
            modelContext.delete(entry)
        }
    }
}


#Preview {
    ContentView()
}
