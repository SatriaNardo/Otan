import SwiftUI
import Combine

@main
struct LiteracyApp: App {
    // This allows the whole app to react when a book opens
    @StateObject private var orientationManager = OrientationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // This ensures the root view controller re-evaluates
                // whenever the lock is changed.
                .onReceive(orientationManager.$orientationMask) { _ in }
        }
    }
}
