import SwiftUI

struct BookDetailView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @State private var currentPageIndex = 0
    @State private var isForward = true
    
    var totalPages: Int {
        book.storyPages.count + book.quizQuestions.count
    }
    
    var currentTransition: AnyTransition {
        if currentPageIndex < book.storyPages.count {
            return .bookPageFlip(isForward: isForward)
        } else {
            return .opacity.combined(with: .move(edge: .bottom))
        }
    }
    
    var body: some View {
        ZStack {
            // 1. Immersive Background
            Color(UIColor.darkGray)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- 2. CUSTOM HEADER ---
                HStack {
                    Button(action: {
                        OrientationManager.shared.lock(.portrait)
                        dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Story")
                        }
                        .font(.body.bold())
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(currentPageIndex < book.storyPages.count ? book.title : "Quiz Time!")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 12)
                .background(Color(UIColor.darkGray))
                
                // --- 3. MAIN CONTENT AREA ---
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if currentPageIndex < book.storyPages.count {
                            let currentPage = book.storyPages[currentPageIndex]
                            
                            HStack(spacing: 0) {
                                // Left Side: Story Image (NOW WITH A FRAME!)
                                ZStack {
                                    // A soft background color for the "page" behind the picture
                                    Color(UIColor.systemGray6)
                                    
                                    if let uiImage = UIImage(named: currentPage.imageName) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            // --- THE FIX: Changed .fill to .fit so it won't crop! ---
                                            .aspectRatio(contentMode: .fit)
                                            // The image itself gets rounded corners
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                            // --- THE FRAME EFFECT ---
                                            .padding(3) // Inner spacing (the thick white border)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 24)) // Rounds the outer frame
                                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8) // 3D drop shadow
                                            .padding(10) // Outer spacing so it doesn't touch the edges of the screen
                                    } else {
                                        // Fallback if image is missing
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                                            .overlay(Text("No Image").foregroundColor(.gray))
                                            .padding(32)
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                
                                // Right Side: Story Text
                                ZStack(alignment: .topLeading) {
                                    BookStoryPageTextView(text: currentPage.text)
                                        .id(currentPageIndex)
                                        .transition(currentTransition)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .background(Color.white)
                                .clipped()
                            }
                        } else {
                            // Quiz Section
                            let quizIndex = currentPageIndex - book.storyPages.count
                            BookQuizView(question: book.quizQuestions[quizIndex])
                                .id(currentPageIndex)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    
                    // --- 4. THE PAGINATION ARROWS (FIXED OVERLAY) ---
                    SequentialPaginationView(
                        current: currentPageIndex,
                        total: totalPages,
                        onNext: {
                            if currentPageIndex == totalPages - 1 {
                                StreakManager.shared.logStoryCompleted() // Save Streak for Widget
                                OrientationManager.shared.lock(.portrait)
                                dismiss()
                            } else {
                                isForward = true
                                let duration = currentPageIndex < book.storyPages.count ? 0.6 : 0.3
                                withAnimation(.easeInOut(duration: duration)) {
                                    currentPageIndex += 1
                                }
                            }
                        },
                        onBack: {
                            isForward = false
                            let duration = currentPageIndex <= book.storyPages.count ? 0.6 : 0.3
                            withAnimation(.easeInOut(duration: duration)) {
                                currentPageIndex -= 1
                            }
                        }
                    )
                    .padding(.trailing, 40)
                    .padding(.bottom, 30)
                }
                .background(Color.white)
                .clipped()
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea()
        
        .onAppear {
            AppDelegate.orientationLock = .landscape
            OrientationManager.shared.lock(.landscape)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
            }
        }
        
        .onDisappear {
            AppDelegate.orientationLock = .portrait
            OrientationManager.shared.lock(.portrait)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            }
        }
    }
}
