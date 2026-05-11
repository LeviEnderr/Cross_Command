#!/usr/bin/env bash
set -e

G='\033[92m'; R='\033[91m'; RS='\033[0m'; D='\033[2m'
err() { echo -e "  ${R}✗  $1${RS}"; exit 1; }

# ─── PATH ─────────────────────────────────────────────────────────────────────
BIN="$HOME/.local/bin"; mkdir -p "$BIN"
[[ ":$PATH:" != *":$BIN:"* ]] && {
    for RC in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        [[ -f "$RC" ]] && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC"
    done
    export PATH="$BIN:$PATH"
}

# ─── Package manager ──────────────────────────────────────────────────────────
pkg() {
    local p="$1"
    if   command -v dnf     &>/dev/null; then sudo dnf     install -y -q "$p" &>/dev/null
    elif command -v apt-get &>/dev/null; then sudo apt-get install -y -q "$p" &>/dev/null
    elif command -v pacman  &>/dev/null; then sudo pacman  -S --noconfirm -q  "$p" &>/dev/null
    elif command -v zypper  &>/dev/null; then sudo zypper  install -y -q      "$p" &>/dev/null
    elif command -v apk     &>/dev/null; then sudo apk     add -q             "$p" &>/dev/null
    elif command -v brew    &>/dev/null; then brew install -q                 "$p" &>/dev/null
    else err "Package manager not found. Install manually: $p"; fi
}

# ─── Dipendenze ───────────────────────────────────────────────────────────────
command -v python3 &>/dev/null || pkg python3
command -v pip3    &>/dev/null || pkg python3-pip
command -v curl    &>/dev/null || pkg curl
command -v node    &>/dev/null || pkg nodejs
command -v ffmpeg  &>/dev/null || pkg ffmpeg 2>/dev/null || pkg ffmpeg-free 2>/dev/null || true

# pip: yt-dlp come modulo Python (più stabile del binario standalone su Python 3.14)
python3 -c "import yt_dlp" 2>/dev/null || pip3 install --user -q yt-dlp 2>/dev/null || true

# ─── yt-dlp binario (fallback + aggiornamento) ────────────────────────────────
if command -v yt-dlp &>/dev/null; then
    yt-dlp -U --quiet 2>/dev/null || true
else
    curl -sSL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$BIN/yt-dlp"
    chmod +x "$BIN/yt-dlp"
fi

# ─── cross ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
[[ -f "$SCRIPT_DIR/cross" ]] || err "File 'cross' not found in the same folder as install.sh"
cp "$SCRIPT_DIR/cross" "$BIN/cross"
chmod +x "$BIN/cross"

# ─── EJS solver (JS challenge per YouTube) ────────────────────────────────────
yt-dlp --js-runtimes node --remote-components ejs:github : >/dev/null 2>&1 || true

# ─── Banner ───────────────────────────────────────────────────────────────────
echo -e ""
lines=(
"                    ,-=====-,          "
"                    | .---. |          "
"                    | |   | |          "
"                    | |   | |          "
"                    | '---' |          "
"                    |       |          "
"                    |       |          "
" .-================-'       '-================-.  "
" |  _                                          |  "
" |.'o\\                                    __   |  "
" | '-.''.                                .'o.\` |  "
" '-==='.'.=========-.       .-========.'.-'===-'  "
"        '.'._.    .===,     |     _.-' /           "
"          '._ '-./  ,//\\   _| _.-'  _.'            "
"             '-.|  ,//'  \\-'  \`   .-'             "
"               \`//'_\`--;    ;.-'                 "
"                 \`\\. ;|    |                     "
"                    \\-'  . |                     "
"                    |_.-'-._|                    "
"                    \\  _'_  /                    "
"                    |; -:- |                     "
"                    || -.- \\                     "
"                    |;     .\\                    "
"                    / \`'\\''\`\\-;              "
"                   ;\`   '. \`_/                   "
"                   |,\`-._;  .;                   "
"                   \`;\\ \`.-'-;                   "
"                    | \\   \\  |                   "
"                    |  \`\\  \\ |                  "
"                    |   )  | |                   "
"                    |  /  /\` /                   "
"                    | |  /|  |                   "
"                    | | / | /                    "
"                    | / |/ /|                    "
"                    | \\ / / |                    "
"                    |  /o | |                    "
"                    |  |_/  |                    "
"                    |       |                    "
"                    '-=====-'                    "
)
for line in "${lines[@]}"; do
    echo -e "  ${G}${line}${RS}"
    sleep 0.04
done
echo -e ""
echo -e "  ${D}                   made by Levi${RS}"
echo -e ""
echo -e "  ${G}           https://github.com/LeviEnderr${RS}"
echo -e ""
echo -e "  ${D}       cross installed | cross <url> -mp3 / -mp4${RS}"
echo -e ""
