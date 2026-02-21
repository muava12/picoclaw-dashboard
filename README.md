# 🦞 PicoClaw Dashboard

> Web dashboard for PicoClaw server management with real-time monitoring

A lightweight, single-binary Go application that provides a beautiful web interface for monitoring and managing your PicoClaw server. Designed for use with Tailscale VPN for secure, authentication-free access from any device.

## Features

- 📊 **Real-time Server Metrics**
  - CPU usage and cores
  - Memory usage
  - Disk space
  - Uptime

- 🔌 **WebSocket Updates**
  - Real-time data streaming
  - Auto-reconnect on connection loss
  - Fallback HTTP polling

- 📱 **Responsive Design**
  - Works on desktop and mobile
  - Clean, modern UI
  - Dark theme

- 🔒 **Tailscale Ready**
  - No authentication needed (VPN provides security)
  - No SSL required (encrypted by Tailscale)
  - Access from any device in your Tailnet

## Quick Start

### Build from source

```bash
git clone https://github.com/waplay/picoclaw-dashboard.git
cd picoclaw-dashboard
go build -o picoclaw-dashboard
```

### Run

```bash
./picoclaw-dashboard
```

The dashboard will be available at `http://localhost:8080`

### Run with Tailscale

1. Install and configure Tailscale on your server
2. Get your Tailscale IP:
   ```bash
   tailscale ip -4
   ```
3. Access the dashboard from any device in your Tailnet:
   ```
   http://<your-tailscale-ip>:8080
   ```

### Run as a service

Create a systemd service file at `/etc/systemd/system/picoclaw-dashboard.service`:

```ini
[Unit]
Description=PicoClaw Dashboard
After=network.target

[Service]
Type=simple
User=your-user
WorkingDirectory=/path/to/picoclaw-dashboard
ExecStart=/path/to/picoclaw-dashboard
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl enable picoclaw-dashboard
sudo systemctl start picoclaw-dashboard
```

## API Endpoints

### REST API

- `GET /api/health` - Get server health metrics

Response:
```json
{
  "cpu": {
    "usage_percent": 25.5,
    "cores": 4,
    "timestamp": "2026-02-21T10:15:00Z"
  },
  "memory": {
    "total_bytes": 8589934592,
    "used_bytes": 4294967296,
    "available_bytes": 4294967296,
    "used_percent": 50.0,
    "timestamp": "2026-02-21T10:15:00Z"
  },
  "disk": {
    "path": "/",
    "total_bytes": 500000000000,
    "used_bytes": 200000000000,
    "free_bytes": 300000000000,
    "used_percent": 40.0,
    "timestamp": "2026-02-21T10:15:00Z"
  },
  "uptime": {
    "uptime_seconds": 1296000,
    "boot_time": "2026-02-06T10:15:00Z",
    "timestamp": "2026-02-21T10:15:00Z"
  },
  "runtime": {
    "go_version": "go1.21.0",
    "os": "linux",
    "arch": "amd64"
  }
}
```

### WebSocket

- `WS /ws` - Real-time metric updates

Connects and receives JSON updates whenever `/api/health` is polled.

## Development

### Project Structure

```
.
├── main.go              # Entry point
├── api/
│   └── health.go        # Health API endpoint
├── websocket/
│   └── hub.go           # WebSocket hub for real-time updates
├── static/              # Embedded static files
│   ├── index.html
│   ├── style.css
│   └── app.js
├── go.mod
└── README.md
```

### Build for different platforms

```bash
# Linux AMD64
GOOS=linux GOARCH=amd64 go build -o picoclaw-dashboard-linux-amd64

# Linux ARM64 (Raspberry Pi)
GOOS=linux GOARCH=arm64 go build -o picoclaw-dashboard-linux-arm64

# macOS AMD64
GOOS=darwin GOARCH=amd64 go build -o picoclaw-dashboard-darwin-amd64

# macOS ARM64 (Apple Silicon)
GOOS=darwin GOARCH=arm64 go build -o picoclaw-dashboard-darwin-arm64

# Windows
GOOS=windows GOARCH=amd64 go build -o picoclaw-dashboard.exe
```

## Roadmap

### Phase 1: Basic Monitoring ✅
- [x] Server metrics (CPU, RAM, Disk, Uptime)
- [x] WebSocket real-time updates
- [x] Responsive UI
- [x] Tailscale support

### Phase 2: File Management
- [ ] File browser
- [ ] View file contents
- [ ] Edit files
- [ ] Create/delete files

### Phase 3: PicoClaw Management
- [ ] API for managing cron tasks
- [ ] Edit PicoClaw configuration
- [ ] Edit agent files (AGENTS.md, SOUL.md, etc.)
- [ ] View PicoClaw logs

### Phase 4: Advanced Features
- [ ] Log streaming
- [ ] Restart PicoClaw
- [ ] Alerts and notifications
- [ ] Mobile app (PWA/TWA)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) for details.

## About PicoClaw

[PicoClaw](https://github.com/sipeed/picoclaw) is an ultra-lightweight personal AI assistant written in Go.

---

Built with ❤️ for PicoClaw
