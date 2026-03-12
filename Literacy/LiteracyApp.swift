import SwiftUI
import UserNotifications

@main
struct LiteracyApp: App {
    // 1. Connect the AppDelegate to handle background/foreground logic AND orientation
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

// --- THE APP DELEGATE (Notifications + Orientation Lock) ---
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // ==========================================
    // MARK: - 1. ORIENTATION LOCK (The Bouncer)
    // ==========================================
    
    // By default, we want the rest of your app to stay in Portrait
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    // iOS constantly asks this function: "Am I allowed to rotate right now?"
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    // ==========================================
    // MARK: - 2. NOTIFICATIONS (The Police Officer)
    // ==========================================
    
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
