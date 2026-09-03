//
//  MechanicAPIService.swift
//  InstantMechanic
//


import Foundation

protocol MechanicAPIServicing {
    func fetchMechanics() async throws -> [Mechanic]
    func submitServiceRequest(_ request: ServiceRequest) async throws -> ServiceRequestConfirmation
}

// Mock implementation (default, used by the app out of the box)

final class MockMechanicAPIService: MechanicAPIServicing {

    
    var simulateFailure = false

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
