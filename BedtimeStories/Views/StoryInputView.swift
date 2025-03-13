//
//  StoryInputView.swift
//  BedtimeStories
//
//  Created by Victor Uttberg on 2025-03-13.
//

// StoryInputView.swift
import SwiftUI

struct StoryInputView: View {
    @ObservedObject var viewModel: StoryViewModel
    @State private var isGeneratingStory = false
    @State private var showingStory = false
    @State private var currentStory: Story?
    
    var body: some View {
        Form {
            Section(header: Text("Child Information")) {
                TextField("Child's Name", text: $viewModel.childName)
                    .autocapitalization(.words)
                
                TextField("Age", text: $viewModel.age)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Story Details")) {
                TextField("Theme (e.g., pirates, princesses, space)", text: $viewModel.theme)
                
                TextEditor(text: $viewModel.additionalDetails)
                    .frame(height: 100)
                    .overlay(
                        Group {
                            if viewModel.additionalDetails.isEmpty {
                                Text("Additional details (optional)")
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
                            Text("Generating Story...")
                        }
                    } else {
                        Text("Generate Bedtime Story")
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
    }
}
