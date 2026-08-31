import SwiftUI

struct SideStoreView: View {
    @State private var appleID = ""
    @State private var password = ""
    @State private var installStatus: InstallStatus = .idle
    @State private var progress: Double = 0

    enum InstallStatus {
        case idle, signingIn, downloading, installing, success, failed(String)
    }

    var body: some View {
        ZStack { Color.black.ignoresSafeArea() }
        ScrollView {
            VStack(spacing: 16) {
                // Hero
                VStack(spacing: 14) {
                    Text("📦").font(.system(size: 48))
                    Text("SideStore installer")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "#e8e8f0"))
                    Text("Signs and installs SideStore using your Apple ID — no Mac or PC required after setup.")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#5a5a72"))
                        .multilineTextAlignment(.center)
                }
                .padding(28)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#0d1520"))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(hex: "#1a2540"), lineWidth: 0.5))
                .cornerRadius(20)

                // Info rows
                InfoRow(label: "SideStore version", value: "0.6.2 (latest)")
                InfoRow(label: "Pairing file", value: "✓ Ready", valueColor: Color(hex: "#26c0a2"))

                // Apple ID fields
                VStack(spacing: 1) {
                    TextField("Apple ID email", text: $appleID)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(Color(hex: "#16161f"))
                        .foregroundColor(.white)

                    Divider().background(Color(hex: "#2a2a3d"))

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding(14)
                        .background(Color(hex: "#16161f"))
                        .foregroundColor(.white)
                }
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#2a2a3d"), lineWidth: 0.5))
                .cornerRadius(14)

                // Warning
                HStack(alignment: .top, spacing: 10) {
                    Text("⚠️").font(.system(size: 15))
                    Text("Your Apple ID password is used once locally and never stored or sent to Haven's servers.")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#9a7830"))
                        .lineSpacing(2)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#fac75020").opacity(0.3))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#fac750").opacity(0.2), lineWidth: 0.5))
                .cornerRadius(14)

                // Progress bar (shown during install)
                if installStatus != .idle {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(statusLabel)
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#5a5a72"))
                            Spacer()
                            Text("\(Int(progress))%")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(hex: "#388FF0"))
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3).fill(Color(hex: "#1e1e2d")).frame(height: 6)
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(LinearGradient(colors: [Color(hex: "#388FF0"), Color(hex: "#7c6ef7")], startPoint: .leading, endPoint: .trailing))
                                    .frame(width: geo.size.width * CGFloat(progress / 100), height: 6)
                                    .animation(.easeInOut(duration: 0.4), value: progress)
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding(16)
                    .background(Color(hex: "#16161f"))
                    .cornerRadius(14)
                }

                if case .success = installStatus {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "#26c0a2"))
                        Text("SideStore installed — open it from your home screen")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(hex: "#26c0a2"))
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#0a1f1a"))
                    .cornerRadius(14)
                }

                Button(action: startInstall) {
                    Text(installButtonLabel)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(installBtnColor)
                        .cornerRadius(16)
                }
                .disabled(appleID.isEmpty || password.isEmpty || installStatus == .signingIn || installStatus == .downloading || installStatus == .installing)
            }
            .padding(20)
        }
        .background(Color.black)
        .navigationTitle("Install SideStore")
        .navigationBarTitleDisplayMode(.inline)
    }

    var statusLabel: String {
        switch installStatus {
        case .signingIn:   return "Signing in to Apple ID…"
        case .downloading: return "Downloading SideStore IPA…"
        case .installing:  return "Installing…"
        case .success:     return "Complete"
        default:           return ""
        }
    }

    var installButtonLabel: String {
        switch installStatus {
        case .idle:        return "Sign in & install"
        case .signingIn:   return "Signing in…"
        case .downloading: return "Downloading…"
        case .installing:  return "Installing…"
        case .success:     return "✓ Installed"
        default:           return "Sign in & install"
        }
    }

    var installBtnColor: Color {
        switch installStatus {
        case .success:     return Color(hex: "#1a8060")
        case .signingIn, .downloading, .installing: return Color(hex: "#5548c8")
        default:           return Color(hex: "#7c6ef7")
        }
    }

    func startInstall() {
        installStatus = .signingIn
        progress = 0
        // Stage 1: sign in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            installStatus = .downloading
            animateProgress(to: 60, duration: 2.0) {
                installStatus = .installing
                animateProgress(to: 100, duration: 1.5) {
                    installStatus = .success
                }
            }
        }
    }

    func animateProgress(to target: Double, duration: Double, completion: @escaping () -> Void) {
        let steps = 20
        let stepValue = (target - progress) / Double(steps)
        let stepDelay = duration / Double(steps)
        for i in 0..<steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDelay * Double(i)) {
                progress += stepValue
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var valueColor: Color = Color(hex: "#dde")

    var body: some View {
        HStack {
            Text(label).font(.system(size: 13)).foregroundColor(Color(hex: "#5a5a72"))
            Spacer()
            Text(value).font(.system(size: 13, weight: .semibold)).foregroundColor(valueColor)
        }
        .padding(14)
        .background(Color(hex: "#16161f"))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#2a2a3d"), lineWidth: 0.5))
        .cornerRadius(14)
    }
}

extension SideStoreView.InstallStatus: Equatable {
    static func == (lhs: SideStoreView.InstallStatus, rhs: SideStoreView.InstallStatus) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.signingIn, .signingIn), (.downloading, .downloading),
             (.installing, .installing), (.success, .success): return true
        case (.failed(let a), .failed(let b)): return a == b
        default: return false
        }
    }
}
