import SwiftUI

/// Displays a message when no vocabulary words are available to show.
/// This view component provides user feedback when the word list is empty,
/// which can occur if word loading fails or no words have been added to the app.
/// It serves as a placeholder to maintain good user experience during error states.
struct EmptyStateView: View {
    var body: some View {
        Text("No words available")
            .foregroundStyle(.white)
    }
}