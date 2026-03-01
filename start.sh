#!/bin/bash

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   ♾️   INFINITY BOT V9 — SETUP   ♾️   ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Node.js check ──
if ! command -v node &>/dev/null; then
  echo "❌ Node.js nahi mila! Install karo pehle."
  exit 1
fi
echo "✅ Node.js $(node -v)"

# ── Python check ──
if command -v python3 &>/dev/null; then
  echo "✅ Python $(python3 --version)"
elif command -v python &>/dev/null; then
  echo "✅ Python $(python --version)"
else
  echo "⚠️  Python nahi mila — yt-dlp binary se install hoga"
fi

# ── npm packages ──
echo ""
echo "📦 [1/4] npm packages install ho rahi hain..."
npm install
echo "✅ npm done"

# ── yt-dlp ──
echo ""
echo "📦 [2/4] yt-dlp install ho raha hai..."

if pip3 install yt-dlp --break-system-packages 2>/dev/null || pip3 install yt-dlp 2>/dev/null || pip install yt-dlp --break-system-packages 2>/dev/null || pip install yt-dlp 2>/dev/null; then
  echo "✅ yt-dlp (pip)"
else
  echo "⏳ pip nahi chala — binary se try kar raha hai..."
  if curl -sL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$HOME/.local/bin/yt-dlp" 2>/dev/null; then
    chmod a+rx "$HOME/.local/bin/yt-dlp"
    export PATH="$HOME/.local/bin:$PATH"
    echo "✅ yt-dlp (binary HOME)"
  elif sudo curl -sL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp 2>/dev/null; then
    sudo chmod a+rx /usr/local/bin/yt-dlp
    echo "✅ yt-dlp (binary sudo)"
  else
    echo "⚠️  yt-dlp install nahi hua — music/video kaam nahi karega"
  fi
fi

# ── ffmpeg (audio conversion ke liye) ──
echo ""
echo "📦 [3/4] ffmpeg check..."
if command -v ffmpeg &>/dev/null; then
  echo "✅ ffmpeg already installed"
else
  echo "⏳ ffmpeg install ho raha hai..."
  sudo apt-get install -y ffmpeg 2>/dev/null || echo "⚠️  ffmpeg install nahi hua"
fi

# ── Data folders ──
echo ""
echo "📦 [4/4] Folders bana raha hai..."
mkdir -p data data/backups temp_music temp_video
echo "✅ Folders ready"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║      🚀  BOT START HO RAHA HAI!      ║"
echo "╚══════════════════════════════════════╝"
echo "💡 Band karne ke liye: Ctrl + C"
echo ""

node infinity_bot_v9_final.js
