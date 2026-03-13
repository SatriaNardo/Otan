import SwiftUI

struct BookQuizView: View {
    let question: QuizQuestion
    var onComplete: () -> Void
    
    @State private var showingFeedback = false
    @State private var isCorrect = false
    @State private var selectedAnswer: Bool? = nil
    
    let greenColor = Color(red: 0.4, green: 0.6, blue: 0.35)
    let redColor = Color(red: 0.85, green: 0.3, blue: 0.3)
    let bgColor = Color(red: 0.95, green: 0.95, blue: 0.96)
    let orangeColor = Color(red: 0.85, green: 0.4, blue: 0.25)
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            // --- MAIN QUIZ CARD ---
            VStack(spacing: 24) {
                Text("Ayo Jawab!")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(orangeColor)
                
                // --- THE FIX: Multiline Text Support ---
                Text(question.questionText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil) // Allow unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // Force vertical growth
                    .padding(.horizontal, 20)
                    .foregroundColor(Color(UIColor.darkText))
                    .frame(maxWidth: 550) // Card width limit
                
                HStack(spacing: 30) {
                    QuizButton(title: "Salah", color: redColor, shadowColor: Color(red: 0.6, green: 0.15, blue: 0.15), isSelected: selectedAnswer == false) {
                        checkAnswer(false)
                    }
                    
                    QuizButton(title: "Benar", color: greenColor, shadowColor: Color(red: 0.25, green: 0.45, blue: 0.2), isSelected: selectedAnswer == true) {
                        checkAnswer(true)
                    }
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 50)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 80)
            .blur(radius: showingFeedback ? 5 : 0)
            
            // --- FEEDBACK POPUP ---
            if showingFeedback {
                Color.black.opacity(0.3).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 80)).foregroundColor(isCorrect ? greenColor : redColor)
                    
                    Text(isCorrect ? "Hebat!" : "Yah, Salah!").font(.title.bold())
                    
                    Button(action: {
                        showingFeedback = false
                        onComplete()
                    }) {
                        Text("Lanjut").font(.headline).foregroundColor(.white)
                            .frame(width: 160, height: 50).background(greenColor).clipShape(Capsule())
                    }
                }
                .padding(40).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 32)).shadow(radius: 20)
            }
        }
    }
    
    private func checkAnswer(_ answer: Bool) {
        selectedAnswer = answer
        isCorrect = (answer == question.correctAnswer)
        withAnimation(.spring()) { showingFeedback = true }
    }
}

struct QuizButton: View {
    let title: String
    let color: Color
    let shadowColor: Color
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.title3.bold()).foregroundColor(.white)
                .frame(width: 140, height: 60).background(color).cornerRadius(20)
                .shadow(color: shadowColor, radius: 0, x: 0, y: 5)
        }
        .scaleEffect(isSelected ? 0.95 : 1.0)
    }
}
