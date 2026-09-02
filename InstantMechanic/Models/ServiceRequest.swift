//
//  ServiceRequest.swift
//  InstantMechanic
//
//  Model + enum backing the "Request Service" form.
//

import Foundation

enum ServiceType: String, CaseIterable, Identifiable, Codable {
    case carService = "Car Service"
    case battery = "Battery"
    case tyre = "Tyre"
    case brake = "Brake"
    case acRepair = "AC Repair"

    var id: String { rawValue }
}

struct ServiceRequest: Codable {
    let mechanicId: Int
    let mechanicName: String
    let service: ServiceType
    let vehicleNumber: String
    let problemDescription: String
}

/// Result returned after "submitting" a request to the mock API.
struct ServiceRequestConfirmation: Codable {
    let requestId: String
    let message: String
    let submittedAt: Date
}
