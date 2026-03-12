import SwiftUI

struct LibraryListView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: BookCategory? = nil
    @State private var selectedDuration: Duration? = nil
    @State private var selectedBook: Book? = nil
    @State private var isReadyForBook: Bool = false
    
    // --- NEW: Helper to check if we are filtering ---
    private var isFiltering: Bool {
        selectedCategory != nil || selectedDuration != nil
    }
    
    // --- NEW: Helper to get filtered books for the vertical list ---
    private var filteredBooks: [Book] {
        mockBooks.filter { book in
            let matchesCategory = (selectedCategory == nil || book.category == selectedCategory)
            let matchesDuration = (selectedDuration == nil || book.duration == selectedDuration)
            return matchesCategory && matchesDuration
        }
    }
    
    private var safeAreaTop: CGFloat {
        let inset = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.safeAreaInsets.top ?? 59
        return max(inset, 59)
    }

    private var dynamicTopPadding: CGFloat {
        let isFiltering = (selectedCategory != nil || selectedDuration != nil)
        return isFiltering ? 20 : 10
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear.frame(height: 0).id("SCROLL_TO_TOP_ID")
                    
                    HeroSection { book in
                        prepareForBook(book)
                    }
                    .opacity(isFiltering ? 0 : 1)
                    .frame(height: isFiltering ? 0 : nil)
                    .clipped()
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedCategory)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedDuration)
                    .zIndex(1)
                    
                    LazyVStack(alignment: .leading, spacing: 3, pinnedViews: [.sectionHeaders]) {
                        
                        Section(header:
                            FilterDropdownView(selectedCategory: $selectedCategory, selectedDuration: $selectedDuration)
                        ) {
                            // --- BRANCHING LAYOUT LOGIC ---
                            if isFiltering {
                                // 1. FILTERED VIEW: Title + Large Vertical Cards
                                VStack(spacing: 24) {
                                    // Keep the dynamic title here!
                                    if let title = dynamicTitle {
                                        Text(title)
                                            .font(.headline)
                                            .padding(.horizontal)
                                            .padding(.top, 5)
                                            .id("CATEGORY_TITLE_ANCHOR")
                                    }
                                    
                                    // The big vertical cards
                                    VStack(spacing: 20) {
                                        ForEach(filteredBooks) { book in
                                            LargeBookCard(book: book) {
                                                prepareForBook(book)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .padding(.top, dynamicTopPadding)
                                .padding(.bottom, 40)
                                
                            } else {
                                // 2. DEFAULT VIEW: Horizontal Shelves
                                VStack(spacing: 24) {
                                    ForEach(BookCategory.allCases, id: \.self) { category in
                                        buildCategoryShelf(for: category)
                                    }
                                }
                                .padding(.top, dynamicTopPadding)
                                .padding(.bottom, 5)
                            }
                        }
                    }
                    .padding(.top, -(safeAreaTop + 10))
                    .zIndex(0)
                }
                .scrollBounceBehavior(.basedOnSize)
                .background(Color.white)
                .ignoresSafeArea(edges: .top)
                
                .onChange(of: selectedCategory) { scrollToTop(proxy) }
                .onChange(of: selectedDuration) { scrollToTop(proxy) }
            }
        }
        .fullScreenCover(item: $selectedBook) { book in
            if isReadyForBook {
                BookDetailView(book: book)
            } else {
                TiltTransitionView(book: book, isReady: $isReadyForBook)
            }
        }
        .onAppear {
            OrientationManager.shared.lock(.portrait)
            isReadyForBook = false
            UIScrollView.appearance().bounces = false
        }
    }
    
    // MARK: - Helper Methods
    
    @ViewBuilder
    private func buildCategoryShelf(for category: BookCategory) -> some View {
        let shelfBooks = mockBooks.filter { book in
            let matchesCategory = (book.category == category)
            let matchesDuration = (selectedDuration == nil || book.duration == selectedDuration)
            return matchesCategory && matchesDuration
        }
        
        if !shelfBooks.isEmpty {
            BookShelf(title: category.rawValue, books: shelfBooks) { book in
                prepareForBook(book)
            }
        }
    }
    
    private var dynamicTitle: String? {
        if let cat = selectedCategory, let dur = selectedDuration {
            return "Hasil untuk \(cat.rawValue) • \(dur.rawValue)"
        } else if let cat = selectedCategory {
            return "Hasil untuk \(cat.rawValue)"
        } else if let dur = selectedDuration {
            return "Hasil untuk \(dur.rawValue)"
        } else {
            return nil
        }
    }
    
    private func scrollToTop(_ proxy: ScrollViewProxy) {
        Task {
            try? await Task.sleep(nanoseconds: 150_000_000)
            withAnimation { proxy.scrollTo("SCROLL_TO_TOP_ID", anchor: .top) }
        }
    }
    
    private func prepareForBook(_ book: Book) {
        if UIDevice.current.orientation.isLandscape {
            isReadyForBook = true
        } else {
            isReadyForBook = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                OrientationManager.shared.lock(.landscape)
            }
        }
        selectedBook = book
    }
}

