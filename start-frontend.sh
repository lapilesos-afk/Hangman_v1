#!/bin/bash
# ============================================================================
# Hangman Frontend Starter (Angular Dev Server) - Linux/macOS
# ============================================================================
#
# Startet das Angular Frontend auf Port 4200
#
# Verwendung: bash start-frontend.sh
# URL: http://localhost:4200
# ============================================================================

echo ""
echo "========================================================"
echo "  Hangman Frontend - Angular Dev Server"
echo "========================================================"
echo ""

# Überprüfe Node.js Installation
echo "[1/3] Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    echo "[ERROR] Node.js is not installed!"
    echo "[INFO] Download: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node --version)
echo "[OK] Node.js found: $NODE_VERSION"

# Überprüfe npm Installation
echo "[2/3] Checking npm installation..."
if ! command -v npm &> /dev/null; then
    echo "[ERROR] npm is not installed!"
    exit 1
fi

NPM_VERSION=$(npm --version)
echo "[OK] npm found: $NPM_VERSION"

echo ""
echo "[3/3] Starting Angular Dev Server..."
echo "[INFO] Frontend will be available at: http://localhost:4200"
echo "[INFO] Backend expected at: http://localhost:8080"
echo "[INFO] Press Ctrl+C to stop"
echo ""

# Starte Angular Dev Server
npm start
