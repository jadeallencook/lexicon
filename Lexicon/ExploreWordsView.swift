import SwiftUI

/// Provides an interface for users to explore and selectively add words from the bundled JSON to their curriculum.
/// This view presents each available word that isn't already in the user's collection,
/// allowing them to either add it to their curriculum or skip to the next word.
/// It manages the exploration flow and provides feedback when all words have been reviewed.
struct ExploreWordsView: View {
    @Binding var isPresented: Bool
    let onAddToCurriculum: (Entry) -> Void
    let showBackButton: Bool
    
    @State private var availableWords: [Entry] = []
    @State private var currentIndex = 0
    @State private var isLoading = true
    
    private let userWords: [Entry]
    private let hiddenWordsKey = "hiddenWords"
    
    init(isPresented: Binding<Bool>, userWords: [Entry], onAddToCurriculum: @escaping (Entry) -> Void, showBackButton: Bool = false) {
        self._isPresented = isPresented
        self.userWords = userWords
        self.onAddToCurriculum = onAddToCurriculum
        self.showBackButton = showBackButton
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if isLoading {
                    ProgressView("Loading words...")
                        .foregroundStyle(.white)
                } else if availableWords.isEmpty {
                    VStack(spacing: 16) {
                        Text("🎉")
                            .font(.system(size: 60))
                        
                        Text("All words explored!")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .bold()
                        
                        Text("You've reviewed all available words. Check back later for more content!")
                            .font(.body)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        // Progress indicator
                        HStack {
                            Text("Word \(currentIndex + 1) of \(availableWords.count)")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        
                        // Progress bar
                        ProgressView(value: Double(currentIndex + 1), total: Double(availableWords.count))
                            .tint(.brown)
                        
                        Spacer()
                        
                        // Current word display - homepage style
                        if currentIndex < availableWords.count {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Explore Words")
                                    .font(.largeTitle).bold()
                                    .foregroundStyle(.white)
                                
                                WordDisplayView(
                                    entry: availableWords[currentIndex],
                                    onPronounce: { },
                                    onStop: { },
                                    isSpeaking: false
                                )
                            }
                        }
                        
                        Spacer()
                        
                        // Action buttons
                        HStack(spacing: 12) {
                            Button("Skip") {
                                skipWord()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.gray)
                            .frame(maxWidth: .infinity)
                            
                            Button("Hide") {
                                hideCurrentWord()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            .frame(maxWidth: .infinity)
                            
                            Button("Learn") {
                                addCurrentWord()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(showBackButton ? "Explore Words" : "Explore Words")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(showBackButton ? "Go Back" : "Done") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .task {
            await loadAvailableWords()
        }
    }
    
    private func loadAvailableWords() async {
        isLoading = true
        
        let allWords = WordService.loadVocabularyWords()
        let userWordSet = Set(userWords.map { $0.word.lowercased() })
        let hiddenWordSet = getHiddenWords()
        
        availableWords = allWords.filter { word in
            let wordLower = word.word.lowercased()
            return !userWordSet.contains(wordLower) && !hiddenWordSet.contains(wordLower)
        }
        
        isLoading = false
    }
    
    private func skipWord() {
        if currentIndex < availableWords.count - 1 {
            currentIndex += 1
        } else {
            // No more words to explore
            availableWords = []
        }
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func addCurrentWord() {
        guard currentIndex < availableWords.count else { return }
        
        let word = availableWords[currentIndex]
        onAddToCurriculum(word)
        
        // Remove the added word from available words
        availableWords.remove(at: currentIndex)
        
        // Adjust current index if needed
        if currentIndex >= availableWords.count && currentIndex > 0 {
            currentIndex = availableWords.count - 1
        }
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    private func hideCurrentWord() {
        guard currentIndex < availableWords.count else { return }
        
        let word = availableWords[currentIndex]
        addToHiddenWords(word.word.lowercased())
        
        // Remove the hidden word from available words
        availableWords.remove(at: currentIndex)
        
        // Adjust current index if needed
        if currentIndex >= availableWords.count && currentIndex > 0 {
            currentIndex = availableWords.count - 1
        }
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func getHiddenWords() -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: hiddenWordsKey),
              let hiddenWords = try? JSONDecoder().decode([String].self, from: data) else {
            return Set<String>()
        }
        return Set(hiddenWords)
    }
    
    private func addToHiddenWords(_ word: String) {
        var hiddenWords = Array(getHiddenWords())
        if !hiddenWords.contains(word) {
            hiddenWords.append(word)
            saveHiddenWords(hiddenWords)
        }
    }
    
    private func saveHiddenWords(_ words: [String]) {
        do {
            let data = try JSONEncoder().encode(words)
            UserDefaults.standard.set(data, forKey: hiddenWordsKey)
        } catch {
            print("Error saving hidden words: \(error)")
        }
    }
}
