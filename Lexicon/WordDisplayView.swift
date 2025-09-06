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
        VStack(alignment: .leading, spacing: 0) {
            // Top section: word, function, speaker, definition
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.word.capitalized)
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("(\(entry.function))")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        if isSpeaking {
                            onStop()
                        } else {
                            onPronounce()
                        }
                    } label: {
                        Image(systemName: isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                }
                
                Text(entry.definition)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(3)
            }
            
            Spacer()
            
            // Bottom section: example anchored at bottom
            Text(entry.example)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.gray)
                .italic()
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(24)
        .frame(height: 240)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal, 0)
    }
    
}