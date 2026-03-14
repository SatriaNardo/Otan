import SwiftUI
import AVKit

// MARK: - 1. ROBUST VIDEO LAYER CONTAINER
// This UIKit class ensures the video layer always matches the view size perfectly.
class AVPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        get { return (layer as? AVPlayerLayer)?.player }
        set { (layer as? AVPlayerLayer)?.player = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        (layer as? AVPlayerLayer)?.videoGravity = .resizeAspect
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 2. THE CLEAN VIDEO PLAYER
struct CleanVideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.player = player
        return view
    }
    
    func updateUIView(_ uiView: AVPlayerView, context: Context) {
        uiView.player = player
    }
}

// MARK: - 3. VIDEO COMPONENT
struct OnboardingVideoView: View {
    let videoName: String
    var onEnd: () -> Void
    
    @State private var player: AVPlayer?
    @State private var fileNotFound = false

    var body: some View {
        ZStack {
            if fileNotFound {
                Circle()
                    .fill(.red.opacity(0.1))
                    .overlay(Text("Video Not Found").font(.caption))
            } else if let player = player {
                CleanVideoPlayerView(player: player)
            }
        }
        .frame(width: 400, height: 400) // Increased size for visibility
        .onAppear {
            if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                let playerItem = AVPlayerItem(url: url)
                let newPlayer = AVPlayer(playerItem: playerItem)
                
                // Ensure audio doesn't interrupt or cause delays
                newPlayer.isMuted = true
                
                self.player = newPlayer
                
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: playerItem,
                    queue: .main
                ) { _ in
                    onEnd()
                }
                
                newPlayer.play()
            } else {
                fileNotFound = true
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

// MARK: - 4. MAIN ONBOARDING PAGE
struct OnboardingPageView: View {
    @Binding var isOpeningPageVisible: Bool
    
    var body: some View {
        ZStack {
            // Full white background
            Color.white.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                OnboardingVideoView(videoName: "onboarding_anim") {
                    // Slight delay before transitioning to ensure the user sees the final frame
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            isOpeningPageVisible = false
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}
