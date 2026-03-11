import SwiftUI

struct LibraryListView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: BookCategory? = nil
    @State private var selectedBook: Book? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Static Branding Header (Stays put at the top)
            HeaderBanner()
            
            ScrollViewReader { proxy in
                ScrollView {
                    // --- 2. THE ABSOLUTE TOP ANCHOR ---
                    // Invisible target for auto-scrolling
                    Color.clear
                        .frame(height: 1)
                        .id("SCROLL_TO_TOP_ID")
                    
                    // --- 3. DYNAMIC HERO SECTION ---
                    // Animates its height to 0 when a category is selected to save space
                    // Inside LibraryListView
                    HeroSection { book in
                        self.selectedBook = book
                    }
                        .opacity(selectedCategory == nil ? 1 : 0)
                        .frame(height: selectedCategory == nil ? nil : 0)
                        .clipped()
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedCategory)
                    
                    LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                        
                        // --- 4. STICKY FILTER HEADER ---
                        // Contains Search Bar and Category Pills
                        Section(header: SearchAndCategoriesHeader(text: $searchText, selectedCategory: $selectedCategory)) {
                            
                            VStack(spacing: 24) {
                                // Dynamic Title based on selection
                                Text(selectedCategory == nil ? "Your Categories" : "Results for \(selectedCategory!.rawValue)")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .id("CATEGORY_TITLE_ANCHOR")
                                
                                ForEach(BookCategory.allCases, id: \.self) { category in
                                    // Filter Logic: Show all if nil, otherwise show specific category
                                    if selectedCategory == nil || selectedCategory == category {
                                        let shelfBooks = mockBooks.filter { $0.category == category }
                                        
                                        if !shelfBooks.isEmpty {
                                            // --- 5. THE OPTIMIZED SELECTION LOGIC ---
                                            BookShelf(title: category.rawValue, books: shelfBooks) { book in
                                                // --- THE ROTATION LOCK ---
                                                // Lock it HERE so the hardware starts turning
                                                // before the cover even slides up.
                                                OrientationManager.shared.lock(.landscape)
                                                
                                                // Small delay (100ms) for hardware to "breathe"
                                                // before the heavy view renders.
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    selectedBook = book
                                                }
                                            }
                                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                                        }
                                    }
                                }
                            }
                            .padding(.top, 24)
                            .padding(.bottom, 40)
                        }
                    }
                }
                // Prevents the "rubber-band" bounce to keep the layout tight
                .scrollBounceBehavior(.basedOnSize)
                .background(Color.white)
                
                // --- 6. AUTO-SCROLL ON FILTER ---
                // Snaps the view to the top whenever the user switches categories
                .onChange(of: selectedCategory) { oldValue, newValue in
                    Task {
                        // Delay allows the HeroSection to collapse before scrolling
                        try? await Task.sleep(nanoseconds: 150_000_000)
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8)) {
                            proxy.scrollTo("SCROLL_TO_TOP_ID", anchor: .top)
                        }
                    }
                }
            }
        }
        .animation(.easeInOut, value: selectedCategory)
        
        // --- 7. PRESENTATION ---
        // Launches the book in Landscape (forced by the closure above)
        .fullScreenCover(item: $selectedBook) { book in
            BookDetailView(book: book)
        }
        
        // --- 8. GLOBAL STATE MANAGEMENT ---
        .onAppear {
            // ALWAYS ensure the library is portrait when we enter or return
            OrientationManager.shared.lock(.portrait)
            
            // Kill the bounces at the UIKit level for a "Web-like" solid stop
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            // Re-enable bounces if you leave for other standard system views
            UIScrollView.appearance().bounces = true
        }
    }
}
