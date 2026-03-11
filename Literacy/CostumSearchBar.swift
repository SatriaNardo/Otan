import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Mau belajar apa hari ini?", text: $text)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    CustomSearchBar(text: .constant(""))
}
