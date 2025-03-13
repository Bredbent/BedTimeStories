//
//  StoryDisplayView.swift
//  BedtimeStories
//
//  Created by Victor Uttberg on 2025-03-13.
//

// StoryDisplayView.swift
import SwiftUI

struct StoryDisplayView: View {
    let story: Story
    @State private var isSpeaking = false
    @Environment(\.presentationMode) var presentationMode
    
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
                    isSpeaking.toggle()
                    // Implement text-to-speech functionality
                    // This would use AVSpeechSynthesizer in a production app
                }) {
                    Label(
                        isSpeaking ? "Stop Reading" : "Read Aloud",
                        systemImage: isSpeaking ? "stop.fill" : "play.fill"
                    )
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
