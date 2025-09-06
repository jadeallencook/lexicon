import SwiftUI

/// Provides a form interface for users to add new vocabulary words to their personal collection.
/// This view component presents a modal sheet with text fields for entering word information
/// including the word itself, part of speech, definition, and usage example. It includes
/// form validation, theming consistent with the app, and haptic feedback for user interactions.
/// The view handles saving the new entry and provides appropriate user feedback.
struct AddWordView: View {
    @Binding var isPresented: Bool
    let onSave: (Entry) -> Void
    
    @State private var word = ""
    @State private var selectedFunction = "noun"
    @State private var definition = ""
    @State private var example = ""
    
    private let wordFunctions = [
        "noun", "verb", "adjective", "adverb", "pronoun",
        "preposition", "conjunction", "interjection"
    ]
    
    var body: some View {
        let wordPrompt = Text("Word").foregroundColor(Color(.systemGray2))
        let definitionPrompt = Text("Enter definition").foregroundColor(Color(.systemGray2))
        let examplePrompt = Text("Enter example sentence").foregroundColor(Color(.systemGray2))
        
        return NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Form {
                    Section("Word Information") {
                        TextField("Word", text: $word, prompt: wordPrompt)
                            .textInputAutocapitalization(.never)
                            .foregroundColor(.white)
                            .tint(.white)
                        
                        Picker("Part of Speech", selection: $selectedFunction) {
                            ForEach(wordFunctions, id: \.self) { function in
                                Text(function.capitalized)
                                    .foregroundColor(.white)
                                    .tag(function)
                            }
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                    
                    Section("Definition") {
                        TextField("Enter definition", text: $definition, prompt: definitionPrompt, axis: .vertical)
                            .lineLimit(3...6)
                            .foregroundColor(.white)
                            .tint(.white)
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                    
                    Section("Example") {
                        TextField("Enter example sentence", text: $example, prompt: examplePrompt, axis: .vertical)
                            .lineLimit(2...4)
                            .foregroundColor(.white)
                            .tint(.white)
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(.white)
            }
            .navigationTitle("Learn New Word")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWord()
                    }
                    .disabled(!isFormValid)
                    .foregroundColor(isFormValid ? .brown : .gray)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !definition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !example.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveWord() {
        let newEntry = Entry(
            word: word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            function: selectedFunction,
            definition: definition.trimmingCharacters(in: .whitespacesAndNewlines),
            example: example.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        onSave(newEntry)
        isPresented = false
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}
