import SwiftUI

struct SequentialPaginationView: View {
    // These properties allow the main BookDetailView to control the bar
    let current: Int
    let total: Int
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            
            // --- 1. THE BACK BUTTON ---
            Button(action: onBack) {
                Image(systemName: "arrow.left.to.line")
                    .font(.title2)
            }
            // Disable if we are on the very first page
            .disabled(current == 0)
            .opacity(current == 0 ? 0.2 : 1.0)
            
            // --- 2. THE PAGE INDICATOR ---
            Text("\(current + 1) / \(total)")
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit() // Prevents text from jumping when numbers change width
            
            // --- 3. THE NEXT / FINISH BUTTON ---
            Button(action: onNext) {
                // If it's the last page, show a green checkmark!
                // Otherwise, show the standard forward arrow.
                Image(systemName: current == total - 1 ? "checkmark.circle.fill" : "arrow.right.to.line")
                    .font(.title2)
                    .foregroundColor(current == total - 1 ? .green : .black)
            }
            // Notice: We don't disable this on the last page
            // because tapping it now triggers the 'Selesai' (Dismiss) action!
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(25)
    }
}

#Preview {
    // Testing the "Middle" state
    VStack(spacing: 40) {
        SequentialPaginationView(current: 1, total: 5, onNext: {}, onBack: {})
        
        // Testing the "Last Page" state
        SequentialPaginationView(current: 4, total: 5, onNext: {}, onBack: {})
    }
}
