// RecentStoriesView.swift
import SwiftUI

struct RecentStoriesView: View {
    @ObservedObject var viewModel: StoryViewModel
    @State private var selectedStory: Story?
    @State private var showingStory = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            if viewModel.recentStories.isEmpty {
                ContentUnavailableView(
                    "Inga sagor ännu",
                    systemImage: "book",
                    description: Text("Skapa din första saga för att se den här")
                )
            } else {
                List {
                    ForEach(viewModel.recentStories) { story in
                        VStack(alignment: .leading) {
                            Text(story.title)
                                .font(.headline)
                            
                            HStack {
                                Text("För: \(story.childName)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("Tema: \(story.theme)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedStory = story
                            showingStory = true
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .sheet(isPresented: $showingStory) {
            if let story = selectedStory {
                StoryDisplayView(story: story)
            }
        }
        .preferredColorScheme(colorScheme)
    }
}
