import SwiftUI

struct FilterDropdownView: View {
    @Binding var selectedCategory: BookCategory?
    @Binding var selectedDuration: Duration?
    
    @State private var activeSheet: SheetType? = nil
    
    // --- NEW: State for the reminder pop-up ---
    @State private var showingReminder = false
    
    enum SheetType: Identifiable {
        case category, duration
        var id: Int { hashValue }
    }
    
    let orangeColor = Color(red: 0.85, green: 0.4, blue: 0.25)
    let greenColor = Color(red: 0.4, green: 0.6, blue: 0.35)
    let yellowColor = Color(red: 0.95, green: 0.75, blue: 0.2) // A nice bright color for the bell
    
    private var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.safeAreaInsets.top ?? 59
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: { activeSheet = .category }) {
                HStack {
                    Text(selectedCategory?.rawValue ?? "Kategori")
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(orangeColor)
                .cornerRadius(20)
            }
            
            Button(action: { activeSheet = .duration }) {
                HStack {
                    Text(selectedDuration?.rawValue ?? "Durasi")
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(greenColor)
                .cornerRadius(20)
            }
            
            // This spacer pushes the category/duration left, and the bell right!
            Spacer()
            
            // --- NEW: The Reminder Button ---
            Button(action: { showingReminder = true }) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(yellowColor) // You can change this to any color you like
                    .clipShape(Circle()) // Makes it a perfect circle
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        
        .padding(.top, safeAreaTop + 10)
        .background(Color.white)
        
        // Sheet for Categories and Durations
        .sheet(item: $activeSheet) { sheetType in
            if sheetType == .category {
                CategorySheet(selectedCategory: $selectedCategory, activeSheet: $activeSheet)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            } else {
                DurationSheet(selectedDuration: $selectedDuration, activeSheet: $activeSheet)
                    .presentationDetents([.fraction(0.4), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
        // --- NEW: Sheet for the Reminder Setup ---
                .sheet(isPresented: $showingReminder) {
                    ReminderView() // <--- Your view goes right here!
                        // You can keep the detents if you want it to be a half-sheet,
                        // or remove the next two lines if you want it to be a full-screen pop-up
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
    }
}
// MARK: - Bottom Sheet Views

struct CategorySheet: View {
    @Binding var selectedCategory: BookCategory?
    @Binding var activeSheet: FilterDropdownView.SheetType?
    
    // A palette of bright, kid-friendly colors
    let brightColors: [Color] = [
        Color(red: 0.9, green: 0.3, blue: 0.4),  // Bright Pink/Red
        Color(red: 0.2, green: 0.6, blue: 0.86), // Bright Blue
        Color(red: 0.95, green: 0.6, blue: 0.1), // Yellow/Orange
        Color(red: 0.5, green: 0.8, blue: 0.3),  // Lime Green
        Color(red: 0.6, green: 0.4, blue: 0.8),  // Purple
        Color(red: 0.2, green: 0.8, blue: 0.7)   // Teal
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    MenuPill(title: "Semua Kategori", icon: "globe", bgColor: Color(UIColor.systemGray5), textColor: .black) {
                        selectedCategory = nil
                        activeSheet = nil
                    }
                    
                    // Assign a specific bright color to each category
                    ForEach(Array(BookCategory.allCases.enumerated()), id: \.element) { index, category in
                        let color = brightColors[index % brightColors.count]
                        
                        MenuPill(title: category.rawValue, icon: "book.fill", bgColor: color, textColor: .white) {
                            selectedCategory = category
                            activeSheet = nil
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Pilih Kategori")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DurationSheet: View {
    @Binding var selectedDuration: Duration?
    @Binding var activeSheet: FilterDropdownView.SheetType?
    
    let orangeColor = Color(red: 0.85, green: 0.4, blue: 0.25)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    MenuPill(title: "Semua Waktu", icon: "clock", bgColor: Color(UIColor.systemGray5), textColor: .black) {
                        selectedDuration = nil
                        activeSheet = nil
                    }
                    
                    ForEach(Duration.allCases, id: \.self) { duration in
                        MenuPill(title: duration.rawValue, icon: "timer", bgColor: orangeColor, textColor: .white) {
                            selectedDuration = duration
                            activeSheet = nil
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Pilih Durasi")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Reusable pill design
struct MenuPill: View {
    let title: String
    let icon: String
    let bgColor: Color
    let textColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(bgColor)
            .cornerRadius(16)
        }
    }
}
