import Foundation

/// Represents a dictionary entry with word information including its definition and usage example.
/// This struct is used to store vocabulary words along with their grammatical function,
/// meaning, and contextual examples for the Lexicon app.
struct WordEntry: Codable, Identifiable, Equatable {
    let id = UUID()
    let word: String
    let function: String
    let definition: String
    let example: String
    
    enum CodingKeys: String, CodingKey {
        case word, function, definition, example
    }
    
    init(word: String, function: String, definition: String, example: String) {
        self.word = word
        self.function = function
        self.definition = definition
        self.example = example
    }
}