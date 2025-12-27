#!/bin/bash
# ============================================
# System Monitor - Installation Script
# Automatyczna instalacja i konfiguracja autostartu
# ============================================

set -e

echo "🖥️  System Monitor - Instalator"
echo "================================"
echo ""X

# Ścieżki
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="menubar_monitor.py"
PLIST_NAME="com.user.systemmonitor.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"

# 1. Sprawdź zależności
echo "📦 Sprawdzam zależności..."
if ! python3 -c "import rumps" 2>/dev/null; then
    echo "   Instaluję rumps..."
    pip3 install rumps --quiet
fi

if ! python3 -c "import psutil" 2>/dev/null; then
    echo "   Instaluję psutil..."
    pip3 install psutil --quiet
fi
echo "   ✅ Zależności OK"

# 2. Utwórz katalog instalacyjny
echo "📁 Tworzę katalog instalacyjny..."
mkdir -p "$INSTALL_DIR"
echo "   ✅ $INSTALL_DIR"

# 3. Skopiuj skrypt
echo "📋 Kopiuję skrypt..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/menubar_monitor.py" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/menubar_monitor.py"
echo "   ✅ Skopiowano do $INSTALL_DIR/$SCRIPT_NAME"

# 4. Utwórz LaunchAgent
echo "⚙️  Konfiguruję autostart..."
mkdir -p "$LAUNCH_AGENTS_DIR"

cat > "$LAUNCH_AGENTS_DIR/$PLIST_NAME" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.systemmonitor</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>$INSTALL_DIR/$SCRIPT_NAME</string>
    </array>
    
    <key>RunAtLoad</key>
    <true/>
    
    <key>KeepAlive</key>
    <true/>
    
    <key>StandardOutPath</key>
    <string>$HOME/.local/bin/systemmonitor.log</string>
    
    <key>StandardErrorPath</key>
    <string>$HOME/.local/bin/systemmonitor.error.log</string>
</dict>
</plist>
EOF

echo "   ✅ Utworzono $LAUNCH_AGENTS_DIR/$PLIST_NAME"

# 5. Załaduj LaunchAgent
echo "🚀 Uruchamiam..."
launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME"
echo "   ✅ LaunchAgent załadowany"

echo ""
echo "============================================"
echo "✅ INSTALACJA ZAKOŃCZONA!"
echo "============================================"
echo ""
echo "System Monitor jest teraz:"
echo "  • Uruchomiony (sprawdź menu bar)"
echo "  • Skonfigurowany do autostartu"
echo ""
echo "Przydatne komendy:"
echo "  • Zatrzymaj:  launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
echo "  • Uruchom:    launchctl load ~/Library/LaunchAgents/$PLIST_NAME"
echo "  • Restart:    launchctl kickstart -k gui/\$(id -u)/com.user.systemmonitor"
echo "  • Odinstaluj: ./uninstall.sh"
echo ""
