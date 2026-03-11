import SwiftUI

struct CategoryRow: View {
    // We bind to the selection in the LibraryListView
    @Binding var selectedCategory: BookCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                
                // 1. "All" Button to reset the filter
                CategoryBlock(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                // 2. Loop through our real categories from Book.swift
                ForEach(BookCategory.allCases, id: \.self) { category in
                    CategoryBlock(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// Sub-component for the individual category button
struct CategoryBlock: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Spacer()
                Text(title)
                    .font(.caption)
                    .bold()
                    .padding(.bottom, 8)
            }
            .frame(width: 100, height: 70)
            // Highlight the background if it's selected
            .background(isSelected ? Color.orange.opacity(0.2) : Color(UIColor.systemGray5))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
            )
            .foregroundColor(isSelected ? .orange : .primary)
            .cornerRadius(12)
        }
    }
}
