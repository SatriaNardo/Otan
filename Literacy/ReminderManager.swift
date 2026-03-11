import Foundation
import UserNotifications
import Combine
import SwiftUI

struct ReadingReminder: Identifiable, Codable, Equatable {
    var id = UUID()
    var time: Date
    var days: Set<String>
    var isEnabled: Bool = true
}

class ReminderManager: ObservableObject {
    @Published var activeReminders: [ReadingReminder] = [] {
        didSet {
            saveToDisk()
        }
    }
    
    private let saveKey = "ReadingRemindersData"
    
    init() {
        requestPermission()
        loadFromDisk()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func addReminder(_ reminder: ReadingReminder) {
        activeReminders.append(reminder)
        scheduleNotifications(for: reminder)
    }
    
    func deleteReminder(at offsets: IndexSet) {
        for index in offsets {
            let reminder = activeReminders[index]
            cancelNotifications(for: reminder)
        }
        activeReminders.remove(atOffsets: offsets)
    }
    
    func toggleReminder(id: UUID) {
        if let index = activeReminders.firstIndex(where: { $0.id == id }) {
            activeReminders[index].isEnabled.toggle()
            let reminder = activeReminders[index]
            
            if reminder.isEnabled {
                scheduleNotifications(for: reminder)
            } else {
                cancelNotifications(for: reminder)
            }
        }
    }
    
    // --- NOTIFICATION ENGINE ---
    private func scheduleNotifications(for reminder: ReadingReminder) {
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
                let request = UNNotificationRequest(
                    identifier: "\(reminder.id.uuidString)-\(day)",
                    content: content,
                    trigger: trigger
                )
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    private func cancelNotifications(for reminder: ReadingReminder) {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let ids = days.map { "\(reminder.id.uuidString)-\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    // --- PERSISTENCE ---
    private func saveToDisk() {
        if let encoded = try? JSONEncoder().encode(activeReminders) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadFromDisk() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([ReadingReminder].self, from: data) {
            activeReminders = decoded
        }
    }
}
