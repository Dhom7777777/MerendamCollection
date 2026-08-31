import SwiftUI

struct PairingView: View {
    @State private var status: PairingStatus = .idle

    enum PairingStatus {
        case idle, generating, success, failed(String)
    }

    var body: some View {
        ZStack { Color.black.ignoresSafeArea() }
        ScrollView {
            VStack(spacing: 20) {
                // Hero card
                VStack(spacing: 14) {
                    Text("🔑").font(.system(size: 48))
                    Text("Generate pairing file")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "#e8e8f0"))
                    Text("Creates a local trust record so sideloading tools can communicate with your device.")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#5a5a72"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(28)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#13102a"))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(hex: "#2a2040"), lineWidth: 0.5))
                .cornerRadius(20)

                // Steps
                VStack(spacing: 10) {
                    StepRow(number: "1", title: "Allow local network", detail: "Haven uses a local Wi-Fi bridge — tap Allow when prompted.")
                    StepRow(number: "2", title: "Trust this device", detail: "A system dialog will ask you to trust. Tap Trust and enter your passcode.")
                    StepRow(number: "3", title: "File saved to Files app", detail: "Your .plist pairing file lands in On My iPhone → Haven.")
                }

                // Status / result
                if case .generating = status {
                    HStack(spacing: 10) {
                        ProgressView().tint(.white)
                        Text("Generating…")
                            .foregroundColor(Color(hex: "#a89cf7"))
                            .font(.system(size: 14))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Color(hex: "#16161f"))
                    .cornerRadius(16)
                }

                if case .success = status {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "#26c0a2"))
                        Text("Pairing file saved to Files app")
                            .foregroundColor(Color(hex: "#26c0a2"))
                            .font(.system(size: 14, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Color(hex: "#0a1f1a"))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#1a4035"), lineWidth: 0.5))
                    .cornerRadius(16)
                }

                if case .failed(let msg) = status {
                    Text("Error: \(msg)")
                        .foregroundColor(Color(hex: "#e24b4a"))
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color(hex: "#1f0a0a"))
                        .cornerRadius(16)
                }

                // Buttons
                Button(action: generatePairing) {
                    Text(status == .generating ? "Generating…" : "Generate now")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(status == .generating ? Color(hex: "#5548c8") : Color(hex: "#7c6ef7"))
                        .cornerRadius(16)
                }
                .disabled(status == .generating)

                Button(action: {}) {
                    Text("Share existing file")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#7c6ef7"))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color(hex: "#16161f"))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#2a2a3d"), lineWidth: 0.5))
                        .cornerRadius(16)
                }
            }
            .padding(20)
        }
        .background(Color.black)
        .navigationTitle("Pairing file")
        .navigationBarTitleDisplayMode(.inline)
    }

    func generatePairing() {
        status = .generating
        // Real implementation: usbmuxd / local lockdown handshake goes here
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            status = .success
        }
    }
}

struct StepRow: View {
    let number: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .strokeBorder(Color(hex: "#7c6ef7").opacity(0.3), lineWidth: 0.5)
                    .background(Circle().fill(Color(hex: "#7c6ef7").opacity(0.15)))
                    .frame(width: 26, height: 26)
                Text(number)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#9a8cf7"))
            }
            .padding(.top, 1)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#dde"))
                Text(detail)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#55556a"))
                    .lineSpacing(2)
            }
            Spacer()
        }
        .padding(14)
        .background(Color(hex: "#16161f"))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#2a2a3d"), lineWidth: 0.5))
        .cornerRadius(14)
    }
}
