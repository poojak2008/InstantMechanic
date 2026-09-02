//
//  MechanicRowView.swift
//  InstantMechanic
//

import SwiftUI

struct MechanicRowView: View {
    let mechanic: Mechanic

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(mechanic.name)
                .font(.headline)

            HStack(spacing: 12) {
                Label(String(format: "%.1f", mechanic.rating), systemImage: "star.fill")
                    .foregroundStyle(.orange)
                Label(String(format: "%.1f km", mechanic.distance), systemImage: "mappin.and.ellipse")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)

            Text(mechanic.location)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            OpenStatusBadge(isOpen: mechanic.isOpen)

            VStack(alignment: .leading, spacing: 2) {
                Text("Services:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(mechanic.services.joined(separator: " • "))
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 8)
    }
}

struct OpenStatusBadge: View {
    let isOpen: Bool

    var body: some View {
        Text(isOpen ? "Open" : "Closed")
            .font(.caption).bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(isOpen ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
            .foregroundStyle(isOpen ? .green : .red)
            .clipShape(Capsule())
    }
}

#Preview {
    List {
        MechanicRowView(mechanic: .sample)
    }
}
