import WidgetKit
import SwiftUI

// 1. THE MODEL
struct SimpleEntry: TimelineEntry {
    let date: Date
    let activeDaysCount: Int
    let missedDaysCount: Int
    
    // We need to calculate these two based on our logic
    var displayEmoji: (Int, String) {
        // This calls the logic we wrote
        return Provider.decideStatus(active: activeDaysCount, missed: missedDaysCount)
    }
}

// 2. THE BRAIN
struct Provider: TimelineProvider {
    
    // Static so the Model can call it easily
    static func decideStatus(active: Int, missed: Int) -> (Int, String) {
        if active >= 3 {
            return (active, "streak_happy")
        } else if missed >= 3 {
            return (missed, "streak_mad")
        } else {
            if missed > 0 {
                return (missed, "streak_neutral")
            } else {
                return (active, "streak_neutral")
            }
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), activeDaysCount: 0, missedDaysCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), activeDaysCount: 5, missedDaysCount: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), activeDaysCount: 5, missedDaysCount: 0)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// 3. THE FACE
struct StreakWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let (number, imageName) = entry.displayEmoji
        
        ZStack {
            // Background Image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            // Text Overlay
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(number)")
                            .font(.system(size: 36, weight: .bold))
                        Text("DAY STREAK")
                            .font(.caption2)
                            .fontWeight(.black)
                    }
                    .padding(8)
                    .background(.white.opacity(0.8))
                    .cornerRadius(8)
                    Spacer()
                }
            }
            .padding(10)
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
        .configurationDisplayName("Folktale Streak")
        .description("Track your daily reading streak!")
    }
}

// 5. THE PREVIEW
#Preview(as: .systemSmall) {
    StreakWidget()
} timeline: {
    SimpleEntry(date: .now, activeDaysCount: 5, missedDaysCount: 0)
    SimpleEntry(date: .now, activeDaysCount: 0, missedDaysCount: 4)
}ir
