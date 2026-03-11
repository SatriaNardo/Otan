import SwiftUI
import UserNotifications

@main
struct LiteracyApp: App {
    // 1. Connect the AppDelegate to handle background/foreground logic
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // 2. Initialize your manager once at the top level
    @StateObject private var reminderManager = ReminderManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // 3. Provide the manager to all child views
                .environmentObject(reminderManager)
        }
    }
}

// --- THE NOTIFICATION LISTENER ---
// This class is the "Police Officer" that tells iOS:
// "I don't care if the app is open, show the alert anyway!"
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Set this class as the delegate for notifications
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // This is the "Magic Function" that allows foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // This tells iOS to show the Banner and play the Sound even if the app is active
        completionHandler([.banner, .list, .sound, .badge])
    }
    
    // This handles what happens when a user TAPS the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User tapped the notification!")
        completionHandler()
    }
}
