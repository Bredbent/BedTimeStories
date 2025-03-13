//
//  ContentView.swift
//  BedtimeStories
//
//  Created by Victor Uttberg on 2025-03-13.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StoryViewModel()
    
    var body: some View {
        NavigationView {
            TabView {
                StoryInputView(viewModel: viewModel)
                    .tabItem {
                        Label("Create Story", systemImage: "plus.circle")
                    }
                
                RecentStoriesView(viewModel: viewModel)
                    .tabItem {
                        Label("Recent Stories", systemImage: "book")
                    }
            }
            .navigationTitle("Bedtime Stories")
        }
    }
}
