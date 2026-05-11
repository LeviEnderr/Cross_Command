<div align="center">

# ✞ CROSS COMMAND ✞

### Universal media downloader for terminal

Download audio and video from Youtube, Spotify and RaiPlay. 

<p align="center">
  <img src="https://img.shields.io/badge/python-3.8+-3776AB?style=for-the-badge&logo=python&logoColor=white">
  <img src="https://img.shields.io/badge/platform-linux%20%7C%20windows%20%7C%20macos-111111?style=for-the-badge">
  <img src="https://img.shields.io/badge/license-MIT-22c55e?style=for-the-badge">
  <img src="https://img.shields.io/badge/Soli%20Deo%20Gloria-DAA520?style=for-the-badge">
</p>

</div>

---

> ⚠️ **Disclaimer** : cross is a personal, educational project. It is intended strictly for private use. Downloading copyrighted content for commercial purposes, redistribution, or any use beyond personal viewing/listening is illegal and against the terms of service of YouTube, Spotify, and RaiPlay. The author takes no responsibility for misuse.

---

## Usage

```bash
cross <url> -mp3|-mp4 [destination] [-p]
```

| Flag | Description |
|------|-------------|
| `-mp3` | Audio MP3 · 320kbps |
| `-mp4` | Video MP4 · best quality |
| `dest` | Output folder (default: current) |
| `-p` | Playlist mode |

---

# 🎬 Showcase

## 🎥 YouTube Video Download

Download YouTube videos directly in MP4 format from your terminal.

> `-mp3` or `-mp4` is always required.

https://github.com/user-attachments/assets/4f928890-baa9-4193-b700-2e63c1000be3

---

## 🎵 Spotify Track Download

Automatic Spotify audio download and conversion.

> Spotify downloads support `-mp3` only.

https://github.com/user-attachments/assets/620918cb-f801-48e1-a207-9a00b085f442

---

## 📚 Spotify Playlist Download

Full Spotify playlist support.

> Playlist downloads require the `-p` flag.

https://github.com/user-attachments/assets/8c4f8d1c-4ae3-4a89-af44-cb701c5bcb89

---

## ▶️ YouTube Playlist Download

Download entire YouTube playlists automatically.

> Playlist downloads require the `-p` flag.

https://github.com/user-attachments/assets/b52f4ac4-a259-4988-9743-37283e7e272c

---

## 📺 RaiPlay Movie Download

Download RaiPlay content directly in MP4 format.

> `-mp3` or `-mp4` is always required.

https://github.com/user-attachments/assets/ffec8cdd-e71d-407e-8ccb-f22714a4c5ac

---

# ✨ Features

- ⚡ Ultra fast downloads
- 🎵 MP3 support
- 🎬 MP4 support
- 📚 Playlist support
- 🔥 Multi-platform support
- 📦 Automatic installer

---

# 📦 Installation

```bash
git clone https://github.com/LeviEnderr/Cross_Command.git

cd Cross_Command

bash install.sh
```

---

> [!IMPORTANT]
> If the URL contains special characters like `&` or `?`, always use quotes. Playlist downloads require the `-p` flag. You must always specify either `-mp3` or `-mp4`.

Correct:

```bash
cross "https://youtube.com/playlist?list=xxxx&si=xxxx" -mp4 -p
```

---

# 🧠 Examples

```bash
cross "<url>" -mp3
```

```bash
cross "<url>" -mp4
```

---

# ✝️ On Faith

This project is called **Cross** for a reason.

I'm a Christian, and I named this tool after the Cross of Jesus Christ, because I believe He is the truth, the way, and the source of life.

Technology, code, and open source mean very little if a person loses themselves spiritually. We spend so much time consuming content, chasing distractions, pleasure, money, validation, but very little time asking the important questions:

- Why are we here?
- What happens after death?
- What is truth?
- Does God exist?
- Can a person truly change?

I believe the answer is Jesus Christ.

This project isn't just about downloading media.  
It's also a small reminder that your soul matters more than your screen.

If you've never seriously explored Christianity, start by reading the Gospel of John with an open mind. Not religion. Not internet arguments. Just read the words of Christ for yourself.

> *“I am the way and the truth and the life. No one comes to the Father except through me.”*  
> -John 14:6

> *“What good will it be for someone to gain the whole world, yet forfeit their soul?”*  
> Matthew 16:26


---

# 🔞 Porn Site Block

cross includes a block for pornographic websites.

This project is called **Cross** for a reason, and I never wanted a tool dedicated to Christ to be used for lust, pornography, or content that destroys people spiritually and mentally.

The goal is not control, it's conviction.

Pornography damages the mind, relationships, self-control, and the way people view others. I don't want this project to contribute to that.

cross is meant to be used for useful, creative, educational, and positive purposes, not for feeding addiction or lust.

Porn sites are intentionally blocked.

> *“But among you there must not be even a hint of sexual immorality…”*  
> -Ephesians 5:3

---

## How it works

**Spotify** doesn't allow direct downloads. cross reads the track metadata via the oEmbed API and the embed page, then searches YouTube Music for the official audio version and downloads that.

```
Spotify URL ──► oEmbed API (title) + Embed scraping (artist)
                    │
                    └──► ytsearch1: "{title} {artist} official audio"
                                │
                                └──► yt-dlp ──► MP3 320kbps
```

**YouTube** is downloaded directly using yt-dlp with Firefox/Chrome cookies and a Node.js JS challenge solver to bypass bot detection.

```
YouTube URL ──► yt-dlp (cookies + Node.js EJS solver)
                    │
                    ├──► -mp3: bestaudio ──► ffmpeg ──► MP3 320kbps
                    └──► -mp4: bestvideo+bestaudio ──► ffmpeg merge ──► MP4
```

**RaiPlay** serves content as HLS streams. cross downloads them and remuxes with ffmpeg, regenerating timestamps to fix broadcast artifacts.

```
RaiPlay URL ──► yt-dlp ──► HLS segments
                                │
                                └──► ffmpeg remux (-fflags +genpts) ──► MP4
```

---

## How it actually works (technical)

cross is a Python script that wraps yt-dlp with opinionated defaults. Key technical decisions:

- **Cookies from browser** — reads Firefox or Chrome cookies automatically via yt-dlp's `cookiesfrombrowser`. No manual export needed.
- **Node.js EJS solver** — YouTube's bot detection requires JavaScript execution. cross uses Node.js with yt-dlp's remote EJS challenge solver, downloaded once and cached.
- **ffmpeg remux on MP4** — every MP4 download goes through `ffmpeg -c copy -fflags +genpts -avoid_negative_ts make_zero`. This fixes HLS timestamp discontinuities without re-encoding.
- **Spotify via oEmbed** — Spotify's public pages no longer expose metadata in HTML. cross uses the oEmbed endpoint for the title and scrapes the embed iframe for the artist name.
- **Format fallback chain** — `137+140 / 136+140 / 135+140 / 248+251 / bestvideo+bestaudio / best`. If the best format fails, cross tries progressively lower quality until something works.

---

## Uninstall

```bash
rm ~/.local/bin/cross
rm -f ~/.local/bin/cross.py
rm -f ~/.local/bin/yt-dlp
pip3 uninstall yt-dlp -y
```

---

# 🔥 Roadmap

- [ ] Add the option to download Instagram Reels and TikTok
- [ ] Parallel downloads
- [ ] Download queue

---

<div align="center">

## 🐙 Levi 🐙

> https://www.youtube.com/@LeviEnderr  |  https://github.com/LeviEnderr

</div>

---

## Credits

Inspired by [clip](https://github.com/sxmplyfarhan/Clip-Command) by [Farhan](https://github.com/sxmplyfarhan), a classmate whose idea started this. His project doesn't work anymore, but the idea was good enough to build on.

---

<div align="center">

```
  ·   ♰ Fortis Deus Adiuvat ♰   ·
```

`▓ END OF FILE ▓`

</div>
