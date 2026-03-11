import Foundation

// A reusable model for a single True/False question
struct QuizQuestion: Identifiable {
    let id = UUID()
    let questionText: String
    let correctAnswer: Bool // true for True, false for False
}

enum BookCategory: String, CaseIterable {
    case a = "Animals"
    case b = "Bedtime"
    case c = "Nature"
    case d = "Geooo"
    case e = "BEooo"
    case f = "Reoooo"
}

// --- 1. THE UPDATED BLUEPRINT ---
struct Book: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let category: BookCategory
    // An array of strings, where each string represents one page of story text.
    // This allows for books with different lengths of content.
    let storyPages: [String]
        
    // The set of True/False quiz questions for this book
    let quizQuestions: [QuizQuestion]
}

// --- 2. THE UPDATED DATABASE ---
let mockBooks = [
    // --- CATEGORY A ---
    Book(title: "The Sleepy Bear", imageName: "bear", category: .a, storyPages: [
        "It was a quiet night, and the sleepy bear found a cozy spot to sleep.",
        "He closed his eyes, and soon he was fast asleep..."
    ], quizQuestions: [
        QuizQuestion(questionText: "The bear was a noisy tiger?", correctAnswer: false),
        QuizQuestion(questionText: "The bear went to sleep?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),
    Book(title: "The Lost Kitten", imageName: "kitten", category: .a, storyPages: [
        "A small kitten got separated from its mother in the big city.",
        "It wandered the streets alone, looking for a warm place to rest..."
    ], quizQuestions: [
        QuizQuestion(questionText: "The kitten was a big dog?", correctAnswer: false),
        QuizQuestion(questionText: "The city was very quiet?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),
    Book(title: "The Brave Puppy", imageName: "puppy", category: .a, storyPages: [
        "The puppy saw a big shadow and growled bravely.",
        "It was just a small bird, but the puppy felt like a hero!"
    ], quizQuestions: [
        QuizQuestion(questionText: "The puppy was scared?", correctAnswer: false),
        QuizQuestion(questionText: "The shadow was a bird?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),

    // --- CATEGORY B ---
    Book(title: "Sunny Meadows", imageName: "meadow", category: .b, storyPages: [
        "Flowers bloom in the sun. The grass is very green.",
        "Butterflies fly over the meadow all day long."
    ], quizQuestions: [
        QuizQuestion(questionText: "Is the grass blue?", correctAnswer: false),
        QuizQuestion(questionText: "Do butterflies fly there?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),
    Book(title: "The Quiet Forest", imageName: "forest", category: .b, storyPages: [
        "The trees are tall and the air is fresh.",
        "Deep in the forest, you can hear the river flowing."
    ], quizQuestions: [
        QuizQuestion(questionText: "Are the trees short?", correctAnswer: false),
        QuizQuestion(questionText: "Is there a river?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),
    Book(title: "Deep Blue Sea", imageName: "sea", category: .b, storyPages: [
        "Fish swim fast in the blue water.",
        "The whale is the king of the ocean."
    ], quizQuestions: [
        QuizQuestion(questionText: "Is the water red?", correctAnswer: false),
        QuizQuestion(questionText: "Is the whale the king?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),

    // --- CATEGORY C ---
    Book(title: "Rocket to Mars", imageName: "rocket", category: .c, storyPages: [
        "The rocket goes 3, 2, 1... Blast off!",
        "Soon, the astronauts will see the red planet."
    ], quizQuestions: [
        QuizQuestion(questionText: "Is Mars the red planet?", correctAnswer: true),
        QuizQuestion(questionText: "Did the rocket explode?", correctAnswer: false),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),
    Book(title: "Jungle Trek", imageName: "jungle", category: .c, storyPages: [
        "The monkey swings from the vines.",
        "Watch out for the sleeping tiger under the tree!"
    ], quizQuestions: [
        QuizQuestion(questionText: "Does the monkey swing?", correctAnswer: true),
        QuizQuestion(questionText: "Is the tiger awake?", correctAnswer: false),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),
    Book(title: "Mountain High", imageName: "mountain", category: .c, storyPages: [
        "The snow on top of the mountain is cold.",
        "We can see the whole world from up here."
    ], quizQuestions: [
        QuizQuestion(questionText: "Is the mountain snow hot?", correctAnswer: false),
        QuizQuestion(questionText: "Can we see far away?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),

    // --- CATEGORY D ---
    Book(title: "Baking Cake", imageName: "cake", category: .d, storyPages: [
        "Mix the flour and the eggs in a big bowl.",
        "The oven is hot, and the cake smells delicious."
    ], quizQuestions: [
        QuizQuestion(questionText: "Do we use eggs?", correctAnswer: true),
        QuizQuestion(questionText: "Is the oven cold?", correctAnswer: false),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),
    Book(title: "First Day School", imageName: "school", category: .d, storyPages: [
        "I have my new bag and my shiny shoes.",
        "The teacher smiled and said welcome to class."
    ], quizQuestions: [
        QuizQuestion(questionText: "Is it the first day?", correctAnswer: true),
        QuizQuestion(questionText: "Was the teacher mean?", correctAnswer: false),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),
    Book(title: "The Little Garden", imageName: "garden", category: .d, storyPages: [
        "I plant a small seed in the dark dirt.",
        "With water and sun, it will grow into a flower."
    ], quizQuestions: [
        QuizQuestion(questionText: "Do seeds need water?", correctAnswer: true),
        QuizQuestion(questionText: "Do seeds need ice?", correctAnswer: false),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),

    // --- CATEGORY E ---
    Book(title: "How Rain Falls", imageName: "rain", category: .e, storyPages: [
        "Clouds get heavy with water and turn gray.",
        "Then the drops fall down to water the plants."
    ], quizQuestions: [
        QuizQuestion(questionText: "Are rain clouds light?", correctAnswer: false),
        QuizQuestion(questionText: "Does rain help plants?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),
    Book(title: "Busy Bees", imageName: "bees", category: .e, storyPages: [
        "Bees fly to flowers to find sweet nectar.",
        "They take it back to the hive to make honey."
    ], quizQuestions: [
        QuizQuestion(questionText: "Do bees make milk?", correctAnswer: false),
        QuizQuestion(questionText: "Do they find nectar?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),
    Book(title: "Seed to Tree", imageName: "tree", category: .e, storyPages: [
        "An acorn falls from a tall oak tree.",
        "In many years, it will be a giant tree too."
    ], quizQuestions: [
        QuizQuestion(questionText: "Is an oak tree small?", correctAnswer: false),
        QuizQuestion(questionText: "Does the acorn grow?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),

    // --- CATEGORY F ---
    Book(title: "The Brave Knight", imageName: "knight", category: .f, storyPages: [
        "The knight has a shiny sword and a shield.",
        "He protects the castle from the scary giant."
    ], quizQuestions: [
        QuizQuestion(questionText: "Does the knight have a shield?", correctAnswer: true),
        QuizQuestion(questionText: "Is the giant friendly?", correctAnswer: false),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ]),
    Book(title: "Magic Wand", imageName: "wand", category: .f, storyPages: [
        "Wave the wand and say the magic words.",
        "The frog turned into a handsome prince!"
    ], quizQuestions: [
        QuizQuestion(questionText: "Did the prince turn into a frog?", correctAnswer: false),
        QuizQuestion(questionText: "Is the wand magic?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: false)
    ]),
    Book(title: "Friendly Dragon", imageName: "dragon", category: .f, storyPages: [
        "The dragon does not breathe fire; he breathes bubbles.",
        "He loves to fly through the clouds with his friends."
    ], quizQuestions: [
        QuizQuestion(questionText: "Does the dragon breathe fire?", correctAnswer: false),
        QuizQuestion(questionText: "Does he breathe bubbles?", correctAnswer: true),
        QuizQuestion(questionText: "Lorem Ipsum question?", correctAnswer: true)
    ])
]
