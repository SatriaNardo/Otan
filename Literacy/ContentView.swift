import SwiftUI

struct ContentView: View {
    // --- 1. APP STATES ---
    @State private var isOpeningPageVisible = true // Control the welcome screen
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            if isOpeningPageVisible {
                // --- 2. THE OPENING PAGE (Lion Page) ---
                // We pass the binding so the button can turn this off
                OnboardingPageView(isOpeningPageVisible: $isOpeningPageVisible)
                    .zIndex(1) // Keeps this on top of the tabs during the flip
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            } else {
                // --- 3. THE MAIN APP INTERFACE (Tabs) ---
                TabView(selection: $selectedTab) {
                    
                    // TAB 1: HOME (Library)
                    NavigationStack {
                        LibraryListView()
                    }
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)

                    // TAB 2: SETTINGS
                    // (Note: Make sure you have a SettingsView.swift file!)
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(1)
                }
                .accentColor(.orange)
                .transition(.opacity) // Fades the tabs in smoothly
            }
        }
        // This makes the transition feel high-end and cinematic
        .animation(.easeInOut(duration: 0.6), value: isOpeningPageVisible)
    }
}

#Preview {
    ContentView()
}
