// StoryInputView.swift
import SwiftUI

struct StoryInputView: View {
    @ObservedObject var viewModel: StoryViewModel
    @State private var isGeneratingStory = false
    @State private var showingStory = false
    @State private var currentStory: Story?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Form {
            Section(header: Text("Barnets information")) {
                TextField("Barnets namn", text: $viewModel.childName)
                    .autocapitalization(.words)
                
                TextField("Ålder", text: $viewModel.age)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Sagans detaljer")) {
                TextField("Tema (t.ex. pirater, prinsessor, rymden)", text: $viewModel.theme)
                
                TextEditor(text: $viewModel.additionalDetails)
                    .frame(height: 100)
                    .overlay(
                        Group {
                            if viewModel.additionalDetails.isEmpty {
                                Text("Ytterligare detaljer (valfritt)")
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                        }
                    )
            }
            
            Section {
                Button(action: {
                    isGeneratingStory = true
                    Task {
                        await viewModel.generateStory()
                        isGeneratingStory = false
                        
                        // Check if story generation was successful
                        if case .success(let story) = viewModel.generationState {
                            currentStory = story
                            showingStory = true
                        }
                    }
                }) {
                    if isGeneratingStory {
                        HStack {
                            ProgressView()
                                .padding(.trailing, 8)
                            Text("Skapar saga...")
                        }
                    } else {
                        Text("Skapa godnattsaga")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(!viewModel.isFormValid || isGeneratingStory)
            }
            
            if case .failure(let error) = viewModel.generationState {
                Section {
                    Text(viewModel.errorMessage(for: error))
                        .foregroundColor(.red)
                }
            }
        }
        .sheet(isPresented: $showingStory) {
            if let story = currentStory {
                StoryDisplayView(story: story)
            }
        }
        .preferredColorScheme(colorScheme)
    }
}
