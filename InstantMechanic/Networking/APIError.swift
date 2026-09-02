//
//  APIError.swift
//  InstantMechanic
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)
    case requestFailed(Error)
    case resourceNotFound
    case serverError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .invalidResponse:
            return "Received an unexpected response from the server."
        case .decodingFailed:
            return "Couldn't read the data returned by the server."
        case .requestFailed(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .resourceNotFound:
            return "The mock data file could not be found."
        case .serverError(let statusCode):
            return "Server returned an error (status code \(statusCode))."
        }
    }
}
