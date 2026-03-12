import WidgetKit
import SwiftUI

// 1. THE MODEL
struct SimpleEntry: TimelineEntry {
    let date: Date
    let activeDaysCount: Int
    let missedDaysCount: Int
    
    // Calculates which image to show based on the counts.
    var imageName: String {
        let (_, name) = Provider.decideStatus(active: activeDaysCount, missed: missedDaysCount)
        return name
    }

    // Line 1: The Number + The Status ("5 Days Away" or "3 Days Streak")
    var headerText: String {
        if missedDaysCount > 0 {
            let dayWord = missedDaysCount == 1 ? "Day" : "Days"
            return "\(missedDaysCount) \(dayWord) Away"
        } else {
            // This handles the grammar for "1 Day" vs "2 Days" perfectly
            let dayWord = activeDaysCount == 1 ? "Day" : "Days"
            return "\(activeDaysCount) \(dayWord) Streak"
        }
    }
    
    // Line 2: The Encouraging Description
    var descriptionText: String {
        if missedDaysCount > 0 {
            if missedDaysCount > 2 {
                return "Don't make Otan wait!" // The angry/urgent state
            } else {
                return "Time to read!" // The tired state
            }
        } else {
            if activeDaysCount > 1 {
                return "Amazing job!" // The happy state
            } else {
                return "Story time!" // The neutral/day 1 state
            }
        }
    }
}

// 2. THE BRAIN
struct Provider: TimelineProvider {
    
    // Updated 4-Tier Logic
    static func decideStatus(active: Int, missed: Int) -> (Int, String) {
        if missed > 0 {
            // OFFLINE LOGIC
            if missed > 2 {
                return (missed, "streak_mad") // More than 2 days offline
            } else {
                return (missed, "streak_tired") // 1-2 days offline
            }
        } else {
            // ACTIVE STREAK LOGIC
            if active > 1 {
                return (active, "streak_happy") // 2 or more days active
            } else {
                return (active, "streak_neutral") // 0-1 day active
            }
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), activeDaysCount: 0, missedDaysCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), activeDaysCount: 2, missedDaysCount: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // In the future, this is where we call StreakManager.getStreakStats()
        // Currently hardcoded to test offline mode
        let entry = SimpleEntry(date: Date(), activeDaysCount: 0, missedDaysCount: 5)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// 3. THE FACE
struct StreakWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // 1. Background Image
            Image(entry.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            // 2. Text Overlay (Top Center)
            VStack {
                VStack(spacing: 2) { // Tightened spacing from 4 to 2
                    
                    // First Line: Header Text
                    Text(entry.headerText)
                        .font(.system(size: 16, weight: .heavy, design: .rounded)) // Scaled down from 20 to 16
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                    
                    // Second Line: Description
                    Text(entry.descriptionText)
                        .font(.system(size: 11, weight: .bold, design: .rounded)) // Scaled down from 14 to 11
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                }
                .padding(.top, 14)
                
                Spacer()
            }
        }
    }
}

// 4. THE SETUP
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
        .configurationDisplayName("Otan Streak")
        .description("Track your daily reading streak!")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

// 5. THE PREVIEW
#Preview(as: .systemSmall) {
    StreakWidget()
} timeline: {
    SimpleEntry(date: .now, activeDaysCount: 3, missedDaysCount: 0) // Tests Happy
    SimpleEntry(date: .now, activeDaysCount: 0, missedDaysCount: 3) // Tests Mad
    SimpleEntry(date: .now, activeDaysCount: 0, missedDaysCount: 1) // Tests Tired
    SimpleEntry(date: .now, activeDaysCount: 1, missedDaysCount: 0) // Tests Neutral
}
