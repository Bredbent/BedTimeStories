// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StoryViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            TabView {
                StoryInputView(viewModel: viewModel)
                    .tabItem {
                        Label("Skapa Saga", systemImage: "plus.circle")
                    }
                
                RecentStoriesView(viewModel: viewModel)
                    .tabItem {
                        Label("Tidigare Sagor", systemImage: "book")
                    }
            }
            .navigationTitle("Godnattsagor")
            .preferredColorScheme(colorScheme)
        }
    }
}
