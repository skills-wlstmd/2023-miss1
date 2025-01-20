package main

import (
	"fmt"
	"net/http"
)

func api(w http.ResponseWriter, req *http.Request) {
	fmt.Fprint(w, "DOWN")
}

func health(w http.ResponseWriter, req *http.Request) {
    fmt.Fprint(w, "OK")
}

func main() {
    http.HandleFunc("/health", health)
		http.HandleFunc("/api", api)
    http.ListenAndServe(":8080", nil)
}