# System Monitor - Menu Bar App dla macOS

Prosta aplikacja pokazująca w menu bar:
- **CPU** - aktualne użycie procesora (%)
- **RAM** - aktualne użycie pamięci (%)

Wygląd w menu bar: `CPU 57% │ RAM 80%`

---

## 📋 Wymagania

- macOS
- Python 3 (preinstalowany na macOS)
- Biblioteki: `rumps`, `psutil`

---

## 🚀 Instalacja od zera (po reinstalacji systemu)

### Krok 1: Zainstaluj zależności

Otwórz Terminal (`Cmd + Spacja` → wpisz `Terminal`) i wpisz:

```bash
pip3 install rumps psutil
```

### Krok 2: Utwórz folder na skrypt

```bash
mkdir -p ~/.local/bin
```

### Krok 3: Skopiuj skrypt

```bash
cp ~/Documents/menubar_monitor/menubar_monitor.py ~/.local/bin/
```

### Krok 4: Utwórz autostart (LaunchAgent)

```bash
cat > ~/Library/LaunchAgents/com.user.systemmonitor.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.systemmonitor</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>/Users/marcintymkow/.local/bin/menubar_monitor.py</string>
    </array>
    
    <key>RunAtLoad</key>
    <true/>
    
    <key>KeepAlive</key>
    <true/>
    
    <key>StandardOutPath</key>
    <string>/Users/marcintymkow/.local/bin/systemmonitor.log</string>
    
    <key>StandardErrorPath</key>
    <string>/Users/marcintymkow/.local/bin/systemmonitor.error.log</string>
</dict>
</plist>
EOF
```

### Krok 5: Uruchom aplikację

```bash
launchctl load ~/Library/LaunchAgents/com.user.systemmonitor.plist
```

✅ **Gotowe!** Aplikacja działa i uruchomi się automatycznie po każdym restarcie.

---

## 🔧 Przydatne komendy

| Co chcesz zrobić | Komenda |
|------------------|---------|
| **Uruchom** | `launchctl load ~/Library/LaunchAgents/com.user.systemmonitor.plist` |
| **Zatrzymaj** | `launchctl unload ~/Library/LaunchAgents/com.user.systemmonitor.plist` |
| **Restart** | `launchctl kickstart -k gui/$(id -u)/com.user.systemmonitor` |
| **Sprawdź status** | `launchctl list | grep systemmonitor` |
| **Zobacz logi** | `cat ~/.local/bin/systemmonitor.log` |
| **Zobacz błędy** | `cat ~/.local/bin/systemmonitor.error.log` |

---

## 📦 Szybka instalacja (jedno polecenie)

Po reinstalacji systemu - skopiuj i wklej całość do Terminala:

```bash
pip3 install rumps psutil && \
mkdir -p ~/.local/bin && \
cp ~/Documents/menubar_monitor/menubar_monitor.py ~/.local/bin/ && \
cat > ~/Library/LaunchAgents/com.user.systemmonitor.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.systemmonitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>/Users/marcintymkow/.local/bin/menubar_monitor.py</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF
launchctl load ~/Library/LaunchAgents/com.user.systemmonitor.plist
```

---

## 🗑️ Odinstalowanie

```bash
launchctl unload ~/Library/LaunchAgents/com.user.systemmonitor.plist
rm ~/Library/LaunchAgents/com.user.systemmonitor.plist
rm ~/.local/bin/menubar_monitor.py
```

---

## 📁 Struktura plików

```
~/Documents/menubar_monitor/
├── menubar_monitor.py      # Główny skrypt (kopia zapasowa)
└── README.md               # Ta instrukcja

~/.local/bin/
└── menubar_monitor.py      # Działający skrypt

~/Library/LaunchAgents/
└── com.user.systemmonitor.plist  # Konfiguracja autostartu
```

---

## ℹ️ Uwagi

- Aplikacja odświeża dane co 2 sekundy
- Temperatura CPU nie jest pokazywana (nie działa na Apple Silicon M1/M2/M3)
- Po kliknięciu w menu bar zobaczysz szczegóły (dokładne GB RAM)
- Aby wyjść z aplikacji: kliknij w menu bar → Quit

---

## 🐛 Rozwiązywanie problemów

**Nie widzę nic w menu bar:**
```bash
# Sprawdź czy działa
launchctl list | grep systemmonitor

# Zobacz błędy
cat ~/.local/bin/systemmonitor.error.log
```

**Brak bibliotek:**
```bash
pip3 install rumps psutil
```

**Chcę zmienić częstotliwość odświeżania:**

Edytuj `~/.local/bin/menubar_monitor.py`, znajdź linię:
```python
self.timer = rumps.Timer(self.update_stats, 2)
```
Zmień `2` na inną wartość (w sekundach).

---

*Utworzono: Grudzień 2025r.*
