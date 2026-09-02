//
//  MechanicDetailView.swift
//  InstantMechanic
//
//  Mechanic Details screen.
//

import SwiftUI

struct MechanicDetailView: View {
    let mechanic: Mechanic
    @State private var showingRequestForm = false
    @State private var showingConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                Divider()

                InfoRow(icon: "mappin.and.ellipse", title: "Address", value: mechanic.displayAddress)
                InfoRow(icon: "clock", title: "Working Hours", value: mechanic.displayWorkingHours)
                InfoRow(icon: "phone", title: "Phone Number", value: mechanic.displayPhoneNumber)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Available Services")
                        .font(.headline)
                    FlowServicesView(services: mechanic.services)
                }

                Spacer(minLength: 24)

                Button {
                    showingRequestForm = true
                } label: {
                    Text("Request Service")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
        .navigationTitle(mechanic.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingRequestForm) {
            NavigationStack {
                RequestServiceView(mechanic: mechanic) {
                    // Close the form, then present the confirmation screen.
                    showingRequestForm = false
                    showingConfirmation = true
                }
            }
        }
        .sheet(isPresented: $showingConfirmation) {
            NavigationStack {
                ConfirmationView(mechanicName: mechanic.name)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(mechanic.name)
                .font(.title2).bold()
            HStack(spacing: 12) {
                Label(String(format: "%.1f", mechanic.rating), systemImage: "star.fill")
                    .foregroundStyle(.orange)
                OpenStatusBadge(isOpen: mechanic.isOpen)
            }
        }
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
            }
        }
    }
}

/// A simple wrapping "chip" layout for the services list.
private struct FlowServicesView: View {
    let services: [String]

    var body: some View {
        // LazyVGrid keeps this simple and dependency-free; a custom Layout
        // could be used for true flow-wrapping if desired.
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(services, id: \.self) { service in
                Text(service)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.12))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    NavigationStack {
        MechanicDetailView(mechanic: .sample)
    }
}
