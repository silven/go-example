package sub

import "testing"

func TestMult(t *testing.T) {
	a, b := 5, 5

	if Mult(a, b) != 25 {
		t.Error("numbers not multiplied correctly")
	}
}

func TestNegMult(t *testing.T) {
	a, b := -5, 5

	if Mult(a, b) != -25 {
		t.Error("negative numbers not multiplied correctly")
	}
}
