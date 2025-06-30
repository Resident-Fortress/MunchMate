//
//  MealGraphView.swift
//  MunchMate
//
//  Created by Matthew Dudzinski on 6/27/25.
//

import Charts
import SwiftUI
import SwiftData

struct MealsPerDay: Identifiable {
    let date: Date
    let count: Int
    var id: Date { date }
}

struct InfoSquare: View {
    let title: String
    let value: String
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(10)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.indigo, .cyan]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        .frame(minWidth: 70, minHeight: 70)
    }
}

struct MealGraphView: View {
    @Query(sort: [.init(\DietEntry.date, order: .forward)]) private var dietEntries: [DietEntry]
        
    var body: some View {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let monthAgo = calendar.date(byAdding: .day, value: -30, to: today) ?? today
        let weekAgo = calendar.date(byAdding: .day, value: -6, to: today) ?? today
        let grouped = Dictionary(grouping: dietEntries) { entry in
            calendar.startOfDay(for: entry.date)
        }
        let mealsPerDay = grouped.map { (date, entries) in
            MealsPerDay(date: date, count: entries.count)
        }.sorted { $0.date < $1.date }
        
        let monthMeals = mealsPerDay.filter { $0.date >= monthAgo && $0.date <= today }
        let weekMeals = mealsPerDay.filter { $0.date >= weekAgo && $0.date <= today }
        
        ScrollView {
            MealSummaryHeader(monthMeals: monthMeals, weekMeals: weekMeals)
            
            VStack(alignment: .leading, spacing: 24) {
                MonthlyMealChartSection(monthMeals: monthMeals)
                WeeklyMealChartSection(weekMeals: weekMeals)
            }
            .padding(.vertical)
        }
        .navigationTitle("Meal Graph")
    }
}

struct MealSummaryHeader: View {
    let monthMeals: [MealsPerDay]
    let weekMeals: [MealsPerDay]
    
    var body: some View {
        HStack(spacing: 8){
            Text("You've eaten \(monthMeals.reduce(0) { $0 + $1.count }) meals in a month")
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue, .teal]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                .frame(minWidth: 70, minHeight: 70)
                .bold()
                .font(.largeTitle)
            Text("You've eaten \(weekMeals.reduce(0) { $0 + $1.count }) meals in a week")
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue, .teal]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                .frame(minWidth: 70, minHeight: 70)
                .bold()
                .font(.largeTitle)
        }
        .padding(.horizontal)
    }
}

struct MonthlyMealChartSection: View {
    let monthMeals: [MealsPerDay]
    
    var body: some View {
        Text("Past Month")
            .font(.title2).fontWeight(.semibold)
            .foregroundStyle(.primary)
            .padding(.horizontal)
            .shadow(color: .accentColor.opacity(0.16), radius: 3, y: 1)
        HStack(alignment: .top, spacing: 16) {
            Chart(monthMeals) { item in
                BarMark(
                    x: .value("Date", item.date),
                    y: .value("Meals", item.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(12)
                .annotation(position: .top) {
                    if item.count > 0 {
                        Text("\(item.count)")
                            .bold()
                            .foregroundColor(.primary)
                            .padding(4)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                }
            }
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.thinMaterial)
                    .shadow(radius: 6, y: 2)
            )
            .padding(.horizontal, 18)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 5)) { value in
                    AxisValueLabel() {
                        if let dateValue = value.as(Date.self) {
                            Text(dateValue, format: .dateTime.month(.abbreviated).day())
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .padding(.vertical, 8)
            .frame(minWidth: 0, maxWidth: .infinity)
            VStack(spacing: 10) {
                InfoSquare(title: "Total", value: "\(monthMeals.reduce(0) { $0 + $1.count })")
                InfoSquare(title: "Average", value: String(format: "%.1f", (Double(monthMeals.reduce(0){$0 + $1.count}) / Double(monthMeals.count == 0 ? 1 : monthMeals.count))))
                InfoSquare(title: "Max", value: "\(monthMeals.map { $0.count }.max() ?? 0)")
                InfoSquare(title: "Min", value: "\(monthMeals.map { $0.count }.min() ?? 0)")
            }
            .padding(.trailing, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
        )
        .padding(.horizontal)
    }
}

struct WeeklyMealChartSection: View {
    let weekMeals: [MealsPerDay]
    
    var body: some View {
        Text("Past 7 Days")
            .font(.title3).fontWeight(.semibold)
            .foregroundStyle(.primary)
            .padding(.horizontal)
            .shadow(color: .accentColor.opacity(0.16), radius: 3, y: 1)
        HStack(alignment: .top, spacing: 16) {
            Chart(weekMeals) { item in
                BarMark(
                    x: .value("Date", item.date),
                    y: .value("Meals", item.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(12)
                .annotation(position: .top) {
                    if item.count > 0 {
                        Text("\(item.count)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(4)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                }
            }
            
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.thinMaterial)
                    .shadow(radius: 6, y: 2)
            )
            .padding(.horizontal, 18)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel() {
                        if let dateValue = value.as(Date.self) {
                            Text(dateValue, format: .dateTime.weekday(.abbreviated))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .padding(.vertical, 8)
            .frame(minWidth: 0, maxWidth: .infinity)
            VStack(spacing: 10) {
                InfoSquare(title: "Total", value: "\(weekMeals.reduce(0) { $0 + $1.count })")
                InfoSquare(title: "Average", value: String(format: "%.1f", (Double(weekMeals.reduce(0){$0 + $1.count}) / Double(weekMeals.count == 0 ? 1 : weekMeals.count))))
                InfoSquare(title: "Max", value: "\(weekMeals.map { $0.count }.max() ?? 0)")
                InfoSquare(title: "Min", value: "\(weekMeals.map { $0.count }.min() ?? 0)")
            }
            .padding(.trailing, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
        )
        .padding(.horizontal)
    }
}

