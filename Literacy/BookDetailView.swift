import SwiftUI

struct BookDetailView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPageIndex = 0
    @State private var isForward = true
    
    var totalPages: Int {
        book.storyPages.count + book.quizQuestions.count
    }
    
    // --- BRAND COLORS ---
    let bgColor = Color(red: 0.95, green: 0.95, blue: 0.96)
    let orangeButtonColor = Color(red: 0.85, green: 0.4, blue: 0.25)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                bgColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // --- 1. HEADER ---
                    HStack {
                        Button(action: {
                            OrientationManager.shared.lock(.portrait)
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Story")
                            }
                            .font(.title3.bold())
                        }
                        .foregroundColor(Color(UIColor.darkText))
                        
                        Spacer()
                        
                        // --- THE FIX: Continuous Progress Bar ---
                        GeometryReader { barGeo in
                            ZStack(alignment: .leading) {
                                // 1. Empty gray track (Background)
                                Capsule()
                                    .fill(Color.gray.opacity(0.3))
                                
                                // 2. Filled orange track (Foreground)
                                Capsule()
                                    .fill(orangeButtonColor)
                                    // Calculates the percentage of completion
                                    .frame(width: barGeo.size.width * (CGFloat(currentPageIndex + 1) / CGFloat(totalPages)))
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPageIndex)
                            }
                        }
                        .frame(height: 8) // Thickness of the bar
                        .frame(maxWidth: 300) // Prevents the bar from getting too long on big screens
                        
                        Spacer()
                        
                        Text(currentPageIndex < book.storyPages.count ? "Membaca" : "Kuis")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    // --- 2. MAIN CONTENT AREA ---
                    ZStack {
                        if currentPageIndex < book.storyPages.count {
                            let currentPage = book.storyPages[currentPageIndex]
                            
                            HStack(spacing: 24) {
                                // LEFT SIDE: Image Card (30% Width)
                                ZStack {
                                    Color(UIColor.systemGray6)
                                    if let uiImage = UIImage(named: currentPage.imageName) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(10)
                                    }
                                }
                                .frame(width: geo.size.width * 0.30)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                                
                                // RIGHT SIDE: Wider Text Card
                                VStack(alignment: .leading, spacing: 0) {
                                    // Scrollable Story Text
                                    ScrollView(showsIndicators: true) {
                                        BookStoryPageTextView(text: currentPage.text)
                                            .id(currentPageIndex)
                                            .padding(.trailing, 8)
                                    }
                                    .scrollIndicators(.visible)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    
                                    // NAVIGATION BUTTONS
                                    HStack {
                                        if currentPageIndex > 0 {
                                            Button(action: goBack) {
                                                Image(systemName: "chevron.left").font(.title3.bold())
                                                    .foregroundColor(.gray)
                                                    .padding(12)
                                                    .background(Color(UIColor.systemGray6))
                                                    .clipShape(Circle())
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: goNext) {
                                            HStack(spacing: 8) {
                                                Text("Selanjutnya")
                                                Image(systemName: "chevron.right")
                                            }
                                            .font(.headline.bold())
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(orangeButtonColor)
                                            .clipShape(Capsule())
                                            .shadow(color: orangeButtonColor.opacity(0.4), radius: 6, x: 0, y: 3)
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                                .padding(.leading, 32)
                                .padding(.top, 32)
                                .padding(.bottom, 20)
                                .padding(.trailing, 16)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                            }
                            .padding(.horizontal, 32)
                            .padding(.bottom, 32)
                            
                        } else {
                            // QUIZ SECTION
                            let quizIndex = currentPageIndex - book.storyPages.count
                            BookQuizView(question: book.quizQuestions[quizIndex], onComplete: {
                                goNext()
                            })
                        }
                    }
                }
            }
        }
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .ignoresSafeArea()
        .onAppear {
            AppDelegate.orientationLock = .landscape
            OrientationManager.shared.lock(.landscape)
        }
        .onDisappear {
            AppDelegate.orientationLock = .portrait
            OrientationManager.shared.lock(.portrait)
        }
    }
    
    func goNext() {
        if currentPageIndex == book.storyPages.count - 1 {
            StreakManager.shared.logStoryCompleted()
        }
        if currentPageIndex == totalPages - 1 {
            StreakManager.shared.logStoryCompleted()
            OrientationManager.shared.lock(.portrait)
            dismiss()
        } else {
            isForward = true
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                currentPageIndex += 1
            }
        }
    }
    
    func goBack() {
        isForward = false
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentPageIndex -= 1
        }
    }
}
