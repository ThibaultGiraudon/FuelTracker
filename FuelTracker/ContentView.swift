//
//  ContentView.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 22/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var user = User()
    @State private var activeTab: Tab = .Dashboard
    @State private var showingAddFuel: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            if activeTab == .Dashboard {
                DashboardView(user: user, showingAddFuel: $showingAddFuel)
            } else if activeTab == .History {
                HistoryView(user: user, showingAddFuel: $showingAddFuel)
            } else {
                SettingsView(user: user)
            }
            Rectangle()
                .ignoresSafeArea()
                .frame(height: 200)
                .offset(y: 100)
                .foregroundStyle(Color.white)
                .blur(radius: 50)
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    HStack {
                        Image(systemName: tab.rawValue)
                            .font(.title)
                        if activeTab == tab {
                            Text(tab.name)
                        }
                    }
                    .padding(5)
                    .foregroundColor(tab == activeTab ? .white : .gray)
                    .onTapGesture {
                        activeTab = tab
                        user.loadTotal()
                    }
                    .background(
                        Capsule()
                            .fill(tab == activeTab ? .blue : Color.clear)
                    )
                    .padding()
                }
            }
        }
        .overlay {
            if showingAddFuel {
                AddFuelView(user: user, showingAddFuel: $showingAddFuel)
            }
        }
    }
}

#Preview {
    ContentView()
}
