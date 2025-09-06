import Foundation
import SwiftData

/// Represents a category for organizing vocabulary words in the Lexicon app.
/// This SwiftData model class is used to create user-defined categories that can
/// group related words together for better organization and study.
@Model
class Category: Identifiable {
    var id: String
    var title: String
    
    init(title: String) {
        self.id = UUID().uuidString
        self.title = title
    }
}