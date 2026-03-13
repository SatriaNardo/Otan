import Foundation

// A reusable model for a single True/False question
struct QuizQuestion: Identifiable {
    let id = UUID()
    let questionText: String
    let correctAnswer: Bool
}

// --- NEW: A model for a single page of the story ---
struct StoryPage: Identifiable {
    let id = UUID()
    let text: String
    let imageName: String // Each page gets its own image!
}

enum BookCategory: String, CaseIterable {
    case a = "Animals"
    case b = "Bedtime"
    case c = "Nature"
    case d = "Geooo"
    case e = "BEooo"
    case f = "Reoooo"
}

enum Duration: String, CaseIterable {
    case low = "3-5 Minutes"
    case medium = "5-7 Minutes"
    case high = "7-10 Minutes"
}

// --- 1. THE UPDATED BLUEPRINT ---
struct Book: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String // This stays here as the "Cover Image" for the library
    let category: BookCategory
    let duration: Duration
    let storyPages: [StoryPage] // <-- Updated from [String] to [StoryPage]
    let quizQuestions: [QuizQuestion]
}

// --- 2. THE UPDATED DATABASE ---
let mockBooks = [
    // --- CATEGORY A ---
    Book(title: "The Sleepy Bear", imageName: "bear", category: .a, duration: .low, storyPages: [
        // Now each page has text AND an image
        StoryPage(text: "It was a quiet night, and the sleepy bear found a cozy spot to sleep.", imageName: "Solaris"),
        StoryPage(text: "He closed his eyes, and soon he was fast asleep...", imageName: "grraf")
    ], quizQuestions: [
        QuizQuestion(questionText: "The bear was a noisy tiger?", correctAnswer: false),
        QuizQuestion(questionText: "The bear went to sleep?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),
    
    Book(title: "The Lost Kitten", imageName: "cat", category: .a, duration: .low, storyPages: [
        StoryPage(text: "A small kitten got separated from its mother in the big city.", imageName: "kitten_page1"),
        StoryPage(text: "It wandered the streets alone, looking for a warm place to rest...", imageName: "kitten_page2")
    ], quizQuestions: [
        QuizQuestion(questionText: "The kitten was a big dog?", correctAnswer: false),
        QuizQuestion(questionText: "The city was very quiet?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),
    
    Book(title: "The Brave Puppy", imageName: "cat", category: .a, duration: .low, storyPages: [
        StoryPage(text: "The puppy saw a big shadow and growled bravely.", imageName: "puppy_page1"),
        StoryPage(text: "It was just a small bird, but the puppy felt like a hero!", imageName: "puppy_page2")
    ], quizQuestions: [
        QuizQuestion(questionText: "The puppy was scared?", correctAnswer: false),
        QuizQuestion(questionText: "The shadow was a bird?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ])
    
    // Note: You will need to update Categories B, C, D, E, and F in your own file using this same `StoryPage(text: "", imageName: "")` format!
]
