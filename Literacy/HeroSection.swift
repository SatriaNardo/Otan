import SwiftUI

struct HeroSection: View {
    var onSelect: (Book) -> Void
    @State private var featuredBook: Book? = mockBooks.randomElement()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let book = featuredBook {
                ZStack(alignment: .bottomLeading) {
                    
                    // --- THE BULLETPROOF FIX ---
                    // Color.clear takes exactly the width of the screen.
                    // Putting the image in the background forces it to obey the clear box's size
                    // without accidentally stretching the ScrollView!
                    Color.clear
                        .background(
                            SmartBookImage(imageName: book.imageName)
                                .aspectRatio(contentMode: .fill)
                        )
                        .clipped()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(book.title)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        HStack(spacing: 8) {
                            Text(book.category.rawValue)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange)
                                .cornerRadius(15)
                            
                            Text(book.duration.rawValue)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white)
                                .cornerRadius(15)
                        }
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 30)
                }
                .frame(height: 300)
                .contentShape(Rectangle())
                .clipped()
                
                .onTapGesture {
                    onSelect(book)
                }
            }
        }
    }
}
