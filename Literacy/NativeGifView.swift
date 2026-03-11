import SwiftUI
import ImageIO

struct NativeGifView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        // 1. Find the GIF in your project bundle
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return imageView
        }

        // 2. Extract every single frame
        var images = [UIImage]()
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }

        // 3. Create the animated image
        // Duration 0 means it uses the GIF's internal metadata timing
        imageView.image = UIImage.animatedImage(with: images, duration: Double(count) * 0.1)
        
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}
