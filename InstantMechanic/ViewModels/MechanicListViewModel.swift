//
//  MechanicListViewModel.swift
//  InstantMechanic
//

import Foundation
import Combine

@MainActor
final class MechanicListViewModel: ObservableObject {
   
    

    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var mechanics: [Mechanic] = []
    @Published private(set) var state: LoadState = .idle

    private let apiService: MechanicAPIServicing

    init(apiService: MechanicAPIServicing = GitHubMechanicAPIService()) {
        self.apiService = apiService
    }

    func loadMechanics() async {
        state = .loading
        do {
            let result = try await apiService.fetchMechanics()
            mechanics = result
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func retry() async {
        await loadMechanics()
    }
}
