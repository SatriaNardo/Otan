import SwiftUI

struct ContentView: View {
    // --- 1. APP STATES ---
    @State private var isOpeningPageVisible = true
    
    var body: some View {
        ZStack {
            if isOpeningPageVisible {
                // --- 2. THE OPENING PAGE ---
                OnboardingPageView(isOpeningPageVisible: $isOpeningPageVisible)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            } else {
                // --- 3. MAIN INTERFACE (No more TabView!) ---
                NavigationStack {
                    LibraryListView()
                        // Optional: Add a settings button to the top right
                        // since the bottom tab for Settings is gone
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: SettingsView()) {
                                    Image(systemName: "gearshape.fill")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: isOpeningPageVisible)
    }
}
