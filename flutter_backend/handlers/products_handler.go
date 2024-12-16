package handlers

import (
	"encoding/json"
	"flutter_backend/models"
	"net/http"
)

// Заглушка с продуктами
var products []models.Product = []models.Product{
	{ID: 1, Name: "Кровавый меридиан", Price: 120, Description: "Роман Кормака Маккарти"},
}

// Получить все продукты
func GetProducts(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products)
}

// Добавить новый продукт
func CreateProduct(w http.ResponseWriter, r *http.Request) {
	var newProduct models.Product
	json.NewDecoder(r.Body).Decode(&newProduct)
	products = append(products, newProduct)
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(newProduct)
}
