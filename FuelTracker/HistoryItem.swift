//
//  HistoryItem.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 22/08/2024.
//

import SwiftUI

struct HistoryItem: View {
    var user: User
    var fuel: Fuel
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL dd, yyyy"
        return formatter
    }()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dateFormatter.string(from: fuel.date))
                Text("PRICE: $\(fuel.price, specifier: "%.2f")/L")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(fuel.volume)")
                Text("\(user.unit)")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            Image(systemName: "fuelpump.fill")
                .font(.system(size: 30))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    HistoryItem(user: User(), fuel: Fuel(price: 4.95, date: Date(), volume: 15))
}
