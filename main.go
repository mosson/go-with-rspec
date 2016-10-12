package main

import (
	"fmt"
	"net/http"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

// Product is test model.
type Product struct {
	gorm.Model
	Code  string
	Price uint
}

func main() {
	db, err := gorm.Open("sqlite3", "test.db")
	if err != nil {
		panic("failed to connect database")
	}
	defer db.Close()

	db.AutoMigrate(&Product{})

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		db.Create(&Product{Code: "L1212", Price: 1000})
		fmt.Fprintf(w, "Hello, World")
	})
	http.ListenAndServe(":8080", nil)
}
