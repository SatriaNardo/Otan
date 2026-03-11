import SwiftUI
// import UIKit

struct HeroSection: View {
    // 1. THE ACTION HANDLER
    // This tells the LibraryListView to open the book and lock the orientation
    var onSelect: (Book) -> Void
    
    @State private var featuredBook: Book? = mockBooks.randomElement()
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            if let book = featuredBook {
                
                // 1. THE COVER IMAGE
                if let uiImage = UIImage(named: book.imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 20)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .overlay(Text("No Cover").foregroundColor(.gray))
                        .padding(.bottom, 20)
                }
                
                // 2. THE TITLE
                Text(book.title)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 2)
                    .lineLimit(2)
                
                // 3. THE SUBTITLE
                Text("Featured in our \(book.category.rawValue) collection")
                    .font(.subheadline)
                    .padding(.bottom, 16)
                    .foregroundColor(.secondary)
                
                // --- 4. THE OPTIMIZED READ BUTTON ---
                Button(action: {
                    // STEP A: Lock the hardware to Landscape immediately
                    OrientationManager.shared.lock(.landscape)
                    
                    // STEP B: Give the phone 100ms to physically turn before showing the book
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        onSelect(book)
                    }
                }) {
                    HStack {
                        Image(systemName: "book")
                        Text("Baca")
                            .bold()
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
                
            } else {
                Text("Loading featured book...")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .frame(height: 380)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemGray5))
        .overlay(
            Rectangle()
                .frame(height: 4)
                .foregroundColor(.blue),
            alignment: .bottom
        )
    }
}
