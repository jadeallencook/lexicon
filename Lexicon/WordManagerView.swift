import SwiftUI

/// Provides a comprehensive word management interface where users can view, add, delete, and explore vocabulary words.
/// This view serves as a central hub for all word-related operations, displaying the user's complete vocabulary
/// collection in a list format with options to manage individual words or discover new ones from the bundled content.
struct WordManagerView: View {
    @Binding var isPresented: Bool
    let userWords: [Entry]
    let onAddWord: (Entry) -> Void
    let onDeleteWord: (Entry) -> Void
    
    @State private var showingAddWord = false
    @State private var showingExploreWords = false
    @State private var wordToDelete: Entry?
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if userWords.isEmpty {
                    VStack(spacing: 20) {
                        Text("📚")
                            .font(.system(size: 60))
                        
                        Text("No words in your vocabulary")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .bold()
                        
                        Text("Add words to your collection or explore available words to get started.")
                            .font(.body)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            Button("Learn New Word") {
                                showingAddWord = true
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
                            
                            Button("Explore Words") {
                                showingExploreWords = true
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
                        .padding(.top, 20)
                    }
                    .padding()
                } else {
                    VStack(spacing: 0) {
                        // Header with action buttons
                        VStack(spacing: 16) {
                            HStack {
                                Text("\(userWords.count) words in your vocabulary")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            
                            HStack(spacing: 16) {
                                Button("Learn New Word") {
                                    showingAddWord = true
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
                                
                                Button("Explore Words") {
                                    showingExploreWords = true
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
                        .padding()
                        .background(Color.black)
                        
                        // Word list
                        List {
                            ForEach(userWords, id: \.word) { word in
                                WordRowView(entry: word)
                                    .listRowBackground(Color.gray.opacity(0.1))
                                    .listRowSeparator(.hidden)
                            }
                            .onDelete { indexSet in
                                if let index = indexSet.first {
                                    wordToDelete = userWords[index]
                                    showingDeleteConfirmation = true
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Manage Words")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showingAddWord) {
            AddWordView(isPresented: $showingAddWord, onSave: onAddWord)
        }
        .sheet(isPresented: $showingExploreWords) {
            ExploreWordsView(
                isPresented: $showingExploreWords,
                userWords: userWords,
                onAddToCurriculum: onAddWord,
                showBackButton: true
            )
        }
        .alert("Delete Word", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let word = wordToDelete {
                    onDeleteWord(word)
                }
            }
        } message: {
            if let word = wordToDelete {
                Text("Are you sure you want to delete '\(word.word.capitalized)' from your vocabulary?")
            }
        }
    }
}

/// Displays a single word entry in the word manager list
struct WordRowView: View {
    let entry: Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.word.capitalized)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .bold()
                
                Text("(\(entry.function))")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Spacer()
            }
            
            Text(entry.definition)
                .font(.body)
                .foregroundStyle(.white)
                .lineLimit(2)
            
            Text(entry.example)
                .font(.caption)
                .foregroundStyle(.gray)
                .italic()
                .lineLimit(2)
        }
        .padding(.vertical, 8)
    }
}