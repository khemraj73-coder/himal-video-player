import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import 'player_controller.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final GlobalKey<VideoState> _videoKey = GlobalKey<VideoState>();

  @override
  void initState() {
    super.initState();
    final pc = context.read<PlayerController>();
    pc.setShowControls(true);
  }

  @override
  Widget build(BuildContext context) {
    final pc = context.watch<PlayerController>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => pc.toggleControls(),
        onDoubleTapDown: (d) {
          final w = MediaQuery.of(context).size.width;
          if (d.localPosition.dx < w / 2) {
            pc.seekBackward();
          } else {
            pc.seekForward();
          }
        },
        child: Stack(
          children: [
            Center(
              child: Video(
                key: _videoKey,
                controller: pc.videoController,
                controls: NoVideoControls,
                fit: _fitFor(pc.aspectRatio),
                filterQuality: FilterQuality.medium,
              ),
            ),
            if (pc.status == PlayerStatus.loading ||
                pc.status == PlayerStatus.buffering)
              const Center(child: CircularProgressIndicator(color: Colors.white)),
            if (pc.status == PlayerStatus.error)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        pc.errorMessage ?? 'Playback error',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            if (pc.showControls) _ControlsOverlay(pc: pc),
          ],
        ),
      ),
    );
  }

  BoxFit _fitFor(double? ratio) {
    if (ratio == null) return BoxFit.contain;
    if (ratio == -1) return BoxFit.cover;
    return BoxFit.contain;
  }
}

class _ControlsOverlay extends StatelessWidget {
  final PlayerController pc;
  const _ControlsOverlay({required this.pc});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.overlayBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Top bar
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    pc.current?.displayName ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
                  onPressed: () {},
                  tooltip: 'Picture in Picture',
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () => _showMoreMenu(context, pc),
                ),
              ],
            ),
            const Spacer(),
            // Center controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: pc.previous,
                ),
                const SizedBox(width: 24),
                IconButton(
                  iconSize: 64,
                  icon: Icon(
                    pc.status == PlayerStatus.playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                  ),
                  onPressed: pc.togglePlayPause,
                ),
                const SizedBox(width: 24),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: pc.next,
                ),
              ],
            ),
            const Spacer(),
            // Bottom bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Seek bar
                  Row(
                    children: [
                      Text(_fmt(pc.position), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: pc.duration.inMilliseconds.toDouble().clamp(1, double.infinity),
                          value: pc.position.inMilliseconds.toDouble().clamp(0, pc.duration.inMilliseconds.toDouble()),
                          onChanged: (v) => pc.seek(Duration(milliseconds: v.toInt())),
                          activeColor: AppColors.seekBarActive,
                          inactiveColor: AppColors.seekBarInactive,
                        ),
                      ),
                      Text(_fmt(pc.duration), style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      // Volume
                      IconButton(
                        icon: Icon(pc.muted ? Icons.volume_off : Icons.volume_up, color: Colors.white),
                        onPressed: pc.toggleMute,
                      ),
                      SizedBox(
                        width: 100,
                        child: Slider(
                          min: 0,
                          max: 1,
                          value: pc.volume,
                          onChanged: pc.setVolume,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Speed
                      TextButton(
                        onPressed: pc.cycleSpeed,
                        child: Text('${pc.speed}x', style: const TextStyle(color: Colors.white)),
                      ),
                      const Spacer(),
                      // Aspect ratio
                      PopupMenuButton<double?>(
                        icon: const Icon(Icons.aspect_ratio, color: Colors.white),
                        tooltip: 'Aspect ratio',
                        onSelected: pc.setAspectRatio,
                        itemBuilder: (_) => AppConstants.aspectRatios.entries
                            .map((e) => PopupMenuItem(value: e.value, child: Text(e.key)))
                            .toList(),
                      ),
                      // Subtitles
                      IconButton(
                        icon: const Icon(Icons.subtitles, color: Colors.white),
                        onPressed: () => _showSubtitleMenu(context, pc),
                        tooltip: 'Subtitles',
                      ),
                      // Loop
                      IconButton(
                        icon: Icon(pc.looping ? Icons.repeat_one : Icons.repeat, color: Colors.white),
                        onPressed: pc.toggleLoop,
                      ),
                      // Fullscreen (desktop)
                      IconButton(
                        icon: const Icon(Icons.fullscreen, color: Colors.white),
                        onPressed: () {},
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

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  void _showMoreMenu(BuildContext context, PlayerController pc) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.audiotrack),
              title: const Text('Audio track'),
              onTap: () {
                Navigator.pop(context);
                _showAudioMenu(context, pc);
              },
            ),
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Playback speed'),
              onTap: () {
                Navigator.pop(context);
                _showSpeedMenu(context, pc);
              },
            ),
            ListTile(
              leading: const Icon(Icons.screenshot),
              title: const Text('Screenshot'),
              onTap: () {
                Navigator.pop(context);
                pc.screenshot();
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: Text(pc.current != null && pc.isFavorite(pc.current!.path)
                  ? 'Remove from favorites'
                  : 'Add to favorites'),
              onTap: () {
                if (pc.current != null) pc.toggleFavorite(pc.current!);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Media info'),
              onTap: () {
                Navigator.pop(context);
                _showMediaInfo(context, pc);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSubtitleMenu(BuildContext context, PlayerController pc) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Off'),
              trailing: pc.activeSubtitle == -1 ? const Icon(Icons.check) : null,
              onTap: () { pc.setSubtitleTrack(-1); Navigator.pop(context); },
            ),
            ListTile(
              title: const Text('Auto'),
              trailing: pc.activeSubtitle == 0 ? const Icon(Icons.check) : null,
              onTap: () { pc.setSubtitleTrack(0); Navigator.pop(context); },
            ),
            ...pc.subtitleTracks.asMap().entries.map((e) => ListTile(
                  title: Text('Track ${e.key + 1}'),
                  trailing: pc.activeSubtitle == e.key + 1 ? const Icon(Icons.check) : null,
                  onTap: () { pc.setSubtitleTrack(e.key + 1); Navigator.pop(context); },
                )),
            ListTile(
              leading: const Icon(Icons.file_open),
              title: const Text('Load subtitle file...'),
              onTap: () {
                Navigator.pop(context);
                // file picking handled elsewhere
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAudioMenu(BuildContext context, PlayerController pc) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...pc.audioTracks.asMap().entries.map((e) => ListTile(
                  title: Text('Track ${e.key + 1}'),
                  trailing: pc.activeAudio == e.key ? const Icon(Icons.check) : null,
                  onTap: () { pc.setAudioTrack(e.key); Navigator.pop(context); },
                )),
          ],
        ),
      ),
    );
  }

  void _showSpeedMenu(BuildContext context, PlayerController pc) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: AppConstants.playbackSpeeds
              .map((s) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: ChoiceChip(
                      label: Text('${s}x'),
                      selected: pc.speed == s,
                      onSelected: (_) { pc.setSpeed(s); Navigator.pop(context); },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showMediaInfo(BuildContext context, PlayerController pc) {
    final item = pc.current;
    if (item == null) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Media info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Title', item.displayName),
            _infoRow('Path', item.path),
            _infoRow('Type', item.isAudio ? 'Audio' : 'Video'),
            _infoRow('Format', item.extension.toUpperCase()),
            _infoRow('Duration', _fmt(pc.duration)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  Widget _infoRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(k, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}
