import SwiftUI
// import UIKit // ⚠️ Don't forget this so we can check for UIImage!

struct ShelfBookCard: View {
    let book: Book
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            // --- 1. THE IMAGE BACKGROUND ---
            if let uiImage = UIImage(named: book.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140) // Lock the image to the square size
                    .clipped() // Chop off any extra image that spills over
            } else {
                // Fallback gray box if you misspell an image name
                Color(UIColor.systemGray5)
            }
            
            // --- 2. THE TEXT PROTECTION GRADIENT ---
            // This adds a soft dark shadow at the bottom so the white text is always readable
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            // --- 3. THE TEXT CONTENT ---
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(2)
                    .foregroundColor(.white) // Changed to white so it pops on the image
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text("10 Menit")
                        .font(.caption2)
                }
                .foregroundColor(.white.opacity(0.8)) // Slightly dimmed white
            }
            .padding(12)
        }
        .frame(width: 140, height: 140)
        .cornerRadius(16)
    }
}

#Preview {
    ShelfBookCard(book: mockBooks[0])
}
