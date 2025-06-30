//
//  DietEntry.swift
//  MunchMate
//
//  Created by Matthew Dudzinski on 6/26/25.
//


import SwiftUI
import SwiftData


struct DietLog: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var foods: [DietEntry.FoodItem] = []
    @State private var newFoodName: String = ""
    @State private var newFoodQuantity: String = ""
    @State private var mealType: String = ""
    @State private var logDate: Date = Date()
    @State private var dietNotes: String = ""
    @State private var showAlert = false
    @State private var alertReason = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Food Entry Section
            ZStack {
                VStack(alignment: .leading) {
                    Text("Foods eaten")
                        .font(.headline)
                    TextField("Food name (required)", text: $newFoodName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Quantity (optional)", text: $newFoodQuantity)
                        .textFieldStyle(.roundedBorder)
                    Button(action: {
                        let trimmedName = newFoodName.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedName.isEmpty {
                            let food = DietEntry.FoodItem(name: trimmedName,
                                                          quantity: newFoodQuantity.isEmpty ? nil : newFoodQuantity)
                            foods.append(food)
                            newFoodName = ""
                            newFoodQuantity = ""
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.accentColor)
                            Text("Add Food")
                        }
                    }
                    
                    if !foods.isEmpty {
                        ForEach(Array(foods.enumerated()), id: \.0) { idx, food in
                            VStack(alignment: .leading) {
                                Text(food.name).font(.body)
                                if let qty = food.quantity, !qty.isEmpty {
                                    Text("Quantity: \(qty)").font(.caption)
                                }
                                if let notes = food.notes, !notes.isEmpty {
                                    Text("Notes: \(notes)").font(.caption).foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                        Button(action: {
                            foods.removeAll()
                        }) {
                            HStack {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                Text("Clear all foods")
                            }
                        }
                    }
                }
            }
            .frame(minHeight: 180)
            .padding(.bottom)
            
            // Meal Type Entry
            TextField("Meal Type", text: $mealType)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            // Date Picker
            DatePicker("Meal Time", selection: $logDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(.bottom)
            
            // Notes Section
            VStack(alignment: .leading) {
                Text("Notes")
                    .font(.headline)
                TextEditor(text: $dietNotes)
                    .frame(height: 80)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2)))
            }
            .padding(.bottom)
            
            // Submit Button
            HStack{
                Button("Submit") {
                    if foods.isEmpty {
                        showAlert = true
                        alertReason = "Please enter at least one food item."
                    } else if dietNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        showAlert = true
                        alertReason = "Please enter some notes."
                    } else {
                        addItem()
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel, action: {
                    dismiss()
                })
            }
            .alert(alertReason, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Document Foods Eaten")
    }
    
    func addItem() {
        let newItem = DietEntry(date: logDate, mealType: mealType, foods: foods, notes: dietNotes)
        
        modelContext.insert(newItem)
    }
}

