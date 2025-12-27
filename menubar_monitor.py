#!/usr/bin/env python3
"""
System Monitor Menu Bar App for macOS
Shows CPU usage and RAM usage in the menu bar.

Requirements:
    pip install rumps psutil

To run:
    python menubar_monitor.py
"""

import rumps
import psutil


class SystemMonitorApp(rumps.App):
    def __init__(self):
        super(SystemMonitorApp, self).__init__(
            "System Monitor",
            icon=None,
            quit_button=None
        )
        
        # Menu items
        self.cpu_item = rumps.MenuItem("CPU: ---%")
        self.ram_item = rumps.MenuItem("RAM: ---%")
        self.separator = rumps.separator
        self.quit_item = rumps.MenuItem("Quit", callback=self.quit_app)
        
        self.menu = [
            self.cpu_item,
            self.ram_item,
            self.separator,
            self.quit_item
        ]
        
        # Timer for updates (every 2 seconds)
        self.timer = rumps.Timer(self.update_stats, 2)
        self.timer.start()
        
        # Initial update
        self.update_stats(None)
    
    def update_stats(self, _):
        """Update system statistics"""
        # CPU Usage
        cpu_percent = psutil.cpu_percent(interval=None)
        
        # RAM Usage
        memory = psutil.virtual_memory()
        ram_percent = memory.percent
        ram_used_gb = memory.used / (1024 ** 3)
        ram_total_gb = memory.total / (1024 ** 3)
        
        # Update menu bar title (clean text only)
        self.title = f"CPU {cpu_percent:.0f}% │ RAM {ram_percent:.0f}%"
        
        # Update menu items with detailed info
        self.cpu_item.title = f"CPU Usage: {cpu_percent:.1f}%"
        self.ram_item.title = f"RAM: {ram_used_gb:.1f}/{ram_total_gb:.1f} GB ({ram_percent:.1f}%)"
    
    def quit_app(self, _):
        """Quit the application"""
        rumps.quit_application()


if __name__ == "__main__":
    SystemMonitorApp().run()
