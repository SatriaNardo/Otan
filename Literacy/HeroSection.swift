import SwiftUI

struct HeroSection: View {
    var onSelect: (Book) -> Void
    @State private var featuredBook: Book? = mockBooks.randomElement()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let book = featuredBook {
                ZStack(alignment: .bottom) {
                    
                    // Background Image
                    Color.clear
                        .background(
                            SmartBookImage(imageName: book.imageName)
                                .aspectRatio(contentMode: .fill)
                        )
                        .clipped()
                    
                    // Dark Gradient for text readability
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    
                    // HStack for Left Text & Right Button
                    HStack(alignment: .bottom) {
                        
                        // LEFT SIDE: Title & Badges
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
                        
                        Spacer()
                        
                        // RIGHT SIDE: The 3D White "Baca" Button
                        Button(action: {
                            onSelect(book)
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Baca")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            // Orange text on white button
                            .foregroundColor(Color(red: 0.85, green: 0.4, blue: 0.25))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .clipShape(Capsule())
                            
                            // --- THE 3D EFFECT ---
                            // Radius 0 creates a hard edge instead of a blurry glow.
                            // y: 5 pushes that hard edge down to act as the button's "thickness".
                            .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.bottom, 5) // Gives the shadow room to breathe so it isn't cut off
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
                .frame(height: 340)
                .contentShape(Rectangle())
                .clipped()
            }
        }
    }
}
