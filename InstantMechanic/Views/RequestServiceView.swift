//
//  RequestServiceView.swift
//  InstantMechanic
//
//  "Request Service" form, shown from the Mechanic Details screen.
//  On successful submission it pushes to ConfirmationView.
//

import SwiftUI

struct RequestServiceView: View {
    @StateObject private var viewModel: RequestServiceViewModel
    @Environment(\.dismiss) private var dismiss

    /// Called once the request has been submitted successfully. The parent
    /// (`MechanicDetailView`) uses this to close this form and present the
    /// confirmation screen.
    var onSubmitted: () -> Void = {}

    init(mechanic: Mechanic, onSubmitted: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: RequestServiceViewModel(mechanic: mechanic))
        self.onSubmitted = onSubmitted
    }

    var body: some View {
        Form {
            Section("Select Service") {
                Picker("Service", selection: $viewModel.selectedService) {
                    ForEach(ServiceType.allCases) { service in
                        Text(service.rawValue).tag(service)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }

            Section("Vehicle Number") {
                TextField("HR26AB1234", text: $viewModel.vehicleNumber)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
            }

            Section("Problem Description") {
                TextEditor(text: $viewModel.problemDescription)
                    .frame(minHeight: 100)
            }

            if case .failed(let message) = viewModel.submitState {
                Section {
                    Label(message, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
            }

            Section {
                Button {
                    Task {
                        await viewModel.submit()
                        if case .success = viewModel.submitState {
                            onSubmitted()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.submitState == .submitting {
                            ProgressView()
                        } else {
                            Text("Request Service")
                                .bold()
                        }
                        Spacer()
                    }
                }
                .disabled(!viewModel.isFormValid || viewModel.submitState == .submitting)
            }
        }
        .navigationTitle("Request Service")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RequestServiceView(mechanic: .sample)
    }
}
