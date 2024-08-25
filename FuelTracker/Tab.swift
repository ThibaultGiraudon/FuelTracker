//
//  Tab.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 22/08/2024.
//

import Foundation

enum Tab: String, CaseIterable {
    case Dashboard = "square.split.2x2.fill"
    case History = "clock.fill"
    case Settings = "gear"
    
    var name: String {
        String(describing: self)
    }
}
