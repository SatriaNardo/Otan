import SwiftUI

struct BookShelf: View {
    let title: String
    let books: [Book]
    
    // --- 1. THE ACTION HANDLER ---
    // This allows the shelf to send the chosen book back to LibraryListView
    var onSelect: (Book) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Shelf Header
            HStack {
                Text(title)
                    .font(.title3)
                    .bold()
                
                Text("Lihat semua")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(12)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // The Horizontal Scrolling Books
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(books) { book in
                        // --- 2. SWITCHED TO BUTTON ---
                        // We removed NavigationLink because we handle
                        // navigation via .fullScreenCover now.
                        Button(action: {
                            onSelect(book)
                        }) {
                            ShelfBookCard(book: book)
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
    // Pass in dummy data and an empty closure for the preview
    BookShelf(title: "Geografi", books: mockBooks, onSelect: { _ in })
}
