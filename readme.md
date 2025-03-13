# Godnattsagor - Personalized Bedtime Stories App

A Swedish iOS application that generates personalized bedtime stories for children using AI.

## Features

- Generate personalized bedtime stories in Swedish based on child's name, age, and preferred themes
- Listen to stories with built-in text-to-speech
- Save and access previously generated stories
- Dark mode support

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.0+
- OpenAI API key

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/godnattsagor.git
cd godnattsagor
```

2. Open the project in Xcode
```bash
open BedtimeStories.xcodeproj
```

3. Set your OpenAI API key
   - Open `Config.swift`
   - Replace `YOUR_OPENAI_API_KEY` with your actual OpenAI API key

4. Build and run the application on your device or simulator

## Configuration

### OpenAI API Key
The app needs an OpenAI API key to generate stories. You can get one by:
1. Sign up at [OpenAI Platform](https://platform.openai.com)
2. Create a new API key
3. Add it to your project as described in the Installation section

### Customizing Story Parameters
You can adjust the generation parameters in `AIStoryGenerator.swift`:
- Change the model by modifying the `model` property
- Adjust the temperature for more or less creative stories
- Modify token count for shorter or longer stories

## Project Structure

```
BedtimeStories/
├── Models/
│   ├── StoryRequest.swift - Request model sent to OpenAI
│   └── Story.swift - Story model with persistence functionality
├── ViewModels/
│   └── StoryViewModel.swift - Main view model for the app
├── Views/
│   ├── ContentView.swift - Main tab container
│   ├── StoryInputView.swift - Form for generating stories
│   ├── StoryDisplayView.swift - Shows generated stories
│   └── RecentStoriesView.swift - Shows saved stories
├── Services/
│   └── AIStoryGenerator.swift - OpenAI API integration
└── Utilities/
    ├── Config.swift - App configuration
    ├── APIKeyManager.swift - API key management
    └── TextToSpeechManager.swift - Text-to-speech functionality
```

## Troubleshooting

### "Invalid API Key" Error
- Ensure your OpenAI API key is correctly set in Config.swift
- Check that your API key has sufficient quota and permissions
- Verify your internet connection

### No Text-to-Speech
- Check that your device is not in silent mode
- Ensure the Swedish voice pack is installed on your device
- Try using a different voice by modifying the TextToSpeechManager.swift file

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [OpenAI](https://openai.com) for providing the API that powers the story generation
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) for the UI framework
- All the parents and children who provided feedback during development
