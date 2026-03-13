import SwiftUI

struct BookShelf: View {
    let title: String
    let books: [Book]
    
    // --- 1. THE ACTION HANDLER ---
    var onSelect: (Book) -> Void
    
    // --- NEW: Color Matcher ---
    // Assigns a unique color based on the shelf's title
    private var categoryColor: Color {
        switch title.lowercased() {
        case "alam": return Color(red: 0.9, green: 0.85, blue: 0.2)   // Bright Yellow
        case "sosial": return Color(red: 0.85, green: 0.4, blue: 0.25)   // Orange
        case "matematika": return Color(red: 0.2, green: 0.3, blue: 0.5)     // Night Blue
        case "kesehatan": return Color(red: 0.9, green: 0.4, blue: 0.6) // Pink
        case "beooo": return Color(red: 0.4, green: 0.6, blue: 0.35)    // Green
        default: return Color.blue
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // --- NEW: Updated Shelf Header ---
            HStack(spacing: 10) {
                // The vertical color pill from your mockup
                Capsule()
                    .fill(categoryColor)
                    .frame(width: 6, height: 28)
                
                Text(title)
                    .font(.title) // Larger font to match the mockup
                    .fontWeight(.heavy) // Extra bold
                    .foregroundColor(Color(UIColor.darkText))
                
                Spacer()
                // Removed the "Lihat semua" button completely
            }
            .padding(.horizontal)
            
            // The Horizontal Scrolling Books
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(books) { book in
                        Button(action: {
                            onSelect(book)
                        }) {
                            // --- NEW: Passing the color to the card ---
                            ShelfBookCard(book: book, gradientColor: categoryColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    BookShelf(title: "Geografi", books: mockBooks, onSelect: { _ in })
}
