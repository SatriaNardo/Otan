import SwiftUI

struct BookQuizView: View {
    let question: QuizQuestion
    @State private var selectedAnswer: Bool? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            Text(question.questionText)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 40) {
                // True Button
                QuizButton(title: "True", isSelected: selectedAnswer == true) {
                    selectedAnswer = true
                }
                
                // False Button
                QuizButton(title: "False", isSelected: selectedAnswer == false) {
                    selectedAnswer = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

// Sub-component for the big square buttons
struct QuizButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Spacer()
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 20)
            }
            .frame(width: 180, height: 180)
            .background(isSelected ? Color.orange : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(24)
        }
    }
}
