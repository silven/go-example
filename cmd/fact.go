package main

import (
	"fmt"
	"github.com/silven/go-example/common"
)

func main() {
	a := common.Fact(5)
	fmt.Printf("Fact(5) is %v\n", a)
}
