//
//  LexiconWidget.swift
//  LexiconWidget
//
//  Created by Jade Allen Cook on 9/6/25.
//

import WidgetKit
import SwiftUI

struct LexiconWidget: Widget {
    let kind: String = "LexiconWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LexiconWidgetEntryView(entry: entry)
                .containerBackground(.black, for: .widget)
        }
        .configurationDisplayName("Lexicon Word")
        .description("Learn a new vocabulary word every few minutes.")
        .supportedFamilies([.systemMedium])
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), entry: WordEntry(
            word: "lexicon",
            function: "noun",
            definition: "The vocabulary of a person, language, or branch of knowledge.",
            example: "The technical lexicon of computer science can be challenging for beginners."
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), entry: getRandomUserWord())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // Generate entries for the next 2 hours, refreshing every 5 minutes
        for minuteOffset in stride(from: 0, to: 120, by: 5) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let wordEntry = SimpleEntry(date: entryDate, entry: getRandomUserWord())
            entries.append(wordEntry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getRandomUserWord() -> WordEntry {
        let userWords = loadUserWords()
        return userWords.randomElement() ?? WordEntry(
            word: "lexicon",
            function: "noun", 
            definition: "The vocabulary of a person, language, or branch of knowledge.",
            example: "Add words to your vocabulary to see them here."
        )
    }
    
    private func loadUserWords() -> [WordEntry] {
        guard let data = UserDefaults.standard.data(forKey: "userWords") else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([WordEntry].self, from: data)
        } catch {
            print("Error loading user words in widget: \(error)")
            return []
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let entry: WordEntry
}

struct LexiconWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(entry.entry.word.capitalized)
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text("(\(entry.entry.function))")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
                
                Spacer()
            }
            
            Text(entry.entry.definition)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(nil)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

#Preview(as: .systemMedium) {
    LexiconWidget()
} timeline: {
    SimpleEntry(date: .now, entry: WordEntry(
        word: "serendipity",
        function: "noun", 
        definition: "The occurrence and development of events by chance in a happy or beneficial way.",
        example: "A fortunate stroke of serendipity brought the two old friends together."
    ))
}
