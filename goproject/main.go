package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

func handler(w http.ResponseWriter, r *http.Request) {
	env := strings.Join(os.Environ(), "\n")
	name, _ := os.Hostname()
	fmt.Fprintf(w, "Host: %s\nPath: %s\n\n%s", name, r.URL.Path[1:], env)
}

func main() {
	port := "8080"
	if len(os.Args) > 1 {
		port = os.Args[1]
	}
	log.Printf("Starting web server on port %s", port)
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
