import SwiftUI
import Combine

struct ReminderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var manager = ReminderManager() // In a real app, pass this as an EnvironmentObject
    
    @State private var reminderTime = Date()
    @State private var selectedDays: Set<String> = []
    @State private var isAddingNew = false
    
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        NavigationStack {
            List {
                // --- SECTION 1: ACTIVE REMINDERS ---
                Section("Your Reminders") {
                    if manager.activeReminders.isEmpty {
                        Text("No reminders set yet.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(manager.activeReminders) { reminder in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(reminder.time, style: .time)
                                        .font(.headline)
                                    Text(reminder.days.sorted().joined(separator: ", "))
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                Spacer()
                                Toggle("", isOn: .constant(reminder.isEnabled))
                                    .labelsHidden()
                            }
                        }
                        .onDelete(perform: manager.deleteReminder)
                    }
                }
                
                // --- SECTION 2: ADD NEW ---
                Section("Add New Reminder") {
                    DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Repeat on")
                            .font(.subheadline)
                        
                        HStack {
                            ForEach(days, id: \.self) { day in
                                Text(day.prefix(1)) // Just the first letter for space
                                    .font(.caption).bold()
                                    .frame(width: 35, height: 35)
                                    .background(selectedDays.contains(day) ? Color.orange : Color(UIColor.systemGray5))
                                    .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        if selectedDays.contains(day) { selectedDays.remove(day) }
                                        else { selectedDays.insert(day) }
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Button("Set Every Day") {
                        selectedDays = Set(days)
                    }
                    .font(.caption)
                    .foregroundColor(.orange)
                    
                    Button(action: {
                        let newReminder = ReadingReminder(time: reminderTime, days: selectedDays)
                        manager.addReminder(newReminder)
                        selectedDays = [] // Reset UI
                    }) {
                        Text("Save New Reminder")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.orange)
                    }
                    .disabled(selectedDays.isEmpty)
                }
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
