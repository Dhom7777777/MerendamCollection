import SwiftUI

// MARK: - About
struct AboutView: View {
    let iosVersions = ["iOS 15.8.8","iOS 16.7.x","iOS 17.x","iOS 18.0","iOS 18.1","iOS 18.2"]

    var body: some View {
        ZStack { Color.black.ignoresSafeArea() }
        ScrollView {
            VStack(spacing: 0) {
                // Logo
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(LinearGradient(colors: [Color(hex: "#7c6ef7"), Color(hex: "#388FF0")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                        Text("🛡").font(.system(size: 38))
                    }
                    Text("Haven")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#e8e8f0"))
                    Text("Your on-device iOS toolkit")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#4a4a60"))
                }
                .padding(.top, 32)
                .padding(.bottom, 24)

                sectionLabel("App info")
                aboutGroup([
                    ("Version",      "1.0.0 (build 12)", false),
                    ("Minimum iOS",  "15.8.8",           false),
                    ("Maximum iOS",  "18.x (latest)",    false),
                    ("Source code",  "GitHub →",         true),
                    ("License",      "MIT",              false),
                ])

                sectionLabel("Tested on")
                FlowLayout(items: iosVersions) { ver in
                    Text(ver)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#6aaef5"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Color(hex: "#388FF0").opacity(0.1))
                        .overlay(Capsule().stroke(Color(hex: "#388FF0").opacity(0.25), lineWidth: 0.5))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

                Text("Compatibility tested on iPhone SE (2nd gen) through iPhone 16 Pro Max.")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#3a3a50"))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
            }
        }
        .background(Color.black)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .tracking(1.2)
            .foregroundColor(Color(hex: "#4a4a60"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 8)
    }

    func aboutGroup(_ rows: [(String, String, Bool)]) -> some View {
        VStack(spacing: 1) {
            ForEach(Array(rows.enumerated()), id: \.offset) { idx, row in
                HStack {
                    Text(row.0).font(.system(size: 15)).foregroundColor(Color(hex: "#dde"))
                    Spacer()
                    Text(row.1).font(.system(size: 15))
                        .foregroundColor(row.2 ? Color(hex: "#7c6ef7") : Color(hex: "#5a5a72"))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(Color(hex: "#16161f"))
            }
        }
        .cornerRadius(14)
        .padding(.horizontal, 16)
    }
}

// Simple flow layout
struct FlowLayout<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        var rows: [[Item]] = [[]]
        for item in items {
            rows[rows.count - 1].append(item)
            if rows[rows.count - 1].count >= 3 { rows.append([]) }
        }
        return VStack(alignment: .leading, spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { item in content(item) }
                }
            }
        }
    }
}

// MARK: - Logs
struct LogsView: View {
    let logs: [(String, String, Bool)] = [
        ("10:45:21", "Pairing file generated successfully", true),
        ("10:43:05", "Device trust handshake complete", true),
        ("10:42:50", "Local network access granted", true),
        ("10:40:11", "Haven started", true),
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(logs, id: \.0) { log in
                            HStack(alignment: .top, spacing: 12) {
                                Circle()
                                    .fill(log.2 ? Color(hex: "#26c0a2") : Color(hex: "#e24b4a"))
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 5)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(log.1)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "#e8e8f0"))
                                    Text(log.0)
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(hex: "#4a4a60"))
                                }
                                Spacer()
                            }
                            .padding(14)
                            .background(Color(hex: "#16161f"))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#2a2a3d"), lineWidth: 0.5))
                            .cornerRadius(14)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Logs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Settings
struct SettingsView: View {
    @State private var keepLogs = true
    @State private var autoRefresh = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                List {
                    Section {
                        Toggle("Keep logs on disk", isOn: $keepLogs)
                        Toggle("Auto-refresh pairing file", isOn: $autoRefresh)
                    } header: {
                        Text("General")
                            .foregroundColor(Color(hex: "#4a4a60"))
                    }
                    Section {
                        NavigationLink("Privacy policy") { Text("No data is collected.").foregroundColor(.white).padding() }
                        NavigationLink("Open source licenses") { Text("MIT License").foregroundColor(.white).padding() }
                    } header: {
                        Text("Legal")
                            .foregroundColor(Color(hex: "#4a4a60"))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.black)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Color hex init
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
