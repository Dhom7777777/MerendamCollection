import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            LogsView()
                .tabItem {
                    Label("Logs", systemImage: "list.bullet.rectangle")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(Color("AccentPurple"))
    }
}
