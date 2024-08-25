//
//  User.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 22/08/2024.
//

import Foundation

struct Month: Codable, Identifiable {
    var id = UUID()
//    var name: String
    var date: Date
    var totalPrice: Double
    var totalVolume: Int
}

func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
    let calendar = Calendar.current
    
    let components1 = calendar.dateComponents([.year, .month], from: date1)
    let components2 = calendar.dateComponents([.year, .month], from: date2)
    
    return components1.year == components2.year && components1.month == components2.month
}

class User: ObservableObject {
    @Published var name: String = ""
    @Published var firstLaunch: Bool = true
    @Published var history: [Fuel] = [
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 2, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 3, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 4, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 5, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 6, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 7, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 8, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 9, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 10, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 11, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 12, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 13, volume: Int.random(in: 40...50)),
        Fuel(price: Double(Int.random(in: 150...200)) / 100.0, date: Date() - 86400 * 30 * 14, volume: Int.random(in: 40...50)),
    ]
    @Published var firstOdometer: Int = 127568
    @Published var lastOdometer: Int = 151487
    @Published var totalFuel: Int = 0
    @Published var totalCost: Double = 0
    @Published var unit: String = "L"
    @Published var months: [Month] = []
    @Published var avgPrice: Double = 0.0
    @Published var avgVolume: Double = 0
    @Published var avgCost: Double = 0.0
    @Published var avgDistance: Double = 0.0
    
    
    init() {
        loadTotal()
    }
    
    func setUnit(_ unit: String) {
        if unit == "Gallons" {
            self.unit = "GAL"
        } else {
            self.unit = "L"
        }
    }
    
    func setOdometer(_ odometer: Int) {
        lastOdometer = odometer
    }
    
    func getPrice(for date: Date) -> Double {
        for month in months {
            if isSameMonth(month.date, date) {
                return month.totalPrice
            }
        }
        return 0.0
    }
    
    func addFuel(_ fuel: Fuel) {
        history.append(fuel)
        loadTotal()
    }
    
    func loadTotal() {
        totalCost = 0
        totalFuel = 0
        avgCost = 0.0
        avgPrice = 0.0
        avgVolume = 0
        avgDistance = 0.0
        for fuel in history {
            totalFuel += fuel.volume
            totalCost += fuel.price * Double(fuel.volume)
            avgPrice += fuel.price
        }
        
        avgCost = totalCost / Double(history.count)
        
        avgPrice = avgPrice / Double(history.count)
        
        avgVolume = Double(totalFuel) / Double(history.count)
        
        avgDistance = Double(lastOdometer - firstOdometer) / Double(history.count)
        
        months = []
        var monthPrice: Double = 0
        var monthVolume: Int = 0
        var currentDate: Date = Date()
        var previousDate: Date = history.sorted(by: { $0.date < $1.date }).first?.date ?? Date()
        for fuel in history.sorted(by: { $0.date < $1.date }) {
            currentDate = fuel.date
            if !isSameMonth(currentDate, previousDate) {
                let month: Month = Month(date: previousDate, totalPrice: monthPrice, totalVolume: monthVolume)
                months.append(month)
                monthPrice = 0
                monthVolume = 0
                previousDate = currentDate
            }
            
            monthPrice += fuel.price * Double(fuel.volume)
            monthVolume += fuel.volume
            
            if fuel.id == history.sorted(by: { $0.date < $1.date }).last!.id {
                let month: Month = Month(date: previousDate, totalPrice: monthPrice, totalVolume: monthVolume)
                months.append(month)
            }
        }
    }
}
