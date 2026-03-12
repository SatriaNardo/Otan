import SwiftUI

struct SmartBookImage: View {
    let imageName: String
    
    var body: some View {
        // Look for a GIF file first
        if let _ = Bundle.main.url(forResource: imageName, withExtension: "gif") {
            NativeGifView(name: imageName)
        } else {
            // Fallback to regular image if no GIF is found
            if let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                // If image is missing entirely
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(Text("No Cover").foregroundColor(.gray))
            }
        }
    }
}
