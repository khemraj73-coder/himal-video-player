import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'HIMAL Video Player';
  static const String appTagline = 'Every format. Every device. Free forever.';
  static const String appVersion = '1.0.0';

  // Window / layout
  static const double minWindowWidth = 640;
  static const double minWindowHeight = 360;
  static const double defaultWindowWidth = 1280;
  static const double defaultWindowHeight = 720;

  // Player
  static const Duration seekStep = Duration(seconds: 10);
  static const Duration longSeekStep = Duration(seconds: 30);
  static const double defaultVolume = 1.0;
  static const double defaultPlaybackSpeed = 1.0;

  // Supported playback speeds
  static const List<double> playbackSpeeds = [
    0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 3.0, 4.0,
  ];

  // Aspect ratios
  static const Map<String, double?> aspectRatios = {
    'Auto': null,
    '16:9': 16 / 9,
    '4:3': 4 / 3,
    '21:9': 21 / 9,
    '1:1': 1.0,
    'Fill': -1, // sentinel for fill
  };

  // Seek bar
  static const int seekBarSegments = 1000;

  // Recent files limit
  static const int maxRecentFiles = 50;
  static const int maxFavorites = 200;

  // Supported container extensions
  static const Set<String> videoExtensions = {
    'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm', 'ts', 'm2ts', 'mts',
    'mpg', 'mpeg', 'vob', 'ogv', '3gp', '3g2', 'asf', 'rm', 'rmvb', 'divx',
    'f4v', 'm4v', 'ogm', 'mxf', 'dv', 'mts', 'm2t',
  };

  static const Set<String> audioExtensions = {
    'mp3', 'flac', 'wav', 'ogg', 'opus', 'aac', 'm4a', 'wma', 'ape', 'alac',
    'aiff', 'caf', 'dts', 'ac3', 'eac3', 'mka', 'tta', 'wv',
  };

  static const Set<String> subtitleExtensions = {
    'srt', 'ass', 'ssa', 'vtt', 'sub', 'idx', 'pgs', 'ttml', 'dfxp',
  };

  static const Set<String> playlistExtensions = {
    'm3u', 'm3u8', 'pls', 'xspf',
  };

  // All openable media
  static Set<String> get mediaExtensions => {...videoExtensions, ...audioExtensions};

  // Theme
  static const Color defaultAccent = Color(0xFFE53935); // Himalayan red
  static const Color himalayanBlue = Color(0xFF1565C0);
  static const Color himalayanGreen = Color(0xFF2E7D32);
  static const Color himalayanGold = Color(0xFFFFB300);

  // Network timeouts
  static const Duration networkTimeout = Duration(seconds: 30);

  // Cache
  static const int thumbnailCacheSize = 200;
}