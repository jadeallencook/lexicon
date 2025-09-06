import SwiftUI

/// Displays a loading indicator while the app is fetching vocabulary words.
/// This view component shows a progress spinner with descriptive text to inform
/// users that word data is being loaded, providing visual feedback during the
/// initial app startup or data refresh operations.
struct LoadingView: View {
    var body: some View {
        ProgressView("Loading words...")
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}