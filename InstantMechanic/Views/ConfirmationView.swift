//
//  ConfirmationView.swift
//  InstantMechanic
//
//  Shown after a service request is submitted successfully.
//

import SwiftUI

struct ConfirmationView: View {
    let mechanicName: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)

            Text("Service request submitted successfully.")
                .font(.title3).bold()
                .multilineTextAlignment(.center)

            Text("\(mechanicName) has received your request and will reach out shortly.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .navigationTitle("Confirmation")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ConfirmationView(mechanicName: "Instant Auto Care")
    }
}
