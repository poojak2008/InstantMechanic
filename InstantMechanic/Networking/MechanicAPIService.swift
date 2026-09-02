//
//  MechanicAPIService.swift
//  InstantMechanic
//
//  API / data layer. `MechanicAPIServicing` is the abstraction the rest of
//  the app depends on, so the data source can be swapped without touching
//  any view or view model.
//
//  `MockMechanicAPIService` here reads `mechanics.json` bundled with the
//  app and simulates real network behavior (latency + optional failure).
//  It's used as the default for the "Request Service" submission (there's
//  no live backend to POST to), and it's handy for SwiftUI previews / unit
//  tests / offline demoing.
//
//  The screen that the assignment's requirement 4 is really about — the
//  Home screen's mechanic list — defaults to `GitHubMechanicAPIService`
//  (see that file) instead, which performs a genuine `URLSession` HTTPS
//  GET against a real hosted JSON endpoint.
//

import Foundation

protocol MechanicAPIServicing {
    func fetchMechanics() async throws -> [Mechanic]
    func submitServiceRequest(_ request: ServiceRequest) async throws -> ServiceRequestConfirmation
}

// MARK: - Mock implementation (default, used by the app out of the box)

final class MockMechanicAPIService: MechanicAPIServicing {

    /// Set to `true` to preview the error state in the UI.
    var simulateFailure = false

    /// Artificial network latency so the loading state is visible.
    private let simulatedDelayNanoseconds: UInt64 = 800_000_000

    func fetchMechanics() async throws -> [Mechanic] {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)

        if simulateFailure {
            throw APIError.requestFailed(
                NSError(domain: "MockMechanicAPIService", code: -1009,
                        userInfo: [NSLocalizedDescriptionKey: "The network connection was lost."])
            )
        }

        guard let url = Bundle.main.url(forResource: "mechanics", withExtension: "json") else {
            throw APIError.resourceNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Mechanic].self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingFailed(error)
        } catch {
            throw APIError.requestFailed(error)
        }
    }

    func submitServiceRequest(_ request: ServiceRequest) async throws -> ServiceRequestConfirmation {
        try await Task.sleep(nanoseconds: 600_000_000)

        if simulateFailure {
            throw APIError.serverError(statusCode: 500)
        }

        return ServiceRequestConfirmation(
            requestId: "REQ-\(Int.random(in: 10000...99999))",
            message: "Service request submitted successfully.",
            submittedAt: Date()
        )
    }
}
