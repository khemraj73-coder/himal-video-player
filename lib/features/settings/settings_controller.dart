import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

class SettingsController extends ChangeNotifier {
  SettingsController() {
    _load();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Color _accentColor = AppConstants.defaultAccent;
  Color get accentColor => _accentColor;

  String _language = 'en';
  String get language => _language;

  bool _hardwareDecoding = true;
  bool get hardwareDecoding => _hardwareDecoding;

  bool _autoPlayNext = true;
  bool get autoPlayNext => _autoPlayNext;

  bool _resumePlayback = true;
  bool get resumePlayback => _resumePlayback;

  bool _rememberBrightness = true;
  bool get rememberBrightness => _rememberBrightness;

  double _defaultSpeed = 1.0;
  double get defaultSpeed => _defaultSpeed;

  bool _subtitlesEnabled = true;
  bool get subtitlesEnabled => _subtitlesEnabled;

  double _subtitleSize = 16;
  double get subtitleSize => _subtitleSize;

  String _subtitleColor = 'white';
  String get subtitleColor => _subtitleColor;

  bool _equalizerEnabled = false;
  bool get equalizerEnabled => _equalizerEnabled;

  List<double> _equalizerBands = List.filled(10, 0.0);
  List<double> get equalizerBands => _equalizerBands;

  bool _keepScreenOn = true;
  bool get keepScreenOn => _keepScreenOn;

  bool _backgroundPlay = false;
  bool get backgroundPlay => _backgroundPlay;

  // Volume boost (0..200%)
  double _volumeBoost = 100;
  double get volumeBoost => _volumeBoost;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    final accent = prefs.getInt('accentColor');
    if (accent != null) _accentColor = Color(accent);
    _language = prefs.getString('language') ?? 'en';
    _hardwareDecoding = prefs.getBool('hardwareDecoding') ?? true;
    _autoPlayNext = prefs.getBool('autoPlayNext') ?? true;
    _resumePlayback = prefs.getBool('resumePlayback') ?? true;
    _rememberBrightness = prefs.getBool('rememberBrightness') ?? true;
    _defaultSpeed = prefs.getDouble('defaultSpeed') ?? 1.0;
    _subtitlesEnabled = prefs.getBool('subtitlesEnabled') ?? true;
    _subtitleSize = prefs.getDouble('subtitleSize') ?? 16;
    _subtitleColor = prefs.getString('subtitleColor') ?? 'white';
    _equalizerEnabled = prefs.getBool('equalizerEnabled') ?? false;
    _equalizerBands = prefs.getStringList('equalizerBands')?.map(double.parse).toList() ??
        List.filled(10, 0.0);
    _keepScreenOn = prefs.getBool('keepScreenOn') ?? true;
    _backgroundPlay = prefs.getBool('backgroundPlay') ?? false;
    _volumeBoost = prefs.getDouble('volumeBoost') ?? 100;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
    await prefs.setInt('accentColor', _accentColor.value);
    await prefs.setString('language', _language);
    await prefs.setBool('hardwareDecoding', _hardwareDecoding);
    await prefs.setBool('autoPlayNext', _autoPlayNext);
    await prefs.setBool('resumePlayback', _resumePlayback);
    await prefs.setBool('rememberBrightness', _rememberBrightness);
    await prefs.setDouble('defaultSpeed', _defaultSpeed);
    await prefs.setBool('subtitlesEnabled', _subtitlesEnabled);
    await prefs.setDouble('subtitleSize', _subtitleSize);
    await prefs.setString('subtitleColor', _subtitleColor);
    await prefs.setBool('equalizerEnabled', _equalizerEnabled);
    await prefs.setStringList('equalizerBands', _equalizerBands.map((e) => e.toString()).toList());
    await prefs.setBool('keepScreenOn', _keepScreenOn);
    await prefs.setBool('backgroundPlay', _backgroundPlay);
    await prefs.setDouble('volumeBoost', _volumeBoost);
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _save();
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    _save();
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    _save();
    notifyListeners();
  }

  void setHardwareDecoding(bool v) {
    _hardwareDecoding = v;
    _save();
    notifyListeners();
  }

  void setAutoPlayNext(bool v) {
    _autoPlayNext = v;
    _save();
    notifyListeners();
  }

  void setResumePlayback(bool v) {
    _resumePlayback = v;
    _save();
    notifyListeners();
  }

  void setRememberBrightness(bool v) {
    _rememberBrightness = v;
    _save();
    notifyListeners();
  }

  void setDefaultSpeed(double v) {
    _defaultSpeed = v;
    _save();
    notifyListeners();
  }

  void setSubtitlesEnabled(bool v) {
    _subtitlesEnabled = v;
    _save();
    notifyListeners();
  }

  void setSubtitleSize(double v) {
    _subtitleSize = v;
    _save();
    notifyListeners();
  }

  void setSubtitleColor(String v) {
    _subtitleColor = v;
    _save();
    notifyListeners();
  }

  void setEqualizerEnabled(bool v) {
    _equalizerEnabled = v;
    _save();
    notifyListeners();
  }

  void setEqualizerBand(int index, double value) {
    _equalizerBands[index] = value;
    _save();
    notifyListeners();
  }

  void resetEqualizer() {
    _equalizerBands = List.filled(10, 0.0);
    _save();
    notifyListeners();
  }

  void setKeepScreenOn(bool v) {
    _keepScreenOn = v;
    _save();
    notifyListeners();
  }

  void setBackgroundPlay(bool v) {
    _backgroundPlay = v;
    _save();
    notifyListeners();
  }

  void setVolumeBoost(double v) {
    _volumeBoost = v;
    _save();
    notifyListeners();
  }
}