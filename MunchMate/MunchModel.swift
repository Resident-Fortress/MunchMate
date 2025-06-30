//
//  MunchModel.swift
//  MunchMate
//
//  Created by Matthew Dudzinski on 6/26/25.
//

import SwiftData
import Foundation

@Model
class DietEntry: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mealType: String
    var foods: [FoodItem]
    var notes: String?
    
    init(date: Date, mealType: String, foods: [FoodItem], notes: String? = nil) {
        self.id = UUID()
        self.date = date
        self.mealType = mealType
        self.foods = foods
        self.notes = notes
    }
    
    
    struct FoodItem: Codable, Hashable {
        var name: String
        var quantity: String? // "1 cup", etc.
        var notes: String? // Optional notes about effect
    }
    
    struct MealsPerDay: Identifiable {
        let id = UUID()
        let date: Date
        let count: Int
    }

}
