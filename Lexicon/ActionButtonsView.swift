import SwiftUI

/// Provides the main action buttons for interacting with vocabulary words in the Lexicon app.
/// This view component displays buttons for core app functionality including shuffling words,
/// studying vocabulary, and managing the word collection through a centralized interface.
struct ActionButtonsView: View {
    let onShuffle: () -> Void
    let onStudy: () -> Void
    let onManageWords: () -> Void
    let isDisabled: Bool
    let hasWords: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if hasWords {
                HStack(spacing: 12) {
                    Button("Shuffle") {
                        onShuffle()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.brown)
                    .disabled(isDisabled)
                    
                    Button("Study") {
                        onStudy()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    
                    Spacer()
                }
            }
            
            HStack(spacing: 12) {
                Button("Manage Words") {
                    onManageWords()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
                Spacer()
            }
        }
        .padding(.top, 16)
    }
}