import SwiftUI
import Combine

struct SearchAndCategoriesHeader: View {
    @Binding var text: String
    // --- THE NEW BINDING ---
    @Binding var selectedCategory: BookCategory?
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Search Bar
            //CustomSearchBar(text: $text)
            //  .padding(.vertical, 8)
                
            // Categories
            // We pass the binding down to the row
            CategoryRow(selectedCategory: $selectedCategory)
                .padding(.vertical, 12)
            
            Divider()
                .background(Color.blue.opacity(0.3))
        }
        .background(Color.white)
    }
}

#Preview {
    // Note: We use .constant for the preview to work
    SearchAndCategoriesHeader(text: .constant(""), selectedCategory: .constant(nil))
}
