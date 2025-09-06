import Foundation
import SwiftUI

/// Main view model for the Lexicon app that manages vocabulary word data and user interactions.
/// This ObservableObject handles loading words from various sources, managing the current
/// displayed word, user-added words, and provides methods for word shuffling and persistence.
/// It coordinates between the WordService for loading bundled words and UserDefaults for
/// storing user-created vocabulary entries.
@MainActor
class LexiconViewModel: ObservableObject {
    @Published var words: [Entry] = []
    @Published var currentEntry: Entry?
    @Published var isLoading = true
    @Published var userWords: [Entry] = []
    
    private let userWordsKey = "userWords"
    
    func loadWords() async {
        isLoading = true
        let savedUserWords = loadUserWords()
        
        userWords = savedUserWords
        words = savedUserWords
        currentEntry = words.randomElement()
        isLoading = false
    }
    
    func shuffleWord() {
        guard !words.isEmpty else { return }
        currentEntry = words.randomElement()
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    func addWord(_ entry: Entry) {
        userWords.append(entry)
        words.append(entry)
        saveUserWords()
        
        // Set the new word as current
        currentEntry = entry
    }
    
    func deleteCurrentWord() {
        guard let current = currentEntry,
              let index = userWords.firstIndex(where: { $0.word == current.word }) else { return }
        
        userWords.remove(at: index)
        words.remove(at: index)
        saveUserWords()
        
        // Set new current word or nil if no words left
        currentEntry = words.randomElement()
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    func saveUserWords() {
        do {
            let data = try JSONEncoder().encode(userWords)
            UserDefaults.standard.set(data, forKey: userWordsKey)
        } catch {
            print("Error saving user words: \(error)")
        }
    }
    
    private func loadUserWords() -> [Entry] {
        guard let data = UserDefaults.standard.data(forKey: userWordsKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Entry].self, from: data)
        } catch {
            print("Error loading user words: \(error)")
            return []
        }
    }
}