package main

import "testing"

func TestOOO(t *testing.T) {
	x := OOO("test")
	y := "PTO"

	if x != y {
		t.Errorf("OOO was incorrect, got: %s, want: %s", x, y)
	}

}
