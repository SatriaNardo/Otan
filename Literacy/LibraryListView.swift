import SwiftUI

struct LibraryListView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: BookCategory? = nil
    @State private var selectedDuration: Duration? = nil
    @State private var selectedBook: Book? = nil
    @State private var isReadyForBook: Bool = false
    
    private var safeAreaTop: CGFloat {
        let inset = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.safeAreaInsets.top ?? 59
        return max(inset, 59)
    }

    // --- NEW HELPER: Adjusts padding so titles aren't hidden ---
    private var dynamicTopPadding: CGFloat {
        let isFiltering = (selectedCategory != nil || selectedDuration != nil)
        return isFiltering ? 20 : 10 // Pushes content down 20pt when filtering
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear.frame(height: 0).id("SCROLL_TO_TOP_ID")
                    
                    HeroSection { book in
                        prepareForBook(book)
                    }
                    .opacity((selectedCategory == nil && selectedDuration == nil) ? 1 : 0)
                    .frame(height: (selectedCategory == nil && selectedDuration == nil) ? nil : 0)
                    .clipped()
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedCategory)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedDuration)
                    .zIndex(1)
                    
                    LazyVStack(alignment: .leading, spacing: 3, pinnedViews: [.sectionHeaders]) {
                        
                        Section(header:
                            FilterDropdownView(selectedCategory: $selectedCategory, selectedDuration: $selectedDuration)
                        ) {
                            VStack(spacing: 24) {
                                if let title = dynamicTitle {
                                    Text(title)
                                        .font(.headline)
                                        .padding(.horizontal)
                                        // Extra padding here if a title exists
                                        .padding(.top, 5)
                                        .id("CATEGORY_TITLE_ANCHOR")
                                }
                                
                                ForEach(BookCategory.allCases, id: \.self) { category in
                                    buildCategoryShelf(for: category)
                                }
                            }
                            // --- THE FIX: Apply the dynamic padding here ---
                            .padding(.top, dynamicTopPadding)
                            .padding(.bottom, 5)
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
        if selectedCategory == nil || selectedCategory == category {
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
