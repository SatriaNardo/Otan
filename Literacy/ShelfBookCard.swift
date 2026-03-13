import SwiftUI

struct ShelfBookCard: View {
    let book: Book
    let gradientColor: Color
    
    var body: some View {
        ZStack {
            // --- 1. THE 3D SHADOW LIP ---
            RoundedRectangle(cornerRadius: 18)
                .fill(gradientColor)
                .overlay(Color.black.opacity(0.3).clipShape(RoundedRectangle(cornerRadius: 18)))
                .offset(y: 6)
            
            // --- 2. THE MAIN CARD ---
            VStack(spacing: 0) {
                
                // TOP HALF: The Image & Duration Badge
                ZStack(alignment: .bottomLeading) {
                    if let uiImage = UIImage(named: book.imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 165, height: 110)
                            .clipped()
                    } else {
                        Color(UIColor.systemGray5)
                            .frame(width: 165, height: 110)
                    }
                    
                    // The dark translucent time pill
                    Text("10 Menit")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Capsule())
                        .padding(8)
                }
                
                // BOTTOM HALF: The Solid Color Title Block
                HStack(alignment: .top) { // Aligns the text to the top
                    Text(book.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2) // Allows up to 2 lines
                        .multilineTextAlignment(.leading)
                        // --- THE FIX 1: Allow text to shrink up to 20% to fit if needed ---
                        .minimumScaleFactor(0.8)
                    
                    Spacer(minLength: 0)
                }
                // --- THE FIX 2: Adjusted padding to give the text more vertical space ---
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(width: 165, height: 60, alignment: .topLeading)
                .background(gradientColor)
            }
            .frame(width: 165, height: 170)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(.bottom, 6)
    }
}
