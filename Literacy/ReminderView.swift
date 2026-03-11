import SwiftUI

struct ReminderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var manager = ReminderManager()
    
    @State private var reminderTime = Date()
    @State private var selectedDays: Set<String> = []
    
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        NavigationStack {
            List {
                // SECTION 1: EDIT & DELETE
                Section("Your Active Reminders") {
                    if manager.activeReminders.isEmpty {
                        Text("No reminders set yet.")
                            .font(.caption).foregroundColor(.gray)
                    } else {
                        ForEach(manager.activeReminders) { reminder in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(reminder.time, style: .time).font(.headline)
                                    Text(reminder.days.sorted().joined(separator: ", "))
                                        .font(.caption).foregroundColor(.orange)
                                }
                                Spacer()
                                // The Toggle now calls the manager to enable/disable
                                Toggle("", isOn: Binding(
                                    get: { reminder.isEnabled },
                                    set: { _ in manager.toggleReminder(id: reminder.id) }
                                ))
                                .labelsHidden()
                            }
                        }
                        .onDelete(perform: manager.deleteReminder) // ENABLE DELETE
                    }
                }
                
                // SECTION 2: ADDING NEW
                Section("Create New Reminder") {
                    DatePicker("Pick a time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Repeat on").font(.subheadline)
                            Spacer()
                            // --- SET EVERY DAY IS BACK ---
                            Button("Set Every Day") {
                                selectedDays = Set(days)
                            }
                            .font(.caption).foregroundColor(.orange)
                        }
                        
                        HStack {
                            ForEach(days, id: \.self) { day in
                                Text(day.prefix(1))
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
                    
                    Button(action: {
                        let new = ReadingReminder(time: reminderTime, days: selectedDays)
                        manager.addReminder(new)
                        selectedDays = [] // Reset UI after saving
                    }) {
                        Text("Add Reminder")
                            .bold().frame(maxWidth: .infinity).foregroundColor(.orange)
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
