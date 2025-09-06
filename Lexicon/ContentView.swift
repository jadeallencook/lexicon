import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = LexiconViewModel()
    @StateObject private var speechService = SpeechService()
    @State private var showingDeleteConfirmation = false
    @State private var showingStudyMode = false
    @State private var showingWordManager = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingView()
            } else {
                VStack(alignment: .leading) {
                    Text("Lexicon")
                        .font(.largeTitle).bold()
                        .foregroundStyle(.white)
                    
                    if let entry = viewModel.currentEntry {
                        WordDisplayView(
                            entry: entry,
                            onPronounce: { speechService.speak(entry.word) },
                            onStop: speechService.stop,
                            isSpeaking: speechService.isSpeaking
                        )
                        
                        ActionButtonsView(
                            onShuffle: viewModel.shuffleWord,
                            onStudy: { showingStudyMode = true },
                            onManageWords: { showingWordManager = true },
                            isDisabled: viewModel.words.isEmpty,
                            hasWords: !viewModel.words.isEmpty
                        )
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            EmptyStateView()
                            
                            ActionButtonsView(
                                onShuffle: { },
                                onStudy: { },
                                onManageWords: { showingWordManager = true },
                                isDisabled: true,
                                hasWords: false
                            )
                        }
                    }
                }
                .padding(16)
            }
        }
        .task {
            await viewModel.loadWords()
        }
        .alert("Delete Word", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteCurrentWord()
            }
        } message: {
            if let currentWord = viewModel.currentEntry {
                Text("Are you sure you want to delete '\(currentWord.word.capitalized)' from your vocabulary?")
            }
        }
        .sheet(isPresented: $showingStudyMode) {
            StudyModeView(
                isPresented: $showingStudyMode,
                userWords: viewModel.userWords
            )
        }
        .sheet(isPresented: $showingWordManager) {
            WordManagerView(
                isPresented: $showingWordManager,
                userWords: viewModel.userWords,
                onAddWord: { entry in
                    viewModel.addWord(entry)
                },
                onDeleteWord: { entry in
                    // Find and delete the specific word
                    if let index = viewModel.userWords.firstIndex(where: { $0.word == entry.word }) {
                        viewModel.userWords.remove(at: index)
                        viewModel.words.remove(at: index)
                        viewModel.saveUserWords()
                        
                        // Update current entry if it was deleted
                        if viewModel.currentEntry?.word == entry.word {
                            viewModel.currentEntry = viewModel.words.randomElement()
                        }
                    }
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
