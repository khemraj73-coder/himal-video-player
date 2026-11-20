# HIMAL Video Player

**HIMAL** (Himalayan Integrated Media & Audio Layer) is the ultimate **free, open-source, cross-platform video player** built for everyone. It plays **every format, every codec, and every HDR standard** — HDR, HDR+, HDR10, HDR10+, Dolby Vision — with full surround-sound audio support, on **Windows, Linux, macOS, iOS and Android**.

> One player. Every format. Every device. Free forever.
>
> **Made with ❤️ by Nepali for everyone — नेपालीले सबैका लागि बनाएको**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20Linux%20%7C%20macOS%20%7C%20iOS%20%7C%20Android-blue)]()
[![Flutter](https://img.shields.io/badge/built%20with-Flutter-02569B)]()

## Why HIMAL?

Most video players force you to choose: either they support a wide range of formats but are closed-source/paid, or they are free but limited. **HIMAL** breaks that trade-off:

- **Truly universal** — powered by [libmpv](https://mpv.io/) + [FFmpeg](https://ffmpeg.org/), HIMAL decodes virtually every container, codec and HDR standard in existence.
- **Every HDR standard** — SDR, HDR, HDR+, HDR10, HDR10+, Dolby Vision (Profile 5/7/8) with tone-mapping and passthrough.
- **Every audio format** — AAC, MP3, FLAC, Opus, Vorbis, AC3, E-AC3, DTS, DTS-HD, TrueHD, Dolby Atmos, PCM, and more, with channel upmixing and downmixing.
- **Cross-platform** — a single codebase (Flutter) ships native apps for Windows, Linux, macOS, iOS and Android.
- **Free & open source** — MIT licensed. No ads, no tracking, no premium tier. Ever.
- **Modern UX** — gesture controls, PiP, cast, subtitles, audio track selection, equalizer, playlist, library, theming.

## Supported formats

### Containers
MP4, MKV, AVI, MOV, WMV, FLV, WebM, TS, M2TS, MTS, MPG, MPEG, VOB, OGV, 3GP, 3G2, ASF, RM, RMVB, DIVX, F4V, M4V, M4A, MP3, FLAC, WAV, OGG, OPUS, AAC, MKA, WMA, APE, ALAC, AIFF, CAF, DTS, AC3, EAC3, and more.

### Video codecs
H.264/AVC, H.265/HEVC, AV1, VP8, VP9, MPEG-1/2/4, VC-1, Theora, ProRes, DNxHD, WMV, RealVideo, DivX/XviD, and hardware-accelerated decoding where available.

### Audio codecs
AAC, MP3, FLAC, Opus, Vorbis, AC3, E-AC3 (Dolby Digital Plus), DTS, DTS-HD MA, TrueHD, Dolby Atmos, PCM (16/24/32-bit), ALAC, APE, WMA, and more.

### HDR / color
SDR (BT.709), HDR10 (ST.2084 / PQ), HDR10+, HLG, Dolby Vision (Profile 5, 7, 8), with tone mapping and (where supported) HDR passthrough.

### Subtitles
SRT, ASS/SSA, VTT, SUB, IDX, PGS (Blu-ray), DVD (VOBSUB), TTML, and embedded text/bitmap subtitles.

## Features

- 🎬 Play anything — universal decoding via FFmpeg/libmpv
- 🌈 HDR & Dolby Vision with tone mapping + passthrough
- 🔊 Full audio format & surround sound support, equalizer, audio delay
- 📝 Subtitle support with styling, sync adjustment, online search
- 🎞️ Playlists, library, recent files, favorites
- 🖱️ Gesture controls (volume, brightness, seek) on mobile
- 🪟 Picture-in-Picture (PiP) on supported platforms
- 📺 Cast to TV (Chromecast / DLNA) — roadmap
- 🎨 Light/Dark themes + accent color picker
- ⌨️ Keyboard shortcuts & media keys
- 🌍 Multi-language UI (i18n)
- ♿ Accessibility (screen reader friendly)
- 🔒 No telemetry, no ads, no tracking

## Getting started

### Prerequisites
- [Flutter](https://flutter.dev/) 3.19+
- For desktop: platform toolchains (Visual Studio / Xcode / GTK dev libs)
- FFmpeg/libmpv libs are bundled via `media_kit_libs_video` (no manual install needed)

### Run
```bash
git clone https://github.com/khemraj73-coder/himal-video-player.git
cd himal-video-player
flutter pub get
flutter run -d windows   # or linux, macos, ios, android
```

### Build release
```bash
flutter build windows
flutter build linux
flutter build macos
flutter build apk
flutter build ios
```

## Architecture

```
lib/
├── main.dart                 # entry point
├── app.dart                  # MaterialApp + providers
├── core/
│   ├── constants/            # app-wide constants
│   ├── theme/                # theming
│   ├── utils/                # helpers
│   └── services/             # platform services
├── features/
│   ├── player/               # player screen, controller, widgets
│   ├── playlist/
│   ├── library/
│   ├── settings/
│   └── onboarding/
└── widgets/                  # shared widgets
```

State management via `provider`. Playback via `media_kit` (libmpv).

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a PR. By contributing you agree your code is licensed under MIT.

## Roadmap
- [ ] Chromecast / DLNA casting
- [ ] Network streams (HLS, DASH, RTSP, RTMP)
- [ ] Audio-only mode with background playback
- [ ] Plugin system for custom decoders
- [ ] Smart TV (Android TV / tvOS) builds

## Trademarks & legal

- "Dolby", "Dolby Vision", "Dolby Atmos", "Dolby Digital" are trademarks of Dolby Laboratories.
- "Chromecast" is a trademark of Google LLC.
- "Windows", "macOS", "iOS", "Android", "Linux" are trademarks of their respective owners.
- HIMAL is an independent project and is not affiliated with or endorsed by any of the above.
- HIMAL bundles FFmpeg/libmpv via `media_kit`. FFmpeg is licensed under LGPL/GPL depending on build
  configuration; HIMAL uses LGPL-compatible builds where possible. See [FFmpeg licensing](https://ffmpeg.org/legal.html)
  and the `media_kit` documentation for details. If you redistribute HIMAL, ensure your FFmpeg build complies.
- HIMAL is a media player only. It does not circumvent DRM and does not include any copyrighted content.

## License

MIT — see [LICENSE](LICENSE).

## Acknowledgements
Built on the shoulders of [Flutter](https://flutter.dev/), [media_kit](https://github.com/media-kit/media-kit), [libmpv](https://mpv.io/) and [FFmpeg](https://ffmpeg.org/).