import SwiftUI

struct ShelfBookCard: View {
    let book: Book
    // --- NEW: Accepts a dynamic color from the shelf ---
    let gradientColor: Color
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            // --- 1. THE IMAGE BACKGROUND ---
            if let uiImage = UIImage(named: book.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipped()
            } else {
                Color(UIColor.systemGray5)
            }
            
            // --- 2. THE TEXT PROTECTION GRADIENT ---
            // Replaced black with the dynamic category color
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, gradientColor.opacity(0.6), gradientColor]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            // --- 3. THE TEXT CONTENT ---
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(2)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text("10 Menit")
                        .font(.caption2)
                }
                .foregroundColor(.white.opacity(0.9))
            }
            .padding(12)
        }
        .frame(width: 140, height: 140)
        .cornerRadius(16)
    }
}
