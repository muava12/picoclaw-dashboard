package main

import (
	"embed"
	"fmt"
	"log"
	"net/http"
	"runtime"
	"time"

	"github.com/waplay/picoclaw-dashboard/api"
	"github.com/waplay/picoclaw-dashboard/websocket"
)

//go:embed static/*
var staticFiles embed.FS

func main() {
	// Setup WebSocket hub
	hub := websocket.NewHub()
	go hub.Run()

	// Setup API routes
	api.SetupRoutes(hub)

	// Serve static files (embedded)
	http.Handle("/", http.FileServer(http.FS(staticFiles)))

	// Get Tailscale IP or use default
	port := "8080"
	addr := fmt.Sprintf(":%s", port)

	log.Printf("🚀 PicoClaw Dashboard starting...")
	log.Printf("📊 Server metrics: %s/api/health", addr)
	log.Printf("🔌 WebSocket: %s/ws", addr)
	log.Printf("💻 Runtime: %s/%s", runtime.GOOS, runtime.GOARCH)
	log.Printf("🌐 Tailscale enabled - connecting from VPN")

	server := &http.Server{
		Addr:         addr,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	if err := server.ListenAndServe(); err != nil {
		log.Fatal("Server error:", err)
	}
}
