import SwiftUI

// The math that actually tilts the view
struct PageFlipModifier: ViewModifier {
    let angle: Double
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0.0, y: 1.0, z: 0.0),
                anchor: .leading, // The "Spine" of the book
                perspective: 0.5   // Adds 3D depth
            )
    }
}

// The easy-to-use shortcut
extension AnyTransition {
    static func bookPageFlip(isForward: Bool) -> AnyTransition {
        let insertionAngle = isForward ? 90.0 : -90.0
        let removalAngle = isForward ? -90.0 : 90.0
        
        return .asymmetric(
            insertion: .modifier(
                active: PageFlipModifier(angle: insertionAngle),
                identity: PageFlipModifier(angle: 0)
            ).combined(with: .opacity),
            
            removal: .modifier(
                active: PageFlipModifier(angle: removalAngle),
                identity: PageFlipModifier(angle: 0)
            ).combined(with: .opacity)
        )
    }
}
