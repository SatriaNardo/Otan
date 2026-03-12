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
                            HStack(spacing: 0) {
                                // Left Side: Story Image
                                if let uiImage = UIImage(named: book.imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                        .clipped()
                                } else {
                                    Color.gray.opacity(0.1).frame(maxWidth: .infinity)
                                }
                                
                                // Right Side: Story Text
                                ZStack(alignment: .topLeading) {
                                    BookStoryPageTextView(text: book.storyPages[currentPageIndex])
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
                    // We place this inside the ZStack at the bottom trailing corner
                    SequentialPaginationView(
                        current: currentPageIndex,
                        total: totalPages,
                        onNext: {
                            if currentPageIndex == totalPages - 1 {
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
        
        // --- THE FIX: Hard lock to Landscape ---
        .onAppear {
        // 1. Tell iOS sensors: "ONLY allow landscape right now"
            AppDelegate.orientationLock = .landscape
            
            // 2. Flip the screen natively
            OrientationManager.shared.lock(.landscape)
            
            // 3. Force modern iOS 16+ to update its geometry immediately
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
            }
        }
            
            // --- THE FIX: Hard lock back to Portrait ---
        .onDisappear {
            // 1. Tell iOS sensors: "Okay, we are allowed to go back to portrait"
            AppDelegate.orientationLock = .portrait
            
            // 2. Flip the screen back
            OrientationManager.shared.lock(.portrait)
            
            // 3. Force modern iOS 16+ to update its geometry immediately
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            }
            }
        }
    }
