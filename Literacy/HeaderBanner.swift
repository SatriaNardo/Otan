import SwiftUI


struct HeaderBanner: View {
    // --- 1. THE TRIGGER ---
    @State private var showingReminder = false
    
    var body: some View {
        HStack {
            Button(action: { print("Menu tapped") }) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text("Literacy Adventures")
                .font(.headline)
                .bold()
            
            Spacer()
            
            // --- 2. UPDATED BELL BUTTON ---
            Button(action: {
                showingReminder = true // Trigger the sheet
            }) {
                Image(systemName: "bell.badge.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.white)
        // --- 3. THE SHEET ATTACHMENT ---
        .sheet(isPresented: $showingReminder) {
            ReminderView()
        }
    }
}
