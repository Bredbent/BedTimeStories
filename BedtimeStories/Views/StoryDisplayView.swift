// StoryDisplayView.swift
import SwiftUI

struct StoryDisplayView: View {
    let story: Story
    @StateObject private var speechManager = TextToSpeechManager()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Story title
                Text(story.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                // Story content
                Text(story.content)
                    .font(.body)
                    .lineSpacing(8)
                
                // Add some space at the bottom
                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if speechManager.isSpeaking {
                        speechManager.stopSpeaking()
                    } else {
                        speechManager.speak(story.content)
                    }
                }) {
                    Label(
                        speechManager.isSpeaking ? "Sluta läsa" : "Läs högt",
                        systemImage: speechManager.isSpeaking ? "stop.fill" : "play.fill"
                    )
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Stäng") {
                    if speechManager.isSpeaking {
                        speechManager.stopSpeaking()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onDisappear {
            if speechManager.isSpeaking {
                speechManager.stopSpeaking()
            }
        }
        .preferredColorScheme(colorScheme)
    }
}
