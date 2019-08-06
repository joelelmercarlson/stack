package main

import "testing"

func TestCommand(t *testing.T) {
	x := Command([]string{"echo", "foo", "bar"})
	if x != nil {
		t.Errorf("Command was incorrect, got: %v, want: %v", x, nil)
	}
}
