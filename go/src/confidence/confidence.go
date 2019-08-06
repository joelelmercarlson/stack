package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"
)

type Capability struct {
	name        string `json:"name"`
	description string `json:"description"`
	// support aggregation
	c_tally []float64 `json:"capexTally`
	o_tally []float64 `json:"opexTally"`
	n_tally []float64 `json:"novelTally"`
	s_tally []float64 `json:"seasonTally"`
	// support comment
	detail struct {
		desc   string `json:"desc"`
		metric string `json:"metric"`
	}
	// computed values
	cons []float64
}

func main() {
	dec := json.NewDecoder(os.Stdin)
	for {
		var m map[string]interface{}

		if err := dec.Decode(&m); err != nil {
			log.Println(err)
			return
		}
		c := FindCapability(m)
		Display(c)
		//log.Println(c)
	}
}

// adjust values to range
func Adjust(x float64) float64 {
	if mx := 0.999; x > mx {
		return mx
	} else if mn := 0.001; x < mn {
		return mn
	} else {
		return x
	}
}

// average
func Average(xs []float64) float64 {
	var total float64 = 0.0
	for _, v := range xs {
		total += v
	}
	return (total / (float64(len(xs))))
}

// average with adjustment
func AverageAdj(xs []float64) float64 {
	var total float64 = 0.0
	for _, v := range xs {
		total += Adjust(v)
	}
	return (total / (float64(len(xs))))
}

// display Row x Column
func Display(xs []Capability) {
	var str strings.Builder
	str.WriteString("| Capability | Description | AverageAdj | Notes | CONS |\n")
	str.WriteString("| ---------- | ----------- | ---------- | ----- | ---- |\n")
	for _, v := range xs {
		str.WriteString(DisplayCapability(v))
	}
	fmt.Println(str.String())
}

// display Row
func DisplayCapability(x Capability) string {
	a := AverageAdj(x.cons)
	return fmt.Sprintf("| %s | %s | %.4f | %s | [%.4f, %.4f, %.4f, %.4f] |\n", x.name, x.description, a, x.detail.desc, x.cons[0], x.cons[1], x.cons[2], x.cons[3])
}

// []Capability create
func FindCapability(m map[string]interface{}) []Capability {
	xs := make([]Capability, 0)
	for _, v := range m {
		// []list capability
		for _, u := range v.([]interface{}) {
			x := MakeCapability(u)
			xs = append(xs, x)
		}
	}
	return xs
}

// lookup string
func LookupMapString(m map[string]interface{}, key string) string {
	for k, v := range m {
		switch v.(type) {
		case string:
			if key == k {
				return v.(string)
			}
		}
	}
	return ""
}

// lookup float64
func LookupMapFloat(m map[string]interface{}, key string) float64 {
	for k, v := range m {
		switch v.(type) {
		case float64:
			if key == k {
				return v.(float64)
			}
		}
	}
	return 0.0
}

// lookup []float64
func LookupMapFloatXS(m map[string]interface{}, key string) []float64 {
	xs := make([]float64, 0)
	for k, v := range m {
		switch vv := v.(type) {
		case []interface{}:
			if key == k {
				for _, u := range vv {
					xs = append(xs, u.(float64))
				}
				return xs
			}
		}
	}
	return xs
}

// Capability create
func MakeCapability(u interface{}) Capability {
	var x Capability
	uu, ok := u.(map[string]interface{})
	if ok {
		x.name = LookupMapString(uu, "name")
		x.description = LookupMapString(uu, "description")

		// aggregate tallies
		x.c_tally = LookupMapFloatXS(uu, "capexTally")
		x.o_tally = LookupMapFloatXS(uu, "opexTally")
		x.n_tally = LookupMapFloatXS(uu, "novelTally")
		x.s_tally = LookupMapFloatXS(uu, "seasonTally")

		// detail
		uu, ok := uu["detail"].(map[string]interface{})
		if ok {
			x.detail.metric = LookupMapString(uu, "metric")
			x.detail.desc = LookupMapString(uu, "desc")
		}

		// compute values
		c := MakeTally(x.c_tally)
		o := MakeTally(x.o_tally)
		n := MakeTally(x.n_tally)
		s := MakeTally(x.s_tally)

		x.cons = MakeCONS(c, o, n, s)
	}
	return x
}

func MakeCONS(c float64, o float64, n float64, s float64) []float64 {
	xs := make([]float64, 0)
	xs = append(xs, c, o, n, s)
	return xs
}

// average Tally numbers
func MakeTally(xs []float64) float64 {
	if avg := Average(xs); avg > 0 {
		return avg
	}
	return 0.0
}

// example work with interface{}
func DebugMap(m map[string]interface{}) {
	for k, v := range m {
		switch vv := v.(type) {
		case string:
			fmt.Println(k, "is string", vv)
		case float64:
			fmt.Println(k, "is float64", vv)
		case []interface{}:
			fmt.Println(k, "is an array:")
			for i, u := range vv {
				fmt.Println(i, u)
			}
		default:
			fmt.Println(k, "is a another type")
		}
	}
}
