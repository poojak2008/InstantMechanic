//
//  GitHubMechanicAPIService.swift
//  InstantMechanic
//
//  A genuine REST/JSON-endpoint-backed implementation of
//  `MechanicAPIServicing` — this is what satisfies assignment requirement
//  4 literally: a real HTTPS GET request via URLSession, real JSON
//  decoding, and real (not simulated) network error handling, rather than
//  reading a file out of the app bundle.
//
//  The endpoint is this project's own `mechanics.json`, served over
//  GitHub's raw-content CDN once the repo is pushed to GitHub — which the
//  assignment already requires you to do for the "Git" requirement. That
//  makes the file you're already committing double as your mock JSON
//  endpoint, with zero extra infrastructure or third-party accounts.
//
//  SETUP (do this once you've pushed the repo to GitHub):
//  1. Push this project to a public GitHub repo.
//  2. Replace `mechanicsEndpoint` below with the raw URL of your own
//     mechanics.json, e.g.:
//     https://raw.githubusercontent.com/<your-username>/<your-repo>/main/InstantMechanic/Resources/mechanics.json
//     (Open the file on github.com and click "Raw" to get the exact URL.)
//  3. That's it — `MechanicListViewModel` already defaults to this service,
//     so the home screen will now be fetching over a real network request.
//
//  Until step 2 is done, the placeholder URL below will 404, which is not
//  a bug: it exercises the app's real error state (bad status code ->
//  APIError.serverError -> "Couldn't load mechanics" + Try Again) end to
//  end, which is itself part of what the assignment wants demonstrated.
//

import Foundation

final class GitHubMechanicAPIService: MechanicAPIServicing {

    /// Replace this with the raw URL of YOUR pushed `mechanics.json`.
    static let mechanicsEndpoint = URL(string:
        "https://raw.githubusercontent.com/REPLACE-WITH-YOUR-USERNAME/InstantMechanic/main/InstantMechanic/Resources/mechanics.json"
    )!

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
        // raw.githubusercontent.com is read-only static hosting, so there's
        // no live endpoint to POST a request to. This mirrors
        // MockMechanicAPIService's submission behavior so the "Request
        // Service" flow still works end-to-end after a real fetch.
        try await Task.sleep(nanoseconds: 600_000_000)
        return ServiceRequestConfirmation(
            requestId: "REQ-\(Int.random(in: 10000...99999))",
            message: "Service request submitted successfully.",
            submittedAt: Date()
        )
    }
}
