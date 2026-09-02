//
//  MechanicListView.swift
//  InstantMechanic
//
//  Home Screen: shows the list of mechanics fetched from the API layer,
//  with loading and error states handled explicitly.
//

import SwiftUI

struct MechanicListView: View {
    @StateObject private var viewModel = MechanicListViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Instant Mechanic")
                .task {
                    if viewModel.mechanics.isEmpty {
                        await viewModel.loadMechanics()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Finding mechanics near you…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            ErrorStateView(message: message) {
                Task { await viewModel.retry() }
            }

        case .loaded:
            if viewModel.mechanics.isEmpty {
                ContentUnavailableFallbackView()
            } else {
                List(viewModel.mechanics) { mechanic in
                    NavigationLink(value: mechanic) {
                        MechanicRowView(mechanic: mechanic)
                    }
                }
                .listStyle(.plain)
                .navigationDestination(for: Mechanic.self) { mechanic in
                    MechanicDetailView(mechanic: mechanic)
                }
                .refreshable {
                    await viewModel.retry()
                }
            }
        }
    }
}

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("Couldn't load mechanics")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Try Again", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentUnavailableFallbackView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No mechanics found nearby")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// `Mechanic` needs to be Hashable for use with `navigationDestination(for:)`.
extension Mechanic: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#Preview {
    MechanicListView()
}
