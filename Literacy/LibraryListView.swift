import SwiftUI

struct LibraryListView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: BookCategory? = nil
    @State private var selectedBook: Book? = nil
    
    // Tracks if the user has completed the tilt transition
    @State private var isReadyForBook: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBanner()
            
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear.frame(height: 1).id("SCROLL_TO_TOP_ID")
                    
                    HeroSection { book in
                        prepareForBook(book)
                    }
                    .opacity(selectedCategory == nil ? 1 : 0)
                    .frame(height: selectedCategory == nil ? nil : 0)
                    .clipped()
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedCategory)
                    
                    LazyVStack(alignment: .leading, spacing: 3, pinnedViews: [.sectionHeaders]) {
                        Section(header: SearchAndCategoriesHeader(text: $searchText, selectedCategory: $selectedCategory)) {
                            VStack(spacing: 24) {
                                Text(selectedCategory == nil ? "Categories" : "Results for \(selectedCategory!.rawValue)")
                                    .font(.headline).padding(.horizontal)
                                    .id("CATEGORY_TITLE_ANCHOR")
                                
                                ForEach(BookCategory.allCases, id: \.self) { category in
                                    if selectedCategory == nil || selectedCategory == category {
                                        let shelfBooks = mockBooks.filter { $0.category == category }
                                        if !shelfBooks.isEmpty {
                                            BookShelf(title: category.rawValue, books: shelfBooks) { book in
                                                prepareForBook(book)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 24).padding(.bottom, 40)
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .background(Color.white)
                .onChange(of: selectedCategory) { oldValue, newValue in
                    Task {
                        try? await Task.sleep(nanoseconds: 150_000_000)
                        withAnimation { proxy.scrollTo("SCROLL_TO_TOP_ID", anchor: .top) }
                    }
                }
            }
        }
        // --- UPDATED PRESENTATION LOGIC ---
        .fullScreenCover(item: $selectedBook) { book in
            if isReadyForBook {
                BookDetailView(book: book)
            } else {
                TiltTransitionView(book: book, isReady: $isReadyForBook)
            }
        }
        .onAppear {
            OrientationManager.shared.lock(.portrait)
            isReadyForBook = false // Reset readiness
            UIScrollView.appearance().bounces = false
        }
    }
    
    // Helper function to start the transition
    private func prepareForBook(_ book: Book) {
        // 1. Check if already in landscape (bypass guard)
        if UIDevice.current.orientation.isLandscape {
            isReadyForBook = true
        } else {
            isReadyForBook = false
            OrientationManager.shared.lock(.landscape)
        }
        
        // 2. Trigger the cover
        selectedBook = book
    }
}
