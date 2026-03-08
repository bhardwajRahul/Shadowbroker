#!/bin/bash
echo "======================================================="
echo "   S H A D O W B R O K E R   -   macOS / Linux Start   "
echo "======================================================="
echo ""

# Check for Node.js
if ! command -v npm &> /dev/null; then
    echo "[!] ERROR: npm is not installed. Please install Node.js (https://nodejs.org/)"
    exit 1
fi

# Check for Python 3
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "[!] ERROR: python3 is not installed. Please install Python 3.10+ (https://python.org/)"
    exit 1
fi

echo "[*] Using Python: $PYTHON_CMD ($($PYTHON_CMD --version 2>&1))"

# Get the directory where this script lives (handles running from any location)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[*] Setting up Backend Environment..."
cd "$SCRIPT_DIR/backend"
if [ ! -d "venv" ]; then
    echo "[*] Creating Python Virtual Environment..."
    $PYTHON_CMD -m venv venv
fi

echo "[*] Installing Backend dependencies..."
source venv/bin/activate
pip install -q -r requirements.txt
deactivate

cd "$SCRIPT_DIR"

echo "[*] Setting up Frontend Environment..."
cd "$SCRIPT_DIR/frontend"
if [ ! -d "node_modules" ]; then
    echo "[*] Installing Frontend dependencies..."
    npm install
fi

echo ""
echo "======================================================="
echo "  Starting Services...                                 "
echo "  Dashboard will be available at: http://localhost:3000 "
echo "  Keep this window open! Initial load takes ~10s       "
echo "======================================================="
echo ""

npm run dev
