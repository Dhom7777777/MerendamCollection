import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Hero
                        VStack(alignment: .leading, spacing: 10) {
                            Text("HAVEN")
                                .font(.system(size: 12, weight: .semibold))
                                .tracking(3)
                                .foregroundColor(Color(hex: "#7c6ef7"))

                            Text("Your iOS\nfreedom toolkit.")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .lineSpacing(2)

                            Text("Pairing files, SideStore install — no computer needed.")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#6b6b82"))

                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: "#7c6ef7"))
                                    .frame(width: 6, height: 6)
                                Text("iOS 15.8.8 – 18 supported")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#a89cf7"))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#7c6ef7").opacity(0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "#7c6ef7").opacity(0.3), lineWidth: 0.5)
                            )
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 20)

                        // Status strip
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color(hex: "#26c0a2"))
                                .frame(width: 8, height: 8)
                            Text("Device linked · ")
                                .foregroundColor(Color(hex: "#4a6050")) +
                            Text("Pairing file ready")
                                .foregroundColor(Color(hex: "#26c0a2"))
                                .fontWeight(.medium)
                        }
                        .font(.system(size: 12))
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#12120a"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#2a2a1a"), lineWidth: 0.5)
                        )
                        .cornerRadius(14)
                        .padding(.horizontal, 16)

                        // Section label
                        Text("TOOLS")
                            .font(.system(size: 11, weight: .semibold))
                            .tracking(1.2)
                            .foregroundColor(Color(hex: "#4a4a60"))
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            .padding(.bottom, 8)

                        // Tool cards
                        VStack(spacing: 10) {
                            NavigationLink(destination: PairingView()) {
                                ToolCard(
                                    emoji: "🔑",
                                    iconBg: Color(hex: "#7c6ef7").opacity(0.15),
                                    title: "Pairing file",
                                    subtitle: "Generate a device pairing file for sideloading tools"
                                )
                            }
                            NavigationLink(destination: SideStoreView()) {
                                ToolCard(
                                    emoji: "📦",
                                    iconBg: Color(hex: "#388FF0").opacity(0.15),
                                    title: "Install SideStore",
                                    subtitle: "Sign and install SideStore with your Apple ID"
                                )
                            }
                            NavigationLink(destination: AboutView()) {
                                ToolCard(
                                    emoji: "ℹ️",
                                    iconBg: Color(hex: "#26c0a2").opacity(0.15),
                                    title: "About Haven",
                                    subtitle: "Version info, compatibility, and open source"
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ToolCard: View {
    let emoji: String
    let iconBg: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(iconBg)
                    .frame(width: 48, height: 48)
                Text(emoji).font(.system(size: 22))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#e8e8f0"))
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#5a5a72"))
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#3a3a52"))
        }
        .padding(18)
        .background(Color(hex: "#16161f"))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(hex: "#2a2a3d"), lineWidth: 0.5)
        )
        .cornerRadius(18)
    }
}
