//
//  SettingsView.swift
//  FuelTracker
//
//  Created by Thibault Giraudon on 23/08/2024.
//

import MessageUI
import StoreKit
import SwiftUI

struct SettingsView: View {
    @ObservedObject var user: User
    @Environment(\.requestReview) var requestReview
    @State private var selectedUnit = "Gallons"
    @State private var showingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var alertMessage: String?
    @State private var alertIsPresented: Bool = false
    let units: [String] = ["Gallons", "Liters"]
    var body: some View {
        VStack {
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
            VStack {
                Picker("", selection: $selectedUnit, content: {
                    ForEach(units, id: \.self) {
                        Text($0)
                    }
                })
                .pickerStyle(.palette)
                .padding(10)
                .onChange(of: selectedUnit) {
                    user.setUnit(selectedUnit)
                }
                Text("SHOW GALLONS OR LITERS")
                        .font(.caption.bold())
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .shadow(radius: 5)
            )
            .padding()
            .offset(y: -80)
            .onAppear {
                if user.unit == "L" {
                    selectedUnit = "Liters"
                } else {
                    selectedUnit = "Gallons"
                }
            }
            Form {
                Section("In-App-Purchases") {
                    NavigationLink {
                        Text("Why is there a premium mode on this app ? Clearly I don't get it.")
                    } label: {
                        Image(systemName: "crown")
                        Text("Upgrade Premium")
                            .foregroundStyle(.black)
                    }
                    NavigationLink {
                        Text("You didn't pay anything, why are you here ?")
                    } label: {
                        Image(systemName: "goforward")
                        Text("Restore Purchases")
                            .foregroundStyle(.black)
                    }
                }
                Section("Spread the Word") {
                    Button {
                        requestReview()
                    } label: {
                        HStack {
                            Image(systemName: "star")
                            Text("Rate App")
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundStyle(.black)
                    }
                    ShareLink(item: URL(string: "https://github.com/ThibaultGiraudon")!) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share App")
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundStyle(.black)
                    }
                }
                Section("Support & Privacy") {
                    Button {
                        if MailView.canSendMail() {
                            showingMailView = true
                        } else {
                            alertMessage = "Your device is not configured to send emails."
                            alertIsPresented = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "envelope.badge")
                            Text("E-Mail us")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundStyle(.black)
                    }
                    .sheet(isPresented: $showingMailView) {
                        MailView(result: $mailResult)
                            .onDisappear {
                                if let result = mailResult {
                                    switch result {
                                    case .success(let mailResult):
                                        switch mailResult {
                                        case .sent:
                                            alertMessage = "Mail sent successfully!"
                                            alertIsPresented = true
                                        case .saved:
                                            alertMessage = "Mail saved as draft."
                                            alertIsPresented = true
                                        case .cancelled:
                                            alertMessage = "Mail cancelled."
                                            alertIsPresented = true
                                        case .failed:
                                            alertMessage = "Mail failed to send."
                                            alertIsPresented = true
                                        @unknown default:
                                            alertMessage = "Unknown error."
                                            alertIsPresented = true
                                        }
                                    case .failure(let error):
                                        alertMessage = error.localizedDescription
                                    }
                                }
                            }
                    }
                    .alert(isPresented: $alertIsPresented) {
                        Alert(title: Text("Mail Status"), message: Text(alertMessage!), dismissButton: .default(Text("OK")))
                    }
                    NavigationLink {
                        Text("Well, I'm not really sure what I'm supposed to put here, so I'll just say that I don't collect any data.")
                    } label: {
                        Image(systemName: "globe")
                        Text("Privacy Policy")
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .offset(y: -80)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(user: User())
    }
}
