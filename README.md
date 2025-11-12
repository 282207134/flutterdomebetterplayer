# Flutter Video Player

A cross-platform Flutter video player application built with the better_player package.

## Features

- 🎬 Play videos from multiple sources (network URLs, local files)
- 📱 Cross-platform support (Android & iOS)
- 🎮 Advanced playback controls (play, pause, seek, volume)
- 📺 Full-screen support
- 🎵 Audio control with mute/unmute
- 📋 Playlist management
- 💾 Video caching for better performance
- 🎨 Modern Material Design 3 UI
- 🔄 Auto-play and loop options
- 📱 Responsive design for phones and tablets

## Screenshots

*Note: Screenshots would be added here in a real project*

## Getting Started

### Prerequisites

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter_video_player
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Platform-Specific Setup

#### Android
- Add internet permission in `android/app/src/main/AndroidManifest.xml` (already included)
- For Android 13+, add READ_MEDIA_VIDEO permission for video access

#### iOS
- Add network and media library permissions in `ios/Runner/Info.plist` (already included)
- Update deployment target to iOS 11.0 or higher

## Usage

### Adding Videos

1. **From URL**: Tap the "+" button and select "Add URL" to add video URLs
2. **From Device**: Tap the "+" button and select "Pick from Device" to select local video files

### Playback Controls

- **Play/Pause**: Tap the play button or tap on the video
- **Seek**: Drag the progress bar or use the skip buttons
- **Volume**: Use the volume controls in the player
- **Fullscreen**: Tap the fullscreen button or rotate your device

### Playlist Management

- Tap the playlist icon to view all videos
- Tap on any video to play it
- Swipe to delete videos from the playlist
- Videos are automatically saved for next session

## Features in Detail

### Better Player Integration

This app uses the `better_player` package which provides:

- Advanced video controls
- Adaptive streaming support (HLS, DASH)
- Video caching for offline playback
- Customizable controls and themes
- Subtitle support
- Multiple audio tracks
- Picture-in-picture mode (Android)

### Video Sources Supported

- Network URLs (HTTP/HTTPS)
- Local files
- Asset files
- HLS streams (.m3u8)
- DASH streams

### Performance Features

- Intelligent caching to reduce bandwidth usage
- Adaptive bitrate streaming
- Memory-efficient playback
- Smooth seeking and scrubbing

## Configuration

### Customization Options

You can customize the player by modifying the `BetterPlayerConfiguration` in `lib/screens/video_player_screen.dart`:

```dart
BetterPlayerConfiguration(
  autoPlay: false,           // Auto-play on load
  looping: false,           // Loop when finished
  aspectRatio: 16 / 9,      // Video aspect ratio
  fit: BoxFit.contain,      // How video fits the container
  controlsConfiguration: BetterPlayerControlsConfiguration(
    // Customize controls appearance and behavior
  ),
)
```

### Cache Configuration

Adjust caching settings for better performance:

```dart
cacheConfiguration: BetterPlayerCacheConfiguration(
  useCache: true,
  preCacheSize: 10 * 1024 * 1024,    // 10MB pre-cache
  maxCacheSize: 100 * 1024 * 1024,   // 100MB max cache
  maxCacheFileSize: 50 * 1024 * 1024, // 50MB max file size
)
```

## Troubleshooting

### Common Issues

1. **Video not loading**: Check internet connection and video URL validity
2. **Permission denied**: Ensure storage permissions are granted
3. **Black screen**: Verify video format is supported (MP4, WebM, HLS)
4. **Audio issues**: Check device volume and mute settings

### Supported Video Formats

- MP4 (H.264, H.265/HEVC)
- WebM (VP8, VP9)
- HLS (.m3u8)
- DASH
- AVI (limited support)

## Dependencies

- `better_player: ^0.0.83` - Advanced video player
- `file_picker: ^6.1.1` - File selection
- `permission_handler: ^11.0.1` - Permission management
- `path_provider: ^2.1.1` - File path access
- `shared_preferences: ^2.2.2` - Local storage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [better_player](https://pub.dev/packages/better_player) for the excellent video player package
- Flutter team for the amazing framework
- The open-source community for inspiration and contributions