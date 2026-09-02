//
//  RequestServiceViewModel.swift
//  InstantMechanic
//

import Foundation
import Combine

@MainActor
final class RequestServiceViewModel: ObservableObject {

    enum SubmitState: Equatable {
        case idle
        case submitting
        case success(String) // confirmation message
        case failed(String)
    }

    @Published var selectedService: ServiceType = .carService
    @Published var vehicleNumber: String = ""
    @Published var problemDescription: String = ""
    @Published private(set) var submitState: SubmitState = .idle

    let mechanic: Mechanic
    private let apiService: MechanicAPIServicing

    init(mechanic: Mechanic, apiService: MechanicAPIServicing = MockMechanicAPIService()) {
        self.mechanic = mechanic
        self.apiService = apiService
    }

    var isFormValid: Bool {
        !vehicleNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func submit() async {
        guard isFormValid else {
            submitState = .failed("Please enter a vehicle number before submitting.")
            return
        }

        submitState = .submitting

        let request = ServiceRequest(
            mechanicId: mechanic.id,
            mechanicName: mechanic.name,
            service: selectedService,
            vehicleNumber: vehicleNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(),
            problemDescription: problemDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        do {
            let confirmation = try await apiService.submitServiceRequest(request)
            submitState = .success(confirmation.message)
        } catch {
            submitState = .failed(error.localizedDescription)
        }
    }
}
