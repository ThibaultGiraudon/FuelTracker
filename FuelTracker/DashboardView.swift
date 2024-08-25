//
//  DashboardView.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 22/08/2024.
//

import SwiftUI
import Charts

extension Date {
    func stripped() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}

struct DashboardView: View {
    @ObservedObject var user: User
    @Binding var showingAddFuel: Bool
    @State private var date: Date = Date()
    var body: some View {
        VStack {
            ZStack {
                ZStack() {
                    RoundedRectangle(cornerRadius: 50)
                        .padding(5)
                        .foregroundStyle(.cyan)
                    VStack {
                        HStack(spacing: 0) {
                            Image(systemName: "fuelpump.fill")
                            Text("Fuel")
                            Text("Tracker")
                                .bold()
                        }
                        .foregroundStyle(.white)
                        .font(.title)
                        Chart {
                            ForEach(generateMonths(back: 12, from: date), id: \.self) { month in
                                BarMark(
                                    x: .value("Month", month, unit: .month),
                                    y: .value("Price", user.getPrice(for: month))
                                )
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .month, count: 1)) {
                                AxisValueLabel(format: .dateTime.month(), centered: true)
                                    .foregroundStyle(.white)
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .automatic) {
                                AxisTick()
                                    .foregroundStyle(.white)
                                AxisGridLine()
                                    .foregroundStyle(.white)
                                AxisValueLabel()
                                    .foregroundStyle(.white)
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width > 0 {
                                        date -= 86400 * 30 * 6
                                    }
                                    else if value.translation.width < 0 {
                                        if date.stripped() < Date().stripped() {
                                            date += 86400 * 30 * 6
                                        }
                                        else {
                                            date = Date()
                                        }
                                    }
                                }
                        )
                        .frame(height: UIScreen.main.bounds.height / 6)
                        .padding(.horizontal)
                        .foregroundStyle(.white)
                        Text("\(getDateInterval(for: date))")
                            .foregroundStyle(.white)
                            .font(.title.bold())
                        Text("Monthly Fuel Cost")
                            .foregroundStyle(.white)
                            .font(.footnote.bold())
                            
                    }
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
                .offset(y: 180)
            }
//            .ignoresSafeArea()
            VStack {
                HStack {
                    VStack {
                        Image(systemName: "car.fill")
                            .font(.title)
                        Text("\(user.avgDistance, specifier: "%.1f")")
                            .font(.largeTitle)
                        Text("AVG KM/\(user.unit)")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                        .frame(height: 150)
                    VStack {
                        Image(systemName: "fuelpump.fill")
                            .font(.title)
                        Text("\(user.avgVolume, specifier: "%.2f")")
                            .font(.largeTitle)
                        Text("AVG \(user.unit)")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                Divider()
                    .frame(width: 300)
                HStack {
                    VStack {
                        Image(systemName: "dollarsign.square.fill")
                            .font(.title)
                        Text("$\(user.avgPrice, specifier: "%.2f")")
                            .font(.largeTitle)
                        Text("COST PER \(user.unit)")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                        .frame(height: 150)
                    VStack {
                        Image(systemName: "calendar")
                            .font(.title)
                        Text("$\(user.avgCost, specifier: "%.1f")")
                            .font(.largeTitle)
                        Text("AVG COST")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    func getDateInterval(for date: Date) -> String { 
        let dates = generateMonths(back: 6, from: date)
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY"
            return formatter
        }()
        var interval: String = formatter.string(from: dates.last!)
        if Calendar.current.component(.year, from: dates.first!) != Calendar.current.component(.year, from: dates.last!) {
            interval += "-" + formatter.string(from: dates.first!)
        } else {
            
        }
        return interval
    }
    
    func generateMonths(back past: Int, from date: Date) -> [Date] {
        var month: [Date] = []
        for i in 0..<past {
            let date = Calendar.current.date(byAdding: .month, value: -i, to: date)!
            month.append(date)
        }
        return month
    }
    
}

#Preview {
    DashboardView(user: User(), showingAddFuel: .constant(false))
}
