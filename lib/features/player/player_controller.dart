import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';

enum PlayerStatus { idle, loading, playing, paused, buffering, error, ended }

class MediaItem {
  final String path;
  final String title;
  final Duration? duration;
  final String? thumbnailPath;

  const MediaItem({
    required this.path,
    required this.title,
    this.duration,
    this.thumbnailPath,
  });

  String get extension => p.extension(path).toLowerCase().replaceFirst('.', '');

  bool get isAudio => AppConstants.audioExtensions.contains(extension);
  bool get isVideo => AppConstants.videoExtensions.contains(extension);

  String get displayName {
    if (title.isNotEmpty) return title;
    return p.basenameWithoutExtension(path);
  }
}

class PlayerController extends ChangeNotifier {
  PlayerController() {
    _player = Player(
      configuration: const PlayerConfiguration(
        title: 'HIMAL Video Player',
      ),
    );
    _videoController = VideoController(_player);
    _bindEvents();
  }

  late final Player _player;
  late final VideoController _videoController;

  VideoController get videoController => _videoController;
  Player get player => _player;

  PlayerStatus _status = PlayerStatus.idle;
  PlayerStatus get status => _status;

  MediaItem? _current;
  MediaItem? get current => _current;

  List<MediaItem> _playlist = [];
  List<MediaItem> get playlist => _playlist;
  int _playlistIndex = -1;
  int get playlistIndex => _playlistIndex;

  Duration _position = Duration.zero;
  Duration get position => _position;

  Duration _duration = Duration.zero;
  Duration get duration => _duration;

  double _volume = AppConstants.defaultVolume;
  double get volume => _volume;

  double _speed = AppConstants.defaultPlaybackSpeed;
  double get speed => _speed;

  bool _muted = false;
  bool get muted => _muted;

  bool _looping = false;
  bool get looping => _looping;

  bool _shuffle = false;
  bool get shuffle => _shuffle;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  double? _aspectRatio;
  double? get aspectRatio => _aspectRatio;

  bool _showControls = true;
  bool get showControls => _showControls;

  Timer? _hideControlsTimer;
  Timer? _positionTimer;

  final List<MediaItem> _recent = [];
  List<MediaItem> get recent => List.unmodifiable(_recent);

  final List<MediaItem> _favorites = [];
  List<MediaItem> get favorites => List.unmodifiable(_favorites);

  // Subtitles
  List<String> _subtitleTracks = [];
  List<String> get subtitleTracks => _subtitleTracks;
  int _activeSubtitle = -1; // -1 = off, 0 = auto, >0 index
  int get activeSubtitle => _activeSubtitle;

  // Audio tracks
  List<String> _audioTracks = [];
  List<String> get audioTracks => _audioTracks;
  int _activeAudio = 0;
  int get activeAudio => _activeAudio;

  // Position persistence
  final Map<String, Duration> _positions = {};

  void _bindEvents() {
    _player.stream.playing.listen((playing) {
      if (playing) {
        _status = PlayerStatus.playing;
      } else if (_status == PlayerStatus.playing) {
        _status = PlayerStatus.paused;
      }
      notifyListeners();
    });

    _player.stream.buffering.listen((buffering) {
      if (buffering && _status == PlayerStatus.playing) {
        _status = PlayerStatus.buffering;
      } else if (!buffering && _status == PlayerStatus.buffering) {
        _status = PlayerStatus.playing;
      }
      notifyListeners();
    });

    _player.stream.position.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _player.stream.duration.listen((dur) {
      _duration = dur;
      notifyListeners();
    });

    _player.stream.volume.listen((v) {
      _volume = v / 100.0;
      notifyListeners();
    });

    _player.stream.rate.listen((r) {
      _speed = r;
      notifyListeners();
    });

    _player.stream.error.listen((err) {
      _errorMessage = err;
      _status = PlayerStatus.error;
      notifyListeners();
    });

    _player.stream.completed.listen((completed) {
      if (completed) {
        _onCompleted();
      }
    });

    _player.stream.tracks.listen((tracks) {
      _subtitleTracks = tracks.subtitle.map((t) => t.id).toList();
      _audioTracks = tracks.audio.map((t) => t.id).toList();
      notifyListeners();
    });
  }

  Future<void> open(MediaItem item,
      {List<MediaItem>? playlist, int index = 0}) async {
    _status = PlayerStatus.loading;
    _errorMessage = null;
    notifyListeners();

    if (playlist != null) {
      _playlist = playlist;
      _playlistIndex = index;
    } else if (_playlist.isEmpty || !_playlist.contains(item)) {
      _playlist = [item];
      _playlistIndex = 0;
    } else {
      _playlistIndex = _playlist.indexOf(item);
    }

    _current = item;
    _addToRecent(item);

    // Restore position if enabled.
    final saved = _positions[item.path];
    try {
      await _player.open(Media(item.path), play: true);
      if (saved != null && saved > Duration.zero) {
        await Future.delayed(const Duration(milliseconds: 300));
        await _player.seek(saved);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _status = PlayerStatus.error;
      notifyListeners();
    }

    notifyListeners();
  }

  Future<void> openFile(String path) async {
    final item = MediaItem(path: path, title: p.basenameWithoutExtension(path));
    await open(item);
  }

  Future<void> openFiles(List<String> paths) async {
    if (paths.isEmpty) return;
    final items =
        paths.map((p) => MediaItem(path: p, title: _basename(p))).toList();
    await open(items.first, playlist: items, index: 0);
  }

  String _basename(String path) => p.basenameWithoutExtension(path);

  Future<void> play() async => _player.play();
  Future<void> pause() async => _player.pause();
  Future<void> togglePlayPause() async {
    if (_player.state.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration position) async {
    // clamp
    if (position < Duration.zero) position = Duration.zero;
    if (position > _duration) position = _duration;
    await _player.seek(position);
    _position = position;
    notifyListeners();
  }

  Future<void> seekRelative(Duration delta) async {
    await seek(_position + delta);
  }

  Future<void> seekForward() async => seekRelative(AppConstants.seekStep);
  Future<void> seekBackward() async => seekRelative(-AppConstants.seekStep);
  Future<void> seekForwardLong() async =>
      seekRelative(AppConstants.longSeekStep);
  Future<void> seekBackwardLong() async =>
      seekRelative(-AppConstants.longSeekStep);

  Future<void> setVolume(double v) async {
    v = v.clamp(0.0, 1.0);
    _volume = v;
    await _player.setVolume(v * 100);
    notifyListeners();
  }

  Future<void> volumeUp() async => setVolume(_volume + 0.05);
  Future<void> volumeDown() async => setVolume(_volume - 0.05);
  Future<void> toggleMute() async {
    _muted = !_muted;
    await _player.setVolume(_muted ? 0 : _volume * 100);
    notifyListeners();
  }

  Future<void> setSpeed(double s) async {
    _speed = s;
    await _player.setRate(s);
    notifyListeners();
  }

  Future<void> cycleSpeed() async {
    const speeds = AppConstants.playbackSpeeds;
    final idx = speeds.indexOf(_speed);
    final next = (idx + 1) % speeds.length;
    await setSpeed(speeds[next]);
  }

  Future<void> toggleLoop() async {
    _looping = !_looping;
    await _player
        .setPlaylistMode(_looping ? PlaylistMode.loop : PlaylistMode.none);
    notifyListeners();
  }

  Future<void> toggleShuffle() async {
    _shuffle = !_shuffle;
    notifyListeners();
  }

  void setAspectRatio(double? ratio) {
    _aspectRatio = ratio;
    notifyListeners();
  }

  void setShowControls(bool v) {
    _showControls = v;
    notifyListeners();
    if (v) _scheduleHideControls();
  }

  void toggleControls() {
    setShowControls(!_showControls);
  }

  void _scheduleHideControls() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (_status == PlayerStatus.playing) {
        _showControls = false;
        notifyListeners();
      }
    });
  }

  void resetHideTimer() => _scheduleHideControls();

  Future<void> next() async {
    if (_playlist.isEmpty) return;
    int nextIndex;
    if (_shuffle) {
      nextIndex = (_playlistIndex +
              1 +
              (DateTime.now().millisecond % _playlist.length)) %
          _playlist.length;
    } else {
      nextIndex = _playlistIndex + 1;
      if (nextIndex >= _playlist.length) {
        if (_looping) {
          nextIndex = 0;
        } else {
          return;
        }
      }
    }
    await open(_playlist[nextIndex], playlist: _playlist, index: nextIndex);
  }

  Future<void> previous() async {
    if (_playlist.isEmpty) return;
    int prevIndex = _playlistIndex - 1;
    if (prevIndex < 0) {
      if (_looping) {
        prevIndex = _playlist.length - 1;
      } else {
        return;
      }
    }
    await open(_playlist[prevIndex], playlist: _playlist, index: prevIndex);
  }

  void _onCompleted() {
    _status = PlayerStatus.ended;
    _savePosition();
    notifyListeners();
    // auto play next handled by settings; controller just notifies.
  }

  void _addToRecent(MediaItem item) {
    _recent.removeWhere((e) => e.path == item.path);
    _recent.insert(0, item);
    if (_recent.length > AppConstants.maxRecentFiles) {
      _recent.removeLast();
    }
  }

  void toggleFavorite(MediaItem item) {
    final idx = _favorites.indexWhere((e) => e.path == item.path);
    if (idx >= 0) {
      _favorites.removeAt(idx);
    } else {
      if (_favorites.length < AppConstants.maxFavorites) {
        _favorites.add(item);
      }
    }
    notifyListeners();
  }

  bool isFavorite(String path) => _favorites.any((e) => e.path == path);

  void _savePosition() {
    if (_current != null) {
      _positions[_current!.path] = _position;
    }
  }

  Future<void> setSubtitleTrack(int index) async {
    _activeSubtitle = index;
    // media_kit track selection
    try {
      if (index == -1) {
        await _player.setSubtitleTrack(SubtitleTrack.no());
      } else if (index == 0) {
        await _player.setSubtitleTrack(SubtitleTrack.auto());
      } else if (index - 1 < _subtitleTracks.length) {
        // best-effort
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> setAudioTrack(int index) async {
    _activeAudio = index;
    try {
      if (index == 0) {
        await _player.setAudioTrack(AudioTrack.auto());
      } else {
        await _player.setAudioTrack(AudioTrack.no());
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> addSubtitleFile(String path) async {
    try {
      await _player.setSubtitleTrack(SubtitleTrack.uri(path));
    } catch (_) {}
    notifyListeners();
  }

  Future<void> screenshot() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final shots = Directory(p.join(dir.path, 'HIMAL', 'Screenshots'));
      await shots.create(recursive: true);
      // media_kit screenshot support varies; best-effort via command
      // await _player.command(['screenshot-to-file', file.path, 'video']);
    } catch (_) {}
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _positionTimer?.cancel();
    _savePosition();
    _player.dispose();
    super.dispose();
  }
}
