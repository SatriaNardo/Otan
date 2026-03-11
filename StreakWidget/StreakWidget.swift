import WidgetKit
import SwiftUI

// 1. THE MODEL
struct SimpleEntry: TimelineEntry {
    let date: Date
    let currentStreak: Int
    let imageName: String
}

// 2. THE BRAIN (Backend)
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), currentStreak: 0, imageName: "neutral_character")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), currentStreak: 5, imageName: "happy_character")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // For now, we just create one single snapshot for right now
        let entry = SimpleEntry(date: Date(), currentStreak: 5, imageName: "happy_character")
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// 3. THE FACE (Frontend)
struct StreakWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Streak: \(entry.currentStreak)")
                .font(.headline)
            Text("Image: \(entry.imageName)")
                .font(.caption)
        }
    }
}

// 4. THE WIDGET SETUP
struct StreakWidget: Widget {
    let kind: String = "StreakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                StreakWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                StreakWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Folktale Streak")
        .description("Track your daily reading streak!")
    }
}

// 5. THE PREVIEW (What you see in Xcode)
#Preview(as: .systemSmall) {
    StreakWidget()
} timeline: {
    SimpleEntry(date: .now, currentStreak: 5, imageName: "happy_character")
}
