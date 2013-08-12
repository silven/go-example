package common

import "github.com/silven/go-example/common/sub"

func Fact(a int) int {
	if a <= 1 {
		return 1
	}
	return sub.Mult(a, Fact(a-1))
}
