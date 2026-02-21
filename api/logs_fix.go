package api

import (
	"fmt"
	"net/http"
)

// SetupLogRoutes регистрирует роуты для API логов с debug
func SetupLogRoutes() {
	if logHandler == nil {
		fmt.Println("⚠️  Log handler not initialized, call InitLogsService first")
		return
	}

	// Регистрируем маршруты
	mux := http.DefaultServeMux

	// Проверяем, что маршруты не перекрываются
	mux.HandleFunc("GET /api/logs", func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("📝 /api/logs called: %s %s\n", r.Method, r.URL.Path)
		logHandler.getLogs(w, r)
	})

	mux.HandleFunc("GET /api/logs/units", func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("📝 /api/logs/units called: %s %s\n", r.Method, r.URL.Path)
		logHandler.getUnits(w, r)
	})

	mux.HandleFunc("GET /api/logs/stream", func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("📝 /api/logs/stream called: %s %s\n", r.Method, r.URL.Path)
		logHandler.streamLogs(w, r)
	})

	fmt.Println("✅ Log routes registered: /api/logs, /api/logs/units, /api/logs/stream")
}
