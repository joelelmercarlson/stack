package main

import (
	"bytes"
	"encoding/json"
	"io"
	"io/ioutil"
	"os"
	"testing"
)

func TestAdjustMax(t *testing.T) {
	x := Adjust(1.0)
	val := 0.999
	if x != val {
		t.Errorf("adjust was incorrect, got: %f, want: %f", x, val)
	}
}

func TestAdjustMin(t *testing.T) {
	x := Adjust(0.0)
	val := 0.001
	if x != val {
		t.Errorf("adjust was incorrect, got: %f, want: %f", x, val)
	}
}

func TestAverage(t *testing.T) {
	xs := []float64{1.0, 0.75, 0.50, 0.25}
	x := Average(xs)
	val := 0.625
	if x != val {
		t.Errorf("Average was incorrect, got: %f, want: %f", x, val)
	}
}

func TestAverageAdj(t *testing.T) {
	xs := []float64{1.0, 0.75, 0.50, 0.25}
	x := AverageAdj(xs)
	val := 0.62475
	if x != val {
		t.Errorf("AverageAdj was incorrect, got: %f, want: %f", x, val)
	}
}

// TBD test []Capability
func TestFindCapability(t *testing.T) {
	if err := os.Chdir(os.Getenv("GOPATH")); err != nil {
		t.Errorf("FindCapability was incorrect, got: %v", err)
	}

	content, err := ioutil.ReadFile("data/test_capability.json")
	if err != nil {
		t.Errorf("FindCapability was incorrect, got: %v", err)
	}

	dec := json.NewDecoder(bytes.NewReader(content))
	for {
		var m map[string]interface{}
		if err := dec.Decode(&m); err == io.EOF {
			break
		} else if err != nil {
			t.Errorf("FindCapability was incorrect, got: %v ", err)
			return
		}
		c := FindCapability(m)
		Display(c)
	}
}

func TestMakeTally(t *testing.T) {
	xs := []float64{1.0, 0.0, 0.0, 1.0}
	x := MakeTally(xs)
	val := 0.5
	if x != val {
		t.Errorf("MakeTally was incorrect, got: %f, want: %f", x, val)
	}
}

func TestMakeTallyEmpty(t *testing.T) {
	xs := make([]float64, 0)
	x := MakeTally(xs)
	val := 0.0
	if x != val {
		t.Errorf("MakeTally was incorrect, got: %f, want: %f", x, val)
	}
}
