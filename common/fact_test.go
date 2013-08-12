package common

import "testing"

func TestFact(t *testing.T) {

	if Fact(1) != 1 {
		t.Error("Fact(1) should be 1")
	}

	if Fact(4) != 24 {
		t.Error("Fact(4) should be 24")
	}
}

func BenchmarkFact(b *testing.B) {
	for i := 0; i < b.N; i++ {
		_ = Fact(i)
	}
}
