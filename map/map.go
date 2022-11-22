package main

import "fmt"

func main() {
	myMap := map[string]string{
		"A" : "Alice",
		"B" : "Bob",
		"C" : "Carlie",
	}

	for key, val := range myMap {
		fmt.Println(key, val)
	}
}