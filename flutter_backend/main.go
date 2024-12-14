package main

import (
	"fmt"
	"net/http"
	"os"
)

// Структура для ответа
type Product struct {
	Title    string `json:"title"`
	Data     string `json:"data"`
	ImageURL string `json:"image_url"`
	Price    int    `json:"price"`
}

// Обработчик для отправки JSON-файла
func getProductsHandler(w http.ResponseWriter, r *http.Request) {
	// Заголовки CORS, разрешающие запросы от клиента
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	// Если это preflight-запрос, сразу отправляем успешный ответ
	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	// Читаем JSON-файл с диска
	file, err := os.ReadFile("products.json")
	if err != nil {
		http.Error(w, "Unable to read file", http.StatusInternalServerError)
		return
	}

	// Устанавливаем заголовки для JSON-ответа
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	// Отправляем файл в теле ответа
	w.Write(file)
}

func main() {
	// Привязываем маршрут к обработчику
	http.HandleFunc("/products", getProductsHandler)

	// Запускаем сервер на порту 8080
	fmt.Println("Server is running at http://localhost:8080")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println("Error starting server:", err)
	}
}
