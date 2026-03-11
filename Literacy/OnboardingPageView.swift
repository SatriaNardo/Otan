import SwiftUI

// Custom colors defined to match image_5.png
extension Color {
    static let onboardingTextBlue = Color(red: 0.22, green: 0.53, blue: 0.82)
    static let onboardingTextGrey = Color(red: 0.58, green: 0.65, blue: 0.72)
    static let onboardingButtonOrange = Color(red: 0.94, green: 0.68, blue: 0.29)
    static let dotActiveYellow = Color(red: 0.96, green: 0.76, blue: 0.26)
    static let dotInactivePurple = Color(red: 0.65, green: 0.57, blue: 0.88)
    static let dotInactiveBlue = Color(red: 0.38, green: 0.61, blue: 0.89)
}

// Sub-component for the composite lion illustration frame
struct LionSubjectFrameView: View {
    var body: some View {
        ZStack {
            // 1. Outer White border and black inner circle
            Circle()
                .fill(.white)
                .stroke(.white, lineWidth: 3)
                .frame(width: 200, height: 200)
                .background(Circle().fill(.black))
            
            // 2. The illustration of the lion cub
            // Use a specific asset name or a placeholder if you don't have it yet.
            if let uiImage = UIImage(named: "lion_cub") { // Place your "lion_cub" asset in Assets.xcassets
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 190, height: 190) // Slightly smaller for the inner circle
                    .clipShape(Circle())
            } else {
                // Fallback placeholder with a colored circle
                Circle()
                    .fill(Color.orange.opacity(0.8))
                    .frame(width: 190, height: 190)
                    .overlay(Text("Add Lion").foregroundColor(.white).bold())
            }
        }
        .padding(.vertical, 40) // Spacing around the subject
    }
}

// Sub-component for the dynamic pagination dots
struct OnboardingPaginationDotsView: View {
    var body: some View {
        HStack(spacing: 8) {
            // First page (Yellow, active)
            Circle()
                .fill(Color.dotActiveYellow)
                .frame(width: 10, height: 10)
            
            // Second page (Purple, inactive)
            Circle()
                .fill(Color.dotInactivePurple)
                .frame(width: 10, height: 10)
            
            // Third page (Blue, inactive)
            Circle()
                .fill(Color.dotInactiveBlue)
                .frame(width: 10, height: 10)
        }
        .padding(.vertical, 10)
    }
}

// The complete onboarding/opening page view
struct OnboardingPageView: View {
    
    // Binding to control the page change
    @Binding var isOpeningPageVisible: Bool
    
    var body: some View {
        ZStack {
            // 1. Soft Gradient Background using blurred circles
            ZStack {
                // Background colors from image_5.png
                Circle()
                    .fill(Color.yellow.opacity(0.2))
                    .frame(width: 300, height: 300)
                    .offset(x: -100, y: -200) // Top-left yellow spot
                    .blur(radius: 60)
                
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 350, height: 350)
                    .offset(x: 150, y: 250) // Bottom-right blue spot
                    .blur(radius: 80)
            }
            .ignoresSafeArea() // Blurred shapes extend edge-to-edge
            
            VStack(spacing: 0) {
                // 2. Top-left decorative Yellow Star
                Image(systemName: "star.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color.dotActiveYellow)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                    .padding(.top, 20)
                
                // 3. Central content with illustration, text, and pagination
                VStack(spacing: 0) {
                    LionSubjectFrameView()
                    
                    Text("Halo!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.onboardingTextBlue)
                        .padding(.top, 10)
                        .padding(.bottom, 2)
                    
                    Text("Mau belajar apa hari ini?")
                        .font(.body)
                        .foregroundColor(Color.onboardingTextGrey)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    OnboardingPaginationDotsView()
                }
                .padding(.top, 20)
                
                // 4. Bottom-right decorative White Star
                Image(systemName: "star.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 40)
                    .padding(.bottom, 30)
                
                Spacer()
                
                // 5. The action button "Mulai Petualangan!"
                Button(action: {
                    // ACTION: Smoothly hide the opening page
                    withAnimation(.easeInOut) {
                        isOpeningPageVisible = false
                    }
                }) {
                    Text("Mulai Petualangan!")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            Capsule() // Use Capsule for the prominent rounded shape
                                .fill(Color.onboardingButtonOrange)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        )
                }
                .padding(.bottom, 30) // Final spacing from the bottom
            }
        }
        // Ensure the opening page sits correctly above content
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Senior Tip: Preview the onboarding page in Xcode
struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        // Use .constant to preview the binding
        OnboardingPageView(isOpeningPageVisible: .constant(true))
    }
}
