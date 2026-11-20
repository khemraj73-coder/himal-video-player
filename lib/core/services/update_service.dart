import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  static const String _owner = 'khemraj73-coder';
  static const String _repo = 'himal-video-player';
  static const String _currentVersion = '1.0.0';

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final uri = Uri.parse(
          'https://api.github.com/repos/$_owner/$_repo/releases/latest');
      final res = await http.get(uri, headers: {'Accept': 'application/json'});
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final tag = (data['tag_name'] as String?) ?? '';
      final latest = tag.replaceFirst(RegExp(r'^v'), '');
      if (_isNewer(latest, _currentVersion)) {
        return UpdateInfo(
          version: latest,
          url: data['html_url'] as String? ?? '',
          notes: data['body'] as String? ?? '',
        );
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
    return null;
  }

  bool _isNewer(String latest, String current) {
    final l = latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final c = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    for (var i = 0; i < 3; i++) {
      final li = i < l.length ? l[i] : 0;
      final ci = i < c.length ? c[i] : 0;
      if (li != ci) return li > ci;
    }
    return false;
  }

  Future<void> openReleasePage(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class UpdateInfo {
  final String version;
  final String url;
  final String notes;
  const UpdateInfo({required this.version, required this.url, required this.notes});
}