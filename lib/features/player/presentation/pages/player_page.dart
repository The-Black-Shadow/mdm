import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mdm/core/theme/app_colors.dart';

// >>> PlayerPage =======================
class PlayerPage extends StatefulWidget {
  final String filePath;

  const PlayerPage({super.key, required this.filePath});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late BetterPlayerController _betterPlayerController;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final file = File(widget.filePath);
    if (!file.existsSync()) {
      setState(() {
        _isError = true;
      });
      return;
    }

    final betterPlayerConfiguration = BetterPlayerConfiguration(
      autoPlay: true,
      looping: false,
      fullScreenByDefault: false,
      allowedScreenSleep: false,
      fit: BoxFit.contain,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        enableSkips: true,
        enableMute: true,
        enableFullscreen: true,
        controlBarColor: Colors.black54,
        progressBarPlayedColor: AppColors.primary,
        progressBarHandleColor: AppColors.primary,
      ),
      systemOverlaysAfterFullScreen: SystemUiOverlay.values,
    );

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.filePath,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration)
      ..setupDataSource(dataSource);
  }

  @override
  void dispose() {
    if (!_isError) {
      _betterPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('File not found or cannot be played.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.filePath.split('/').last,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: _betterPlayerController,
            ),
          ),
        ),
      ),
    );
  }
}
// <<< PlayerPage =======================
