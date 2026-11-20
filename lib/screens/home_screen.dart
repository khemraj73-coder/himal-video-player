import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../features/player/player_controller.dart';
import '../features/player/player_screen.dart';
import '../features/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pc = context.watch<PlayerController>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('HIMAL'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          _LibraryTab(controller: pc),
          _RecentTab(controller: pc),
          _FavoritesTab(controller: pc),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.video_library), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Recent'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFile(context, pc),
        icon: const Icon(Icons.add),
        label: const Text('Open'),
      ),
    );
  }

  Future<void> _openFile(BuildContext context, PlayerController pc) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: AppConstants.mediaExtensions.toList(),
      allowMultiple: true,
    );
    if (result == null || result.files.isEmpty) return;
    final paths = result.files.map((f) => f.path!).whereType<String>().toList();
    if (paths.isEmpty) return;
    await pc.openFiles(paths);
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlayerScreen()),
    );
  }
}

class _LibraryTab extends StatelessWidget {
  final PlayerController controller;
  const _LibraryTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Your library is empty',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "Open" to play a video or audio file.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: [
              _FormatChip('MP4'),
              _FormatChip('MKV'),
              _FormatChip('AVI'),
              _FormatChip('WebM'),
              _FormatChip('FLAC'),
              _FormatChip('HDR'),
              _FormatChip('Dolby Vision'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  final String label;
  const _FormatChip(this.label);
  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _RecentTab extends StatelessWidget {
  final PlayerController controller;
  const _RecentTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = controller.recent;
    if (items.isEmpty) {
      return const Center(child: Text('No recent files'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return ListTile(
          leading: Icon(item.isAudio ? Icons.audiotrack : Icons.movie),
          title: Text(item.displayName),
          subtitle: Text(item.extension.toUpperCase()),
          trailing: IconButton(
            icon: Icon(
              controller.isFavorite(item.path) ? Icons.favorite : Icons.favorite_border,
              color: controller.isFavorite(item.path) ? Colors.red : null,
            ),
            onPressed: () => controller.toggleFavorite(item),
          ),
          onTap: () async {
            await controller.open(item);
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            );
          },
        );
      },
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  final PlayerController controller;
  const _FavoritesTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = controller.favorites;
    if (items.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return ListTile(
          leading: Icon(item.isAudio ? Icons.audiotrack : Icons.movie),
          title: Text(item.displayName),
          subtitle: Text(item.extension.toUpperCase()),
          onTap: () async {
            await controller.open(item);
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            );
          },
        );
      },
    );
  }
}

