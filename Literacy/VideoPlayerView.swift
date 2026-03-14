import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoName: String
    var onEnd: () -> Void
    
    // We create a private player instance
    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                // 1. Locate the video in your app bundle
                if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                    let playerItem = AVPlayerItem(url: url)
                    self.player = AVPlayer(playerItem: playerItem)
                    
                    // 2. Setup the "End Detection"
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: playerItem,
                        queue: .main
                    ) { _ in
                        onEnd() // This triggers your SwiftUI function!
                    }
                    
                    player?.play()
                }
            }
            .onDisappear {
                player?.pause()
                player = nil
            }
    }
}
