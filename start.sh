#!/bin/bash

# ============================================================
#   ✦ INFINITY BOT — Auto Installer & Starter ✦
#   Installs: Node.js, npm packages, yt-dlp, python3
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║      ✦ INFINITY BOT — AUTO SETUP ✦       ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# ── Detect Environment ──
IS_TERMUX=false
IS_LINUX=false

if [ -d "/data/data/com.termux" ]; then
  IS_TERMUX=true
  echo -e "${YELLOW}📱 Termux environment detected${NC}"
else
  IS_LINUX=true
  echo -e "${YELLOW}🖥️  Linux/VPS environment detected${NC}"
fi

echo ""

# ════════════════════════════════
#  STEP 1 — Check / Install Node.js
# ════════════════════════════════
echo -e "${CYAN}[1/5] Checking Node.js...${NC}"
if ! command -v node &> /dev/null; then
  echo -e "${YELLOW}⚠️  Node.js not found. Installing...${NC}"
  if $IS_TERMUX; then
    pkg install -y nodejs
  else
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi
else
  echo -e "${GREEN}✅ Node.js found: $(node -v)${NC}"
fi

# ════════════════════════════════
#  STEP 2 — Check / Install Python3 + pip
# ════════════════════════════════
echo ""
echo -e "${CYAN}[2/5] Checking Python3 & pip...${NC}"
if ! command -v python3 &> /dev/null; then
  echo -e "${YELLOW}⚠️  Python3 not found. Installing...${NC}"
  if $IS_TERMUX; then
    pkg install -y python
  else
    sudo apt-get install -y python3 python3-pip
  fi
else
  echo -e "${GREEN}✅ Python3 found: $(python3 --version)${NC}"
fi

if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
  echo -e "${YELLOW}⚠️  pip not found. Installing...${NC}"
  if $IS_TERMUX; then
    pkg install -y python-pip
  else
    sudo apt-get install -y python3-pip
  fi
else
  echo -e "${GREEN}✅ pip found${NC}"
fi

# ════════════════════════════════
#  STEP 3 — Install yt-dlp (REQUIRED)
# ════════════════════════════════
echo ""
echo -e "${CYAN}[3/5] Installing yt-dlp (required for /song & /video)...${NC}"

# Try pip install first
if command -v pip3 &> /dev/null; then
  pip3 install -U yt-dlp
elif command -v pip &> /dev/null; then
  pip install -U yt-dlp
fi

# Double check — if pip failed, try direct binary install
if ! command -v yt-dlp &> /dev/null; then
  echo -e "${YELLOW}⚠️  pip install failed. Trying direct binary...${NC}"
  if $IS_LINUX; then
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
  elif $IS_TERMUX; then
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $PREFIX/bin/yt-dlp
    chmod a+rx $PREFIX/bin/yt-dlp
  fi
fi

# Final check
if command -v yt-dlp &> /dev/null; then
  echo -e "${GREEN}✅ yt-dlp installed: $(yt-dlp --version)${NC}"
else
  echo -e "${RED}❌ yt-dlp install FAILED. /song and /video commands won't work!${NC}"
  echo -e "${RED}   Try manually: pip install yt-dlp${NC}"
fi

# ════════════════════════════════
#  STEP 4 — Install npm packages
# ════════════════════════════════
echo ""
echo -e "${CYAN}[4/5] Installing npm packages...${NC}"

# Create package.json if not exists
if [ ! -f "package.json" ]; then
  echo -e "${YELLOW}📝 Creating package.json...${NC}"
  cat > package.json << 'EOF'
{
  "name": "infinity-bot",
  "version": "7.0.0",
  "type": "module",
  "main": "infinity_bot_v16_XR_encrypted.js",
  "dependencies": {
    "@whiskeysockets/baileys": "latest",
    "google-tts-api": "latest",
    "yt-search": "latest"
  }
}
EOF
fi

npm install @whiskeysockets/baileys google-tts-api yt-search

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ All npm packages installed!${NC}"
else
  echo -e "${RED}❌ npm install failed. Check your internet connection.${NC}"
  exit 1
fi

# ════════════════════════════════
#  STEP 5 — Start the Bot
# ════════════════════════════════
echo ""
echo -e "${CYAN}[5/5] Starting Infinity Bot...${NC}"
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        ✦ INFINITY BOT V7 STARTING ✦      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""

# Use encrypted version if exists, else original
if [ -f "infinity_bot_v16_XR_encrypted.js" ]; then
  node infinity_bot_v16_XR_encrypted.js
elif [ -f "infinity_bot_v16_XR.js" ]; then
  node infinity_bot_v16_XR.js
else
  echo -e "${RED}❌ Bot file not found!${NC}"
  echo -e "${YELLOW}   Make sure infinity_bot_v16_XR_encrypted.js is in this folder.${NC}"
  exit 1
fi
