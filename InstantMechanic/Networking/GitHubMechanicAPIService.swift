//
//  GitHubMechanicAPIService.swift
//  InstantMechanic
//
//

import Foundation

final class GitHubMechanicAPIService: MechanicAPIServicing {

        static let mechanicsEndpoint = URL(string:
                                        "https:raw.githubusercontent.com/poojak2008/InstantMechanic/refs/heads/main/InstantMechanic/Resources/mechanics.json"    )!

    private let endpoint: URL
    private let session: URLSession

    init(endpoint: URL = GitHubMechanicAPIService.mechanicsEndpoint, session: URLSession = .shared) {
        self.endpoint = endpoint
        self.session = session
    }

    func fetchMechanics() async throws -> [Mechanic] {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: endpoint)
        } catch {
            // Genuine transport-level failure: offline, DNS, timeout, etc.
            throw APIError.requestFailed(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode([Mechanic].self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    func submitServiceRequest(_ request: ServiceRequest) async throws -> ServiceRequestConfirmation {
        return ServiceRequestConfirmation(
            requestId: "REQ-\(Int.random(in: 10000...99999))",
            message: "Service request submitted successfully.",
            submittedAt: Date()
        )
    }
}
