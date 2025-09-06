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
        VStack(spacing: 16) {
            if hasWords {
                HStack(spacing: 16) {
                    Button("Shuffle") {
                        onShuffle()
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .disabled(isDisabled)
                    
                    Button("Study") {
                        onStudy()
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
            }
            
            Button("Manage Words") {
                onManageWords()
            }
            .buttonStyle(.plain)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .padding(.top, 16)
    }
}