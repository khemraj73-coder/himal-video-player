# Supported Formats

HIMAL is powered by libmpv + FFmpeg. The lists below are representative; FFmpeg supports
many more formats than listed.

## Containers
MP4, MKV, AVI, MOV, WMV, FLV, WebM, TS, M2TS, MTS, MPG, MPEG, VOB, OGV, 3GP, 3G2,
ASF, RM, RMVB, DIVX, F4V, M4V, MXF, DV, OGM, MKA, M4A, MP3, FLAC, WAV, OGG, OPUS,
AAC, WMA, APE, ALAC, AIFF, CAF, DTS, AC3, EAC3, TTA, WV, and playlists (M3U, M3U8, PLS, XSPF).

## Video codecs
H.264/AVC, H.265/HEVC, AV1, VP8, VP9, MPEG-1, MPEG-2, MPEG-4 Part 2, VC-1, Theora,
ProRes, DNxHD/DNxHR, WMV, RealVideo, DivX/XviD, Cinepak, MJPEG, and hardware-accelerated
decoding (DXVA, VA-API, VideoToolbox, MediaCodec) where available.

## Audio codecs
AAC, MP3, FLAC, Opus, Vorbis, AC3 (Dolby Digital), E-AC3 (Dolby Digital Plus),
DTS, DTS-HD MA, TrueHD, Dolby Atmos, PCM (8/16/24/32-bit, int/float), ALAC, APE,
WMA, TTA, and channel layouts up to 7.1 + objects.

## HDR / color
- SDR (BT.709, BT.601, BT.2020 SDR)
- HDR10 (ST.2084 PQ, BT.2020)
- HDR10+
- HLG (Hybrid Log-Gamma)
- Dolby Vision (Profile 5, 7, 8) with tone mapping; passthrough where display supports it

Tone mapping uses libmpv's `tone-mapping` (auto/mobius/reinhard/hable/gamma/clip/linear)
and is configurable in settings.

## Subtitles
SRT, ASS/SSA, VTT, SUB, IDX/VOBSUB, PGS (Blu-ray), TTML/DFXP, and embedded
text/bitmap subtitle tracks.

## Network streams (roadmap)
HLS, DASH, RTSP, RTMP, HTTP/HTTPS progressive download.