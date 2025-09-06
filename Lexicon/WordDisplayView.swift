import SwiftUI

/// Displays a vocabulary word entry with formatted text showing the word, its grammatical function, definition, and usage example.
/// This view component is responsible for presenting word information in a clean, readable format
/// with appropriate styling and spacing for the main word display area of the Lexicon app.
struct WordDisplayView: View {
    let entry: Entry
    let onPronounce: () -> Void
    let onStop: () -> Void
    let isSpeaking: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(headerText(for: entry))
                    .font(.callout).bold()
                    .foregroundStyle(.brown)
                
                Button {
                    if isSpeaking {
                        onStop()
                    } else {
                        onPronounce()
                    }
                } label: {
                    Image(systemName: isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .foregroundColor(.brown)
                        .font(.callout)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            
            Text(entry.definition)
                .font(.callout)
                .foregroundStyle(.white)
                .bold()
            
            Text(entry.example)
                .font(.footnote)
                .foregroundStyle(.white)
                .padding(.top, 8)
        }
        .frame(height: 120, alignment: .top)
        .padding(.vertical, 3)
    }
    
    private func headerText(for entry: Entry) -> String {
        let word = entry.word.capitalized
        return "\(word) (\(entry.function))"
    }
}