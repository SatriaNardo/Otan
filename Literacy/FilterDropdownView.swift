import SwiftUI

struct FilterDropdownView: View {
    @Binding var selectedCategory: BookCategory?
    @Binding var selectedDuration: Duration?
    
    @State private var activeSheet: SheetType? = nil
    @State private var showingReminder = false
    
    enum SheetType: Identifiable {
        case category, duration
        var id: Int { hashValue }
    }
    
    let orangeColor = Color(red: 0.85, green: 0.4, blue: 0.25)
    let greenColor = Color(red: 0.4, green: 0.6, blue: 0.35)
    let yellowColor = Color(red: 0.95, green: 0.75, blue: 0.2)
    
    // 3D Shadow Colors
    let orangeShadow = Color(red: 0.65, green: 0.25, blue: 0.1)
    let greenShadow = Color(red: 0.25, green: 0.45, blue: 0.2)
    let yellowShadow = Color(red: 0.75, green: 0.55, blue: 0.05)
    
    private var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.safeAreaInsets.top ?? 59
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: { activeSheet = .category }) {
                HStack(spacing: 4) {
                    Text(selectedCategory?.rawValue ?? "Kategori")
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(orangeColor)
                .cornerRadius(20)
                .shadow(color: orangeShadow, radius: 0.5, x: 0, y: 4.5)
            }
            
            Button(action: { activeSheet = .duration }) {
                HStack(spacing: 4) {
                    Text(selectedDuration?.rawValue ?? "Durasi")
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(greenColor)
                .cornerRadius(20)
                .shadow(color: greenShadow, radius: 0.5, x: 0, y: 4.5)
            }
            
            // --- THE FIX: First Spacer (pushes filters to the left) ---
            Spacer(minLength: 4)
            
            if selectedCategory != nil || selectedDuration != nil {
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedCategory = nil
                        selectedDuration = nil
                    }
                }) {
                    Text("Hapus Filter")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.red)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .transition(.opacity.combined(with: .scale))
                
                // --- THE FIX: Second Spacer (pushes Bell to the right, centering the text!) ---
                Spacer(minLength: 4)
            }
            
            Button(action: { showingReminder = true }) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(yellowColor)
                    .clipShape(Circle())
                    .shadow(color: yellowShadow, radius: 0.5, x: 0, y: 4.5)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity)
        .padding(.top, safeAreaTop + 10)
        .background(Color.white)
        
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
        .sheet(isPresented: $showingReminder) {
            ReminderView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Bottom Sheet Views

struct CategorySheet: View {
    @Binding var selectedCategory: BookCategory?
    @Binding var activeSheet: FilterDropdownView.SheetType?
    
    let brightColors: [Color] = [
        Color(red: 0.9, green: 0.3, blue: 0.4),
        Color(red: 0.2, green: 0.6, blue: 0.86),
        Color(red: 0.95, green: 0.6, blue: 0.1),
        Color(red: 0.5, green: 0.8, blue: 0.3),
        Color(red: 0.6, green: 0.4, blue: 0.8),
        Color(red: 0.2, green: 0.8, blue: 0.7)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    MenuPill(title: "Semua Kategori", icon: "globe", bgColor: Color(UIColor.systemGray5), textColor: .black) {
                        selectedCategory = nil
                        activeSheet = nil
                    }
                    
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
            .shadow(color: Color.black.opacity(0.25), radius: 0.5, x: 0, y: 4.5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
