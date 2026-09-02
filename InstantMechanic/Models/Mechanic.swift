//
//  Mechanic.swift
//  InstantMechanic
//
//  Core data model representing a mechanic/garage returned by the API.
//

import Foundation

struct Mechanic: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let rating: Double
    let distance: Double
    let location: String
    let isOpen: Bool
    let services: [String]

    // Fields used by the Detail screen. Marked optional with defaults so the
    // same model still decodes cleanly against the simpler JSON shape given
    // in the assignment spec (which only has the 7 fields above).
    let address: String?
    let workingHours: String?
    let phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case id, name, rating, distance, location, isOpen, services
        case address, workingHours, phoneNumber
    }

    /// Address to show on the detail screen, falling back to `location`
    /// when the API doesn't provide a separate street address.
    var displayAddress: String {
        address ?? location
    }

    var displayWorkingHours: String {
        workingHours ?? (isOpen ? "Open now • Closes 9:00 PM" : "Closed • Opens 9:00 AM")
    }

    var displayPhoneNumber: String {
        phoneNumber ?? "+91 98765 43210"
    }
}

extension Mechanic {
    /// Small helper for previews / offline fallback UI.
    static let sample = Mechanic(
        id: 1,
        name: "Instant Auto Care",
        rating: 4.7,
        distance: 2.4,
        location: "Sector 44, Gurgaon",
        isOpen: true,
        services: ["Car Service", "Battery", "Tyre"],
        address: "Plot 12, Sector 44, Gurgaon, Haryana",
        workingHours: "Mon–Sat, 9:00 AM – 9:00 PM",
        phoneNumber: "+91 98765 43210"
    )
}
