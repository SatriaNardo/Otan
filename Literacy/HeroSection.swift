import SwiftUI
// import UIKit

struct HeroSection: View {
    // 1. THE ACTION HANDLER
    // This tells the LibraryListView to open the book
    var onSelect: (Book) -> Void
    
    // Randomly pick a book from your mock data
    @State private var featuredBook: Book? = mockBooks.randomElement()
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            if let book = featuredBook {
                
                // --- 1. THE COVER IMAGE ---
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
                
                // --- 2. THE TITLE ---
                Text(book.title)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 2)
                    .lineLimit(2)
                
                // --- 3. THE SUBTITLE ---
                Text("Featured in our \(book.category.rawValue) collection")
                    .font(.subheadline)
                    .padding(.bottom, 16)
                    .foregroundColor(.secondary)
                
                // --- 4. THE UPDATED READ BUTTON ---
                Button(action: {
                    // WE REMOVED THE ORIENTATION LOCK FROM HERE
                    // Now we just tell the Library: "This book was picked!"
                    onSelect(book)
                }) {
                    HStack {
                        Image(systemName: "book")
                        Text("Baca")
                            .bold()
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                
            } else {
                Text("Loading featured book...")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
        .frame(height: 380)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemGray5))
    }
}
