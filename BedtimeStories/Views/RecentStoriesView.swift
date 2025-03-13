//
//  RecentStoriesView.swift
//  BedtimeStories
//
//  Created by Victor Uttberg on 2025-03-13.
//

// RecentStoriesView.swift
import SwiftUI

struct RecentStoriesView: View {
    @ObservedObject var viewModel: StoryViewModel
    @State private var selectedStory: Story?
    @State private var showingStory = false
    
    var body: some View {
        VStack {
            if viewModel.recentStories.isEmpty {
                ContentUnavailableView(
                    "No Stories Yet",
                    systemImage: "book",
                    description: Text("Generate your first story to see it here")
                )
            } else {
                List {
                    ForEach(viewModel.recentStories) { story in
                        VStack(alignment: .leading) {
                            Text(story.title)
                                .font(.headline)
                            
                            HStack {
                                Text("For: \(story.childName)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("Theme: \(story.theme)")
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
    }
}
