import Foundation

/// Provides data loading services for vocabulary words in the Lexicon app.
/// This service class handles loading word entries from JSON files bundled with
/// the app, providing access to the pre-loaded vocabulary collection that users
/// can explore and selectively add to their personal learning curriculum.
class WordService {
    static func loadVocabularyWords() -> [Entry] {
        guard let url = Bundle.main.url(forResource: "vocabulary", withExtension: "json") else {
            print("JSON file not found in bundle")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Entry].self, from: data)
        } catch {
            print("Error loading JSON: \(error)")
            return []
        }
    }
}