import Foundation
import WidgetKit // We need this to wake the widget up!

class StreakManager {
    static let shared = StreakManager()
    private init() {}
    
    // 1. THE SHARED SAFE (App Group)
    // IMPORTANT: We will need to set this exact ID up in Xcode in the next step!
    let appGroupID = "group.com.SELF.Otan"
    
    private var sharedDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupID)
    }
    
    // 2. CALLED BY THE APP (When they finish the quiz)
    func logStoryCompleted() {
        guard let defaults = sharedDefaults else { return }
        
        let calendar = Calendar.current
        let today = Date()
        
        // Pull the previous data from the shared safe
        let lastReadDate = defaults.object(forKey: "lastReadDate") as? Date
        var activeDays = defaults.integer(forKey: "activeDaysCount")
        
        if let lastDate = lastReadDate {
            if calendar.isDateInToday(lastDate) {
                // They already read a story today. Streak stays the same!
                print("Already read today. Streak maintained at \(activeDays).")
            } else if calendar.isDateInYesterday(lastDate) {
                // They read yesterday, so the streak grows!
                activeDays += 1
            } else {
                // They missed a day. The streak breaks and resets to 1.
                activeDays = 1
            }
        } else {
            // This is their very first time reading a story!
            activeDays = 1
        }
        
        // Save the new data back into the shared safe
        defaults.set(today, forKey: "lastReadDate")
        defaults.set(activeDays, forKey: "activeDaysCount")
        
        print("Backend Success: Story completed! Active Streak: \(activeDays)")
        
        // 🚨 MAGIC STEP: Tell the iOS Home Screen to redraw the widget right now!
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // 3. CALLED BY THE WIDGET (To figure out which Otan face to show)
    func getWidgetStats() -> (active: Int, missed: Int) {
        guard let defaults = sharedDefaults,
              let lastReadDate = defaults.object(forKey: "lastReadDate") as? Date else {
            // If they have never opened the app, show 1 Day Away
            return (active: 0, missed: 1)
        }
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(lastReadDate) || calendar.isDateInYesterday(lastReadDate) {
            // If they read today or yesterday, they are on an active streak!
            let active = defaults.integer(forKey: "activeDaysCount")
            return (active: active > 0 ? active : 1, missed: 0)
        } else {
            // If they missed days, calculate exactly how many days away they are
            let startOfToday = calendar.startOfDay(for: Date())
            let startOfLastRead = calendar.startOfDay(for: lastReadDate)
            
            let components = calendar.dateComponents([.day], from: startOfLastRead, to: startOfToday)
            let missedDays = components.day ?? 1
            
            // Streak is 0, missed days is calculated
            return (active: 0, missed: missedDays)
        }
    }
}
