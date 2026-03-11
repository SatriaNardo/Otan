import SwiftUI

struct TagButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void // The code that runs when we tap it
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                // If selected, make it Orange. If not, make it light gray.
                .background(isSelected ? Color.orange : Color.gray.opacity(0.1))
                // If selected, text is White. If not, standard text color.
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20) // The nice pill shape
        }
    }
}

#Preview {
    // Showing both an active and inactive button side-by-side
    HStack {
        TagButton(title: "Animals", isSelected: true, action: {})
        TagButton(title: "Nature", isSelected: false, action: {})
    }
}
