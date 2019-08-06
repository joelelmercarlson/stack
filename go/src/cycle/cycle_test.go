package main

import (
	"bytes"
	"encoding/json"
	"io"
	"io/ioutil"
	"os"
	"testing"
)

func TestFill(t *testing.T) {
	x := Fill([]float64{0.0}, 2)
	if x[0] != 15.0 {
		t.Errorf("TestFill was incorrect, got: %f, want: %f", x, 15.0)
	}

}

// TBD test []Owner
func TestFindOwner(t *testing.T) {
	if err := os.Chdir(os.Getenv("GOPATH")); err != nil {
		t.Errorf("FindOwner was incorrect, got: %v", err)
	}

	content, err := ioutil.ReadFile("data/test_cycle.json")
	if err != nil {
		t.Errorf("FindOwner was incorrect, got: %v", err)
	}

	dec := json.NewDecoder(bytes.NewReader(content))
	for {
		var m map[string]interface{}
		if err := dec.Decode(&m); err == io.EOF {
			break
		} else if err != nil {
			t.Errorf("FindOwner was incorrect, got: %v ", err)
			return
		}
		c := FindOwner(m)
		Display(c)
	}
}

func TestMakeCycle(t *testing.T) {
	x := MakeCycle(1.0, 1.0)
	val := 0.0
	if x != val {
		t.Errorf("MakeCycle was incorrect, got: %f, want: %f", x, val)
	}
}

func TestSanitize(t *testing.T) {
	xs := Sanitize([]float64{1.0}, 2.0)
	val := 2.0
	if xs.a.([]float64)[0] != val {
		t.Errorf("Sanitize was incorrect, got: %v, want: %v", xs.a.([]float64), val)
	}
}

func TestWindow(t *testing.T) {
	xs := Window([]float64{1.0, 1.0, 1.0, 1.0}, 2)
	val := 2
	if len(xs) > val {
		t.Errorf("Window was incorrect, got: %v, want: %v", xs, val)
	}
}
