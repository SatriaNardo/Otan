import SwiftUI

struct LargeBookCard: View {
    let book: Book
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                // --- TOP: Image & Badge ---
                ZStack(alignment: .bottomLeading) {
                    SmartBookImage(imageName: book.imageName)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                    
                    // Dark translucent duration badge
                    Text(book.duration.rawValue)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(16)
                        .padding(12)
                }
                
                // --- BOTTOM: Yellow Title Banner ---
                HStack {
                    Text(book.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(UIColor.darkText))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                }
                .padding()
                // The bright yellow from your mockup
                .background(Color(red: 0.9, green: 0.85, blue: 0.15))
            }
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle()) // Stops the card from turning blue when tapped
    }
}
