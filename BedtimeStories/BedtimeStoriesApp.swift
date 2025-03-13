import SwiftUI

@main
struct BedtimeStoriesApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .overlay(alignment: .topTrailing) {
                    DarkModeToggle(isDarkMode: $isDarkMode)
                        .padding()
                }
        }
    }
}

struct DarkModeToggle: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        Button(action: {
            isDarkMode.toggle()
        }) {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 20))
                .foregroundColor(isDarkMode ? .yellow : .primary)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color.primary.opacity(0.1))
                )
        }
    }
}
