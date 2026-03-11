import SwiftUI
import Foundation
import UserNotifications
import Combine // <-- FIX 1: This is required for ObservableObject and @Published

struct ReadingReminder: Identifiable, Codable {
    var id = UUID()
    var time: Date
    var days: Set<String>
    var isEnabled: Bool = true
}

class ReminderManager: ObservableObject {
    @Published var activeReminders: [ReadingReminder] = []
    
    init() {
        requestPermission()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func addReminder(_ reminder: ReadingReminder) {
        activeReminders.append(reminder)
        scheduleNotification(for: reminder)
    }
    
    // FIX 2: Correctly looping through the IndexSet
    func deleteReminder(at offsets: IndexSet) {
        for index in offsets {
            let reminder = activeReminders[index]
            // Cancel the scheduled notifications for this specific reminder
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
        }
        activeReminders.remove(atOffsets: offsets)
    }
    
    func scheduleNotification(for reminder: ReadingReminder) {
        let content = UNMutableNotificationContent()
        content.title = "Time for an Adventure! 📖"
        content.body = "Your books are waiting. Let's read together!"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminder.time)
        
        let dayMapping = ["Sun": 1, "Mon": 2, "Tue": 3, "Wed": 4, "Thu": 5, "Fri": 6, "Sat": 7]
        
        for day in reminder.days {
            if let weekday = dayMapping[day] {
                var triggerComponents = components
                triggerComponents.weekday = weekday
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
                
                // We create a unique ID per day to avoid overwriting
                let requestIdentifier = "\(reminder.id.uuidString)-\(day)"
                let request = UNNotificationRequest(
                    identifier: requestIdentifier,
                    content: content,
                    trigger: trigger
                )
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
