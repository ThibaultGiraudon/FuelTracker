//
//  HistoryView.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 22/08/2024.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var user: User
    @Binding var showingAddFuel: Bool
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ZStack() {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(height: 150)
                        .padding(5)
                        .foregroundStyle(.cyan)
                    HStack(spacing: 0) {
                        Image(systemName: "fuelpump.fill")
                        Text("Fuel")
                        Text("Tracker")
                            .bold()
                    }
                    .foregroundStyle(.white)
                    .font(.title)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(user.totalFuel)")
                            .font(.title2)
                        Text("TOTAL \(user.unit)")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    Divider()
                        .frame(height: 20)
                        .padding()
                    VStack(alignment: .leading) {
                        Text("$\(user.totalCost, specifier: "%.2f")")
                            .font(.title2)
                        Text("TOTAL COST")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    .padding(.trailing, 50)
                    
                    Button {
                        showingAddFuel = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20).bold())
                            .foregroundStyle(.white)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.black)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                        .shadow(radius: 5)
                )
                .offset(y: 30)
            }
            ScrollView(showsIndicators: false) {
                ForEach(user.history.sorted(by: { $0.date > $1.date }), id: \.id) { fuel in
                    HistoryItem(user: user, fuel: fuel)
                        .padding(.vertical, 5)
                }
            }
            .padding(.top, 30)
        }
    }
}

#Preview {
    HistoryView(user: User(), showingAddFuel: .constant(false))
}
