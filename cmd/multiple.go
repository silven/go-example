package main

import (
	"fmt"
	"github.com/silven/go-example/common"
)

func main() {

	for i := 0; i < 10; i++ {
		a := common.Fact(i)
		fmt.Printf("Fact(%v) is %v\n", i, a)
	}
}
