package main

import "fmt"

func printhello(x int) (int) {
	count := 0
	for i := 0 ; i < x ; i++ {
		if i%2 == 0 {
			count++
			fmt.Println(i, "Hello Wolrld count: ", count)
		}
	}
	return count;
}

func main() {
	fmt.Println(printhello(5))
}