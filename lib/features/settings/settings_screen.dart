import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../player/player_controller.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sc = context.watch<SettingsController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _Section(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: sc.themeMode,
              onChanged: (m) => m != null ? sc.setThemeMode(m) : null,
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Accent color'),
            trailing: Wrap(
              spacing: 6,
              children: [
                _ColorDot(color: AppConstants.defaultAccent, selected: sc.accentColor == AppConstants.defaultAccent, onTap: () => sc.setAccentColor(AppConstants.defaultAccent)),
                _ColorDot(color: AppColors.secondary, selected: sc.accentColor == AppColors.secondary, onTap: () => sc.setAccentColor(AppColors.secondary)),
                _ColorDot(color: AppColors.himalayanGreen, selected: sc.accentColor == AppColors.himalayanGreen, onTap: () => sc.setAccentColor(AppColors.himalayanGreen)),
                _ColorDot(color: AppColors.himalayanGold, selected: sc.accentColor == AppColors.himalayanGold, onTap: () => sc.setAccentColor(AppColors.himalayanGold)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: sc.language,
              onChanged: (v) => v != null ? sc.setLanguage(v) : null,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ne', child: Text('नेपाली')),
                DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                DropdownMenuItem(value: 'ja', child: Text('日本語')),
                DropdownMenuItem(value: 'zh', child: Text('中文')),
              ],
            ),
          ),

          _Section(title: 'Playback'),
          SwitchListTile(
            title: const Text('Hardware decoding'),
            subtitle: const Text('Use GPU acceleration when available'),
            value: sc.hardwareDecoding,
            onChanged: sc.setHardwareDecoding,
          ),
          SwitchListTile(
            title: const Text('Auto-play next'),
            value: sc.autoPlayNext,
            onChanged: sc.setAutoPlayNext,
          ),
          SwitchListTile(
            title: const Text('Resume playback'),
            subtitle: const Text('Continue from last position'),
            value: sc.resumePlayback,
            onChanged: sc.setResumePlayback,
          ),
          SwitchListTile(
            title: const Text('Keep screen on'),
            value: sc.keepScreenOn,
            onChanged: sc.setKeepScreenOn,
          ),
          SwitchListTile(
            title: const Text('Background play (audio)'),
            value: sc.backgroundPlay,
            onChanged: sc.setBackgroundPlay,
          ),
          ListTile(
            title: const Text('Default speed'),
            trailing: DropdownButton<double>(
              value: sc.defaultSpeed,
              onChanged: (v) => v != null ? sc.setDefaultSpeed(v) : null,
              items: AppConstants.playbackSpeeds
                  .map((s) => DropdownMenuItem(value: s, child: Text('${s}x')))
                  .toList(),
            ),
          ),

          _Section(title: 'Subtitles'),
          SwitchListTile(
            title: const Text('Enable subtitles'),
            value: sc.subtitlesEnabled,
            onChanged: sc.setSubtitlesEnabled,
          ),
          ListTile(
            title: const Text('Subtitle size'),
            trailing: SizedBox(
              width: 160,
              child: Slider(
                min: 10,
                max: 32,
                value: sc.subtitleSize,
                onChanged: sc.setSubtitleSize,
              ),
            ),
          ),
          ListTile(
            title: const Text('Subtitle color'),
            trailing: DropdownButton<String>(
              value: sc.subtitleColor,
              onChanged: (v) => v != null ? sc.setSubtitleColor(v) : null,
              items: const [
                DropdownMenuItem(value: 'white', child: Text('White')),
                DropdownMenuItem(value: 'yellow', child: Text('Yellow')),
                DropdownMenuItem(value: 'green', child: Text('Green')),
                DropdownMenuItem(value: 'cyan', child: Text('Cyan')),
              ],
            ),
          ),

          _Section(title: 'Audio'),
          SwitchListTile(
            title: const Text('Equalizer'),
            value: sc.equalizerEnabled,
            onChanged: sc.setEqualizerEnabled,
          ),
          if (sc.equalizerEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(10, (i) {
                  return Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              min: -12,
                              max: 12,
                              value: sc.equalizerBands[i],
                              onChanged: (v) => sc.setEqualizerBand(i, v),
                            ),
                          ),
                        ),
                        Text('${i + 1}', style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                }),
              ),
            ),
          if (sc.equalizerEnabled)
            TextButton(
              onPressed: sc.resetEqualizer,
              child: const Text('Reset equalizer'),
            ),
          ListTile(
            title: const Text('Volume boost'),
            subtitle: Text('${sc.volumeBoost.toInt()}%'),
            trailing: SizedBox(
              width: 160,
              child: Slider(
                min: 100,
                max: 200,
                value: sc.volumeBoost,
                onChanged: sc.setVolumeBoost,
              ),
            ),
          ),

          _Section(title: 'About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('HIMAL Video Player'),
            subtitle: Text('Version 1.0.0 • Free & Open Source (MIT)'),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Made with ❤️ by Nepali for everyone\nनेपालीले सबैका लागि बनाएको',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Source code'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _ColorDot({required this.color, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: selected ? [BoxShadow(color: color\.withOpacity(0.6), blurRadius: 6)] : null,
        ),
      ),
    );
  }
}