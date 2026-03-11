import SwiftUI

struct BookStoryPageView: View {
    let book: Book
    let text: String
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Half: Image
            if let uiImage = UIImage(named: book.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                Color.gray.opacity(0.2).frame(maxWidth: .infinity)
            }
        }
    }
}

// This file only handles the right-side text and its ScrollView.
struct BookStoryPageTextView: View {
    let text: String
    
    var body: some View {
        ScrollView {
            Text(text)
                .font(.title3)
                .bold()
                .lineSpacing(8)
                .padding(32)
                .foregroundColor(.black)
        }
        // This padding moves the text 10px away from the "spine"
        // so the 3D flip looks natural.
        .padding(.leading, 10)
    }
}
