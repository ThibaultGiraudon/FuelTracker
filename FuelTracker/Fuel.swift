//
//  Fuel.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 22/08/2024.
//

import SwiftUI

struct Fuel: Codable, Identifiable {
    var id = UUID()
    var price: Double
    var date: Date
    var volume: Int
}
