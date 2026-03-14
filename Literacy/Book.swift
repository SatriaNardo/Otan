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
    case a = "Alam"
    case b = "Sosial"
    case c = "Matematika"
    case d = "Kesehatan"
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
    Book(title: "Tito Tupai Belajar Berhitung", imageName: "tito-cover", category: .c, duration: .low, storyPages: [
        StoryPage(
            text: """
                Di sebuah hutan hijau yang tenang,
                tinggal seekor tupai kecil bernama Tito.
                Tito sangat suka mengumpulkan kacang.
                """,
                  imageName: "tito-p-1"),
        StoryPage(
            text: """
                Hobi Tito adalah mengumpulkan kacang yang jatuh di tanah.
                Dia selalu mencari kacang yang paling besar dan berwarna cokelat.
                """,
            imageName: "tito-p-2"
        ),
        StoryPage(
            text: """
                "Wuuusss!" Angin bertiup kencang sekali siang itu. Tiba-tiba, banyak sekali kacang jatuh dari atas pohon
                """,
            imageName: "tito-p-3"
        ),
        StoryPage(
            text: """
                Tito ingin mengumpulkan semua kacang itu ke rumahnya. Tapi, Tito merasa bingung karena jumlahnya terlalu banyak.
                """,
            imageName: "tito-p-4"
        ),
        StoryPage(
            text: """
                Tito mencoba menghitung semua kacang itu sendirian. "Satu... dua... lalu berapa lagi ya?" tanya Tito sedih.
                """,
            imageName: "tito-p-5"
        ),
        StoryPage(
            text: """
                Tiba-tiba, datanglah Lala si kelinci yang sangat baik hati. "Halo Tito, apa yang sedang kamu lakukan?" tanya Lala ramah.
                """,
            imageName: "tito-p-6"
        ),
        StoryPage(
            text: """
                Lala ingin membantu sahabatnya itu menghitung semua kacang. "Ayo kita hitung bersama, Tito!" kata Lala dengan semangat.
                """,
            imageName: "tito-p-7"
        ),
        StoryPage(
            text: """
                Lala mulai menunjuk kacang-kacang itu satu per satu. "Satu, dua, tiga," ucap Lala dengan suara yang pelan.
                """,
            imageName: "tito-p-8"
        ),
        StoryPage(
            text: """
                "Empat, lima!" seru Tito dengan perasaan sangat gembira. Sekarang Tito sudah tahu berapa jumlah semua kacang miliknya.
                """,
            imageName: "tito-p-9"
        ),
        StoryPage(
            text: """
                Tito dan Lala makan kacang bersama di bawah pohon. Belajar berhitung ternyata terasa sangat menyenangkan!
                """,
            imageName: "tito-p-10"
        ),
    ], quizQuestions: [
        QuizQuestion(questionText: "Apakah nama tupai di cerita ini adalah Tito?", correctAnswer: true),
        QuizQuestion(questionText: "Apakah Tito mengumpulkan daun?", correctAnswer: false),
        QuizQuestion(questionText: "Apakah Tito bisa berhitung?", correctAnswer: true),
        QuizQuestion(questionText: "Apakah berhitung seperti Tito membuat ia senang?", correctAnswer: true),
        QuizQuestion(questionText: "Apakah Lala sudah melakukan hal yang tepat untuk membantu Tito?", correctAnswer: true)
    ]),
    
    Book(
        title: "Mimi Berbagi Mainannya",
        imageName: "mimi-cover",
        category: .b,
        duration: .low,
        storyPages: [
            StoryPage(
                text: """
                    Di sebuah rumah, tinggal seekor
                    kucing kecil nama Mimi. Dia
                    punya banyak mainan: bola
                    merah, boneka tikus, pita warna-warni,
                    dan mobil-mobilan.
                    """,
                imageName: "mimi-p-1"
            ),
            StoryPage(
                text: """
                    Mimi sangat menyukainya. "Ini milikku
                    paling seru!" kata Mimi dengan bangga.
                    """,
                imageName: "mimi-p-2"
            ),
            StoryPage(
                text: """
                    Suatu hari, teman-teman Mimi datang
                    berkunjung. Ada Kiko si Kelinci dan
                    Toto si Kura-kura. Mereka melihat
                    mainan Mimi.
                    """,
                imageName: "mimi-p-3"
            ),
            StoryPage(
                text: """
                    "Bolehkah kami main bersama?" tanya
                    mereka.
                    """,
                imageName: "mimi-p-4"
            ),
            StoryPage(
                text: """
                    Mimi langsung memeluk semua
                    mainannya sekaligus. "Tidak boleh! Ini
                    milikku!" kata Mimi.
                    """,
                imageName: "mimi-p-5"
            ),
            StoryPage(
                text: """
                    Akhirnya, Kiko dan Toto pergi bermain
                    di luar. Mimi mendengar suara tertawa
                    mereka. Tapi Mimi tetap diam di dalam
                    rumah.
                    """,
                imageName: "mimi-p-6"
            ),
            StoryPage(
                text: """
                    Mimi mencoba bermain sendirian. Dia
                    mendorong mobil, menggigit boneka
                    tikus. Tapi semuanya terasa sepi. Mimi
                    merasa sedih.
                    """,
                imageName: "mimi-p-7"
            ),
            StoryPage(
                text: """
                    Dari jendela, Mimi melihat teman-
                    temannya sedang bermain kejar-
                    kejaran. Mereka terlihat sangat bahagia.
                    """,
                imageName: "mimi-p-8"
            ),
            StoryPage(
                text: """
                    Mimi mendekati teman-temannya.
                    "Maaf ya, aku tidak mau berbagi tadi.
                    Boleh aku ikut main?"
                    """,
                imageName: "mimi-p-9"
            ),
            StoryPage(
                text: """
                    Kiko dan Toto tersenyum lebar. "Tentu
                    saja Mimi! Mari bermain bersama!"
                    Sekarang Mimi tidak kesepian lagi.
                    Bermain bersama-sama jauh lebih
                    bahagia.
                    """,
                imageName: "mimi-p-10"
            )
        ],
        quizQuestions: [
            QuizQuestion(questionText: "Apakah Mimi punya banyak mainan?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah Mimi awalnya tidak mau berbagi mainannya?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah Mimi akhirnya bermain bersama Kiki dan Toto?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah Mimi merasa sedih saat bermain sendirian?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah berbagi dengan teman membuat bermain lebih menyenangkan?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah kita sebaiknya berbagi dengan teman kita?", correctAnswer: true)
        ]
    ),
    
    Book(
        title: "Bolu Makadamia Istimewa",
        imageName: "bolu-cover",
        category: .a,
        duration: .low,
        storyPages: [
            StoryPage(
                text: """
                    Nanti siang Bapak pulang.
                    Hati Bita sungguh senang.
                    """,
                imageName: "bolu-p-1"
            ),
            StoryPage(
                text: """
                    Bita ingin membuat bolu
                    makadamia. Itu bolu kesukaan Bapak.
                    Namun, makadamianya habis.
                    """,
                imageName: "bolu-p-2"
            ),
            StoryPage(
                text: """
                    Bita bisa memetik
                    makadamia.
                    Kait dan goyangkan dahan!
                    """,
                imageName: "bolu-p-3"
            ),
            StoryPage(
                text: "Hore!",
                imageName: "bolu-p-4"
            ),
            StoryPage(
                text: """
                    Buah yang muda terlalu
                    lunak.
                    Rasanya pun tidak enak.
                    """,
                imageName: "bolu-p-5"
            ),
            StoryPage(
                text: """
                    Bita mencari buah yang tua.
                    Bagaimana cara
                    membukanya?
                    """,
                imageName: "bolu-p-6"
            ),
            StoryPage(
                text: """
                    Tekan makadamia kuat-
                    kuat.
                    Aduh! Buahnya mencelat
                    Hap!
                    Bita sigap menangkap
                    makadamia.
                    """,
                imageName: "bolu-p-7"
            ),
            StoryPage(
                text: """
                    Aha!
                    Bita tahu.
                    Buka saja dengan batu.
                    """,
                imageName: "bolu-p-8"
            ),
            StoryPage(
                text: "Ternyata tidak mudah.",
                imageName: "bolu-p-9"
            ),
            StoryPage(
                text: """
                    Bagaimana jika meminjam
                    alat itu?
                    Itu pemecah kemiri milik
                    Ibu.
                    """,
                imageName: "bolu-p-10"
            ),
            StoryPage(
                text: """
                    Berhasil!
                    Bita, adik, dan Ibu bekerja
                    sama.
                    """,
                imageName: "bolu-p-11"
            ),
            StoryPage(
                text: """
                    Adonan bolu sudah siap.
                    Taburkan irisan buah
                    makadamia.
                    Tabur ... tabur!
                    """,
                imageName: "bolu-p-12"
            ),
            StoryPage(
                text: """
                    Bita sabar menunggu bolu
                    matang.
                    Aroma bolu sedap sekali!
                    """,
                imageName: "bolu-p-13"
            ),
            StoryPage(
                text: """
                    Bolu makadamia sudah
                    matang.
                    Bapak pasti senang.
                    """,
                imageName: "bolu-p-14"
            )
        ],
        quizQuestions: [
            QuizQuestion(questionText: "Apakah bolu makanan kesukaan bapak?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah makadamia bisa berasal dari atas dahan?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah buah makadamia muda lebih enak dari yang tua?", correctAnswer: false),
            QuizQuestion(questionText: "Apakah ibu, adik, dan kakak bekerja sama di rumah?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah penting untuk saling bekerja sama di rumah?", correctAnswer: true)
        ]
    ),
    Book(
        title: "Mendengarkan Tubuhku",
        imageName: "mendengarkan-cover",
        category: .d,
        duration: .low,
        storyPages: [
            StoryPage(text: "Hari ini aku tidak masuk sekolah.", imageName: "mendengarkan-p-1"),
            StoryPage(text: "Asik, hari ini libur!", imageName: "mendengarkan-p-2"),
            StoryPage(text: "Tapi aku tidak akan nonton TV.", imageName: "mendengarkan-p-3"),
            StoryPage(text: "Kebetulan listriknya mati.", imageName: "mendengarkan-p-4"),
            StoryPage(text: "Apa yang bisa kulakukan ya?", imageName: "mendengarkan-p-5"),
            StoryPage(text: "Ah, aku mau mendengarkan tubuhku!", imageName: "mendengarkan-p-6"),
            StoryPage(
                text: """
                    Pertama, aku harus diam
                    dan tidak
                    bersuara. Sehingga aku bisa
                    mendengarkan tubuhku
                    sendiri.
                    """,
                imageName: "mendengarkan-p-7"
            ),
            StoryPage(
                text: """
                    Sekarang aku bisa
                    mendengarkan
                    nafasku.
                    Tarik... hembuskan... tarik...
                    hembuskan...
                    """,
                imageName: "mendengarkan-p-8"
            ),
            StoryPage(
                text: """
                    Dan aku bisa membuatnya
                    terdengar lebih keras ...
                    Ssssssss!
                    Atau lebih lembut ...
                    Mmmmmm
                    """,
                imageName: "mendengarkan-p-9"
            ),
            StoryPage(
                text: """
                    Lalu aku mendengarkan
                    degup jantungku.
                    Digdug, digdug, digdug.
                    """,
                imageName: "mendengarkan-p-10"
            ),
            StoryPage(
                text: """
                    Bisakah aku membuatnya
                    berdegup lebih kencang
                    dan keras?
                    Tentu saja, dengan
                    melompat-lompat dua
                    puluh kali.
                    """,
                imageName: "mendengarkan-p-11"
            ),
            StoryPage(
                text: """
                    Nah, sekarang jantungku
                    berdebar lebih kencang.
                    Dagdigdug, dagdigdug,
                    dagdigdug!
                    """,
                imageName: "mendengarkan-p-12"
            ),
            StoryPage(
                text: """
                    Kalau aku meletakkan
                    jari-jariku di pergelangan
                    tanganku, aku bisa
                    merasakan denyut nadiku.
                    """,
                imageName: "mendengarkan-p-13"
            ),
            StoryPage(
                text: """
                    Aku bisa mendengarkan
                    tawaku sendiri.
                    Hahahaha!
                    """,
                imageName: "mendengarkan-p-14"
            ),
            StoryPage(
                text: """
                    Juga tangisku.
                    Huhuhuhu!
                    """,
                imageName: "mendengarkan-p-15"
            ),
            StoryPage(
                text: """
                    Demikian pula tepukan
                    tanganku.
                    Plok plok plok.
                    """,
                imageName: "mendengarkan-p-16"
            ),
            StoryPage(
                text: """
                    Namun semua suara itu tak
                    bisa mengalahkan suara
                    perutku yang keroncongan.
                    Kruyuk kruyuk kruyuk...
                    """,
                imageName: "mendengarkan-p-17"
            ),
            StoryPage(text: "Pertanda aku perlu makan.", imageName: "mendengarkan-p-18"),
            StoryPage(text: "Hidungku bisa mencium gorengan di dapur.", imageName: "mendengarkan-p-19"),
            StoryPage(
                text: """
                    Menyenangkan sekali
                    permainan ini.
                    Sekarang aku ingin
                    mendengar suara gigiku
                    mengunyah.
                    """,
                imageName: "mendengarkan-p-20"
            ),
            StoryPage(
                text: """
                    Dan juga suara perutku
                    mengolah kue Jalebi
                    (makanan khas India)
                    buatan ibu.
                    """,
                imageName: "mendengarkan-p-21"
            ),
            StoryPage(
                text: "Cocokkan suara dengan bagian tubuh Tangan Bersiul Bibir Tepuk tangan Kaki Hentakan",
                imageName: "mendengarkan-p-22"
            ),
        ],
        quizQuestions: [
            QuizQuestion(questionText: "Apakah nafas bisa didengar dari hembusan?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah jantung bisa berdegup? Kamu bisa tirukan bunyinya!", correctAnswer: true),
            QuizQuestion(questionText: "Apakah jantung bisa berdegup lebih kencang lagi?", correctAnswer: true),
            QuizQuestion(questionText: "Apakah matamu yang membuatmu bisa mendengar?", correctAnswer: false),
            QuizQuestion(questionText: "Apakah perut yang keroncongan butuh makan?", correctAnswer: true)
        ]
    )
    
    // Note: You will need to update Categories B, C, D, E, and F in your own file using this same `StoryPage(text: "", imageName: "")` format!
]
