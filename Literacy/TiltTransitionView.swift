import SwiftUI

struct TiltTransitionView: View {
    let book: Book
    @Binding var isReady: Bool
    @State private var iconScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Immersive background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // --- THE ROTATE IMAGE ---
                Image("rotate") // Make sure "rotate" is in your Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .scaleEffect(iconScale) // Adding a gentle pulse
                
                VStack(spacing: 12) {
                    Text("Time to Tilt!")
                        .font(.title2.bold())
                    
                    Text("Please rotate your phone to Landscape\nto open \"\(book.title)\"")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(0.8)
                }
                .foregroundColor(.white)
            }
        }
        // Listen for the physical tilt of the phone
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            let currentOrientation = UIDevice.current.orientation
            if currentOrientation.isLandscape {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isReady = true
                }
            }
        }
        .onAppear {
            // Adds a gentle pulsing animation to the static image so it feels "active"
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                iconScale = 1.1
            }
        }
    }
}
