package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"

	_ "github.com/lib/pq"
)

const (
	dbUser     = "postgres"
	dbPassword = "1234"
	dbName     = "pks"
	dbHost     = "localhost"
	dbPort     = 5432
)

type Product struct {
	Title    string  `json:"title"`
	Data     string  `json:"data"`
	ImageURL string  `json:"image_url"`
	Price    float64 `json:"price"` // Меняем на float64
}

type ProductList struct {
	Pets []Product `json:"pets"`
}

var db *sql.DB

func connectToDatabase() error {
	var err error
	connStr := fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable", dbUser, dbPassword, dbHost, dbPort, dbName)
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		return fmt.Errorf("failed to connect to database: %v", err)
	}
	return nil
}

func getProductsHandler(w http.ResponseWriter, r *http.Request) {
	setCORSHeaders(w, r)

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	if r.Method == http.MethodGet {
		rows, err := db.Query("SELECT title, data, image_url, price FROM products")
		if err != nil {
			http.Error(w, fmt.Sprintf("Error fetching products: %v", err), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var products []Product
		for rows.Next() {
			var product Product
			if err := rows.Scan(&product.Title, &product.Data, &product.ImageURL, &product.Price); err != nil {
				http.Error(w, fmt.Sprintf("Error scanning product: %v", err), http.StatusInternalServerError)
				return
			}
			products = append(products, product)
		}

		if err := rows.Err(); err != nil {
			http.Error(w, fmt.Sprintf("Row iteration error: %v", err), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(ProductList{Pets: products})
	} else {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
	}
}

func addProductHandler(w http.ResponseWriter, r *http.Request) {
	setCORSHeaders(w, r)

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	if r.Method == http.MethodPost {
		var newProduct Product
		if err := json.NewDecoder(r.Body).Decode(&newProduct); err != nil {
			http.Error(w, "Invalid JSON format", http.StatusBadRequest)
			return
		}

		query := "INSERT INTO products (title, data, image_url, price) VALUES ($1, $2, $3, $4)"
		_, err := db.Exec(query, newProduct.Title, newProduct.Data, newProduct.ImageURL, newProduct.Price)
		if err != nil {
			http.Error(w, fmt.Sprintf("Error inserting product: %v", err), http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusCreated)
		w.Write([]byte(`{"message": "Product added successfully"}`))
	} else {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
	}
}

func setCORSHeaders(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
}

func main() {
	if err := connectToDatabase(); err != nil {
		fmt.Println("Error connecting to database:", err)
		return
	}
	defer db.Close()

	http.HandleFunc("/products", getProductsHandler)
	http.HandleFunc("/add-product", addProductHandler)

	fmt.Println("Server is running at http://localhost:8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Println("Error starting server:", err)
	}
}
