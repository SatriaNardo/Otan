import SwiftUI

struct ReminderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var manager = ReminderManager()
    
    @State private var reminderTime = Date()
    @State private var selectedDays: Set<String> = []
    
    // Maps the display letter to the English word your Manager uses to schedule notifications
    let dayPairs = [
        ("S", "Mon"), ("S", "Tue"), ("R", "Wed"),
        ("K", "Thu"), ("J", "Fri"), ("S", "Sat"), ("M", "Sun")
    ]
    
    let greenColor = Color(red: 0.4, green: 0.6, blue: 0.35)
    let orangeColor = Color.orange
    
    // --- 3D Shadow Colors ---
    let greyShadowColor = Color(white: 0.5, opacity: 1)
    let orangeShadowColor = Color(red: 0.82, green: 0.41, blue: 0.12, opacity: 1)
    let darkGreenShadowColor = Color(red: 0.25, green: 0.45, blue: 0.2, opacity: 1)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    
                    // ==========================================
                    // 1. TOP SECTION: CREATE NEW REMINDER CARD
                    // ==========================================
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Pengingat")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 10)
                        
                        // --- HARI APA? (What Day?) ---
                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack {
                                Text("Hari apa?")
                                    .font(.headline)
                                Spacer()
                                Button("Setiap Hari") {
                                    selectedDays = Set(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
                                }
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(orangeColor)
                            }
                            
                            HStack(spacing: 8) {
                                ForEach(0..<dayPairs.count, id: \.self) { index in
                                    let displayDay = dayPairs[index].0
                                    let logicDay = dayPairs[index].1
                                    let isSelected = selectedDays.contains(logicDay)
                                    
                                    Button(action: {
                                        if isSelected { selectedDays.remove(logicDay) }
                                        else { selectedDays.insert(logicDay) }
                                    }) {
                                        Text(displayDay)
                                            .font(.headline)
                                            .foregroundColor(isSelected ? .white : .black.opacity(0.6))
                                            .frame(width: 42, height: 42)
                                            .background(isSelected ? orangeColor : Color(UIColor.systemGray5))
                                            .clipShape(Circle())
                                            .shadow(color: isSelected ? orangeShadowColor : greyShadowColor, radius: 0.5, x: 0, y: 4.5)
                                    }
                                }
                            }
                        }
                        
                        // --- JAM BERAPA? (What Time?) ---
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Jam berapa?")
                                .font(.headline)
                            
                            // --- THE FIX: Switched to Wheel style for full-width layout ---
                            DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.wheel) // This forces the large, full-width tumblers
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                        }
                        
                        // --- SIMPAN (Save Button) ---
                        let isSaveDisabled = selectedDays.isEmpty
                        
                        Button(action: {
                            let new = ReadingReminder(time: reminderTime, days: selectedDays)
                            manager.addReminder(new)
                            selectedDays = [] // Reset UI after saving
                        }) {
                            Text("Simpan")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(isSaveDisabled ? .white.opacity(0.8) : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(isSaveDisabled ? Color(UIColor.systemGray4) : greenColor)
                                .cornerRadius(25)
                                .shadow(color: isSaveDisabled ? Color(UIColor.systemGray3) : darkGreenShadowColor, radius: 0.5, x: 0, y: 4.5)
                        }
                        .disabled(isSaveDisabled)
                        .padding(.top, 10)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    
                    // ==========================================
                    // 2. BOTTOM SECTION: SAVED REMINDERS
                    // ==========================================
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Pengingat Aktif")
                            .font(.headline)
                            .padding(.horizontal, 24)
                        
                        if manager.activeReminders.isEmpty {
                            Text("Belum ada pengingat.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 24)
                        } else {
                            ForEach(manager.activeReminders) { reminder in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(reminder.time, style: .time)
                                            .font(.title3).bold()
                                        
                                        Text(formatDays(reminder.days))
                                            .font(.caption)
                                            .foregroundColor(orangeColor)
                                    }
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { reminder.isEnabled },
                                        set: { _ in manager.toggleReminder(id: reminder.id) }
                                    ))
                                    .labelsHidden()
                                    .tint(greenColor)
                                    
                                    Button(action: {
                                        if let index = manager.activeReminders.firstIndex(where: { $0.id == reminder.id }) {
                                            manager.deleteReminder(at: IndexSet(integer: index))
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding(.leading, 12)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Color(UIColor.systemGray6).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Tutup") { dismiss() }
                        .foregroundColor(greenColor)
                        .bold()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDays(_ days: Set<String>) -> String {
        if days.count == 7 { return "Setiap Hari" }
        
        let map: [String: String] = [
            "Mon": "Senin", "Tue": "Selasa", "Wed": "Rabu",
            "Thu": "Kamis", "Fri": "Jumat", "Sat": "Sabtu", "Sun": "Minggu"
        ]
        
        let order = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let sorted = days.sorted { (order.firstIndex(of: $0) ?? 0) < (order.firstIndex(of: $1) ?? 0) }
        
        return sorted.compactMap { map[$0] }.joined(separator: ", ")
    }
}
