import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  BetterPlayerController? _betterPlayerController;
  List<String> _videoUrls = [];
  int _currentVideoIndex = 0;
  bool _isControlsVisible = true;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _loadSavedVideos();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.mediaLibrary.request();
  }

  Future<void> _loadSavedVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrls = prefs.getStringList('video_urls') ?? [];
    
    // Default demo videos if no saved videos
    if (savedUrls.isEmpty) {
      setState(() {
        _videoUrls = [
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        ];
      });
    } else {
      setState(() {
        _videoUrls = savedUrls;
      });
    }
  }

  Future<void> _saveVideos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('video_urls', _videoUrls);
  }

  void _initializePlayer() {
    if (_videoUrls.isNotEmpty) {
      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: false,
          looping: false,
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableControls: true,
            enablePlayPause: true,
            enableMute: true,
            enableFullscreen: true,
            enableProgressText: true,
            enableSkips: true,
            enableOverflowMenu: true,
            controlBarColor: Colors.black54,
            progressBarPlayedColor: Colors.red,
            progressBarHandleColor: Colors.red,
            progressBarBufferedColor: Colors.white24,
            progressBarBackgroundColor: Colors.white12,
          ),
        ),
      );
      _playVideo(_currentVideoIndex);
    }
  }

  void _playVideo(int index) {
    if (index >= 0 && index < _videoUrls.length) {
      setState(() {
        _currentVideoIndex = index;
      });
      
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        _videoUrls[index],
        cacheConfiguration: BetterPlayerCacheConfiguration(
          useCache: true,
          preCacheSize: 10 * 1024 * 1024, // 10MB
          maxCacheSize: 100 * 1024 * 1024, // 100MB
          maxCacheFileSize: 50 * 1024 * 1024, // 50MB
        ),
      );
      
      _betterPlayerController?.setupDataSource(dataSource);
    }
  }

  Future<void> _pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final videoPath = result.files.single.path!;
        setState(() {
          _videoUrls.add(videoPath);
        });
        await _saveVideos();
        
        // Play the newly added video
        _playVideo(_videoUrls.length - 1);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video added successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking video: $e')),
        );
      }
    }
  }

  Future<void> _addVideoUrl() async {
    final controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Video URL'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter video URL',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final url = controller.text.trim();
                if (url.isNotEmpty) {
                  setState(() {
                    _videoUrls.add(url);
                  });
                  _saveVideos();
                  _playVideo(_videoUrls.length - 1);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });
    _betterPlayerController?.setControlsVisibility(_isControlsVisible);
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    _betterPlayerController?.toggleFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen ? null : AppBar(
        title: const Text(
          'Flutter Video Player',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddVideoDialog,
            tooltip: 'Add Video',
          ),
          IconButton(
            icon: const Icon(Icons.playlist_play, color: Colors.white),
            onPressed: _showPlaylistDialog,
            tooltip: 'Playlist',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _toggleControls,
        child: Column(
          children: [
            // Video Player
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black,
                child: _betterPlayerController != null
                    ? BetterPlayer(controller: _betterPlayerController!)
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
            ),
            
            // Video Controls and Info
            if (!_isFullscreen)
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[900],
                child: Column(
                  children: [
                    // Video Title
                    Text(
                      'Video ${_currentVideoIndex + 1} of ${_videoUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Playback Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _currentVideoIndex > 0
                              ? () => _playVideo(_currentVideoIndex - 1)
                              : null,
                          icon: const Icon(Icons.skip_previous),
                          color: Colors.white,
                          iconSize: 32,
                        ),
                        IconButton(
                          onPressed: () {
                            _betterPlayerController?.playPause();
                          },
                          icon: const Icon(Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 48,
                        ),
                        IconButton(
                          onPressed: _currentVideoIndex < _videoUrls.length - 1
                              ? () => _playVideo(_currentVideoIndex + 1)
                              : null,
                          icon: const Icon(Icons.skip_next),
                          color: Colors.white,
                          iconSize: 32,
                        ),
                        IconButton(
                          onPressed: _toggleFullscreen,
                          icon: const Icon(Icons.fullscreen),
                          color: Colors.white,
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddVideoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.file_upload),
                title: const Text('Pick from Device'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideoFile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Add URL'),
                onTap: () {
                  Navigator.of(context).pop();
                  _addVideoUrl();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlaylistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Playlist'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _videoUrls.length,
              itemBuilder: (context, index) {
                final isCurrentVideo = index == _currentVideoIndex;
                return ListTile(
                  leading: isCurrentVideo
                      ? const Icon(Icons.play_circle, color: Colors.red)
                      : const Icon(Icons.video_library),
                  title: Text(
                    'Video ${index + 1}',
                    style: TextStyle(
                      fontWeight: isCurrentVideo ? FontWeight.bold : FontWeight.normal,
                      color: isCurrentVideo ? Colors.red : null,
                    ),
                  ),
                  subtitle: Text(
                    _videoUrls[index].length > 50
                        ? '${_videoUrls[index].substring(0, 50)}...'
                        : _videoUrls[index],
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _playVideo(index);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _videoUrls.removeAt(index);
                        if (_currentVideoIndex >= _videoUrls.length) {
                          _currentVideoIndex = _videoUrls.length - 1;
                        }
                        if (_currentVideoIndex >= 0) {
                          _playVideo(_currentVideoIndex);
                        }
                      });
                      _saveVideos();
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }
}