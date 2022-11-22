package main

import "fmt"

func main() {
	s := "abc"

	ps := &s

	fmt.Println(&s, s)
	fmt.Println(ps, *ps)

	s += "def"

	fmt.Println(&s, s)
	fmt.Println(ps, *ps)
}