//
//  AddFuelView.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 22/08/2024.
//

import SwiftUI

struct AddFuelView: View {
    var user: User
    @Binding var showingAddFuel: Bool
    @State private var odometer: Int = 0
    @State private var price: Double = 0.0
    @State private var date: Date = Date()
    @State private var volume: Int = 0
    @FocusState private var keyboardFocused: Bool
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL dd, YYYY"
        return formatter
    }()
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    showingAddFuel = false
                }
            VStack {
                HStack(spacing: 0) {
                    Image(systemName: "fuelpump.fill")
                    Text("Log")
                    Text("Fuel")
                        .bold()
                }
                .font(.title)
                .foregroundStyle(.black)
                HStack {
                    VStack(alignment: .leading) {
                        Text("ODOMETER")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                        TextField("\(user.lastOdometer)", value: $odometer, format: .number)
                    }
                    Divider()
                        .frame(height: 35)
                    VStack(alignment: .trailing) {
                        Text("LAST ODOMETER")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                        Text("\(user.lastOdometer)")
                    }
                }
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        Text("COST / \(user.unit)")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                        TextField("", value: $price, format: .number)
                            .focused($keyboardFocused)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    keyboardFocused = true
                                }
                            }
                    }
                    Divider()
                        .frame(height: 35)
                    VStack(alignment: .center) {
                        Text("\(user.unit)")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                        TextField("", value: $volume, format: .number)
                            .multilineTextAlignment(.center)
                    }
                    Divider()
                        .frame(height: 35)
                    VStack(alignment: .trailing) {
                        Text("TOTAL COST")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                        Text("\(price * Double(volume), specifier: "%.2f")")
                    }
                }
                Divider()
                DatePicker("\(dateFormatter.string(from: date))", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                Divider()
                Button {
                    user.addFuel(Fuel(price: price, date: date, volume: volume))
                    user.setOdometer(odometer)
                    showingAddFuel = false
                } label: {
                    Text("Log Fuel")
                        .bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(price == 0 || volume == 0 ? .gray : .blue)
                        )
                }
                .disabled(price == 0 || volume == 0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
            )
            .padding()
        }
    }
}

#Preview {
    AddFuelView(user: User(), showingAddFuel: .constant(true))
}
