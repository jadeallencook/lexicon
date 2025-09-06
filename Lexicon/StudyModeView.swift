import SwiftUI

/// Provides a quiz-style study mode where users are shown definitions and must select the correct word.
/// This view component creates multiple choice questions from the user's vocabulary collection,
/// providing immediate feedback and automatic progression through the study session.
/// Users can end the study session at any time to return to the main interface.
struct StudyModeView: View {
    @Binding var isPresented: Bool
    let userWords: [Entry]
    
    @State private var currentQuestionIndex = 0
    @State private var currentQuestion: StudyQuestion?
    @State private var selectedAnswer: String?
    @State private var showingResult = false
    @State private var isCorrect = false
    @State private var questions: [StudyQuestion] = []
    @State private var correctAnswers = 0
    @State private var showingFinalResults = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if questions.isEmpty {
                    VStack(spacing: 16) {
                        Text("📚")
                            .font(.system(size: 60))
                        
                        Text("Not enough words to study")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .bold()
                        
                        Text("You need at least 4 words in your vocabulary to use study mode.")
                            .font(.body)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else if showingFinalResults {
                    // Final results screen
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Text("\(Int(Double(correctAnswers) / Double(questions.count) * 100))%")
                            .font(.system(size: 48, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                        
                        Text("You got \(correctAnswers)/\(questions.count) right")
                            .font(.title2)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        Button("Done") {
                            isPresented = false
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        )
                        
                        Spacer()
                    }
                    .padding()
                } else if let question = currentQuestion {
                    VStack(spacing: 24) {
                        // Progress indicator
                        HStack {
                            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        
                        // Progress bar
                        ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                            .tint(.white)
                        
                        Spacer()
                        
                        // Definition card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("What word matches this definition?")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            
                            Text(question.definition)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(24)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        }
                        
                        Spacer()
                        
                        // Answer options
                        VStack(spacing: 12) {
                            ForEach(question.options, id: \.self) { option in
                                Button {
                                    selectAnswer(option)
                                } label: {
                                    HStack {
                                        Text(option.capitalized)
                                            .font(.body)
                                            .foregroundColor(buttonTextColor(for: option))
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(buttonBackgroundColor(for: option))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(buttonBorderColor(for: option), lineWidth: 2)
                                            )
                                    )
                                }
                                .disabled(showingResult)
                            }
                        }
                        
                        // Always show Next Question button
                        Button(currentQuestionIndex < questions.count - 1 ? "Next Question" : "Finish Study") {
                            nextQuestion()
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selectedAnswer != nil ? .black : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(selectedAnswer != nil ? Color.white : Color.gray.opacity(0.3))
                        )
                        .disabled(selectedAnswer == nil)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Study Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("End Study") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            generateQuestions()
        }
    }
    
    private func generateQuestions() {
        guard userWords.count >= 4 else { return }
        
        // Create questions for all words
        questions = userWords.map { word in
            var options = [word.word]
            
            // Add 3 random incorrect options
            let otherWords = userWords.filter { $0.word != word.word }
            let incorrectOptions = Array(otherWords.shuffled().prefix(3))
            options.append(contentsOf: incorrectOptions.map { $0.word })
            
            return StudyQuestion(
                definition: word.definition,
                correctAnswer: word.word,
                options: options.shuffled()
            )
        }.shuffled()
        
        currentQuestion = questions.first
        currentQuestionIndex = 0
    }
    
    private func selectAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        
        selectedAnswer = answer
        isCorrect = answer == question.correctAnswer
        showingResult = true
        
        // Track correct answers
        if isCorrect {
            correctAnswers += 1
        }
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: isCorrect ? .medium : .heavy)
        impact.impactOccurred()
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            currentQuestion = questions[currentQuestionIndex]
            selectedAnswer = nil
            showingResult = false
        } else {
            // Study session complete - show final results
            showingFinalResults = true
        }
    }
    
    private func buttonBackgroundColor(for option: String) -> Color {
        guard showingResult, let selected = selectedAnswer else {
            return Color.gray.opacity(0.1)
        }
        
        if option == selected {
            return isCorrect ? .green.opacity(0.2) : .red.opacity(0.2)
        } else if option == currentQuestion?.correctAnswer {
            return .green.opacity(0.2)
        }
        
        return Color.gray.opacity(0.1)
    }
    
    private func buttonBorderColor(for option: String) -> Color {
        guard showingResult, let selected = selectedAnswer else {
            return Color.clear
        }
        
        if option == selected {
            return isCorrect ? .green : .red
        } else if option == currentQuestion?.correctAnswer {
            return .green
        }
        
        return Color.clear
    }
    
    private func buttonTextColor(for option: String) -> Color {
        return .white
    }
}

/// Represents a single study question with definition and multiple choice options
struct StudyQuestion {
    let definition: String
    let correctAnswer: String
    let options: [String]
}