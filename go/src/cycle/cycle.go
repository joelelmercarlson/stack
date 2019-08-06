package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"
)

type Owner struct {
	name     string    `json:"name"`
	avgTally []float64 `json:"averageTally"`
	// scores:  Sanitized avgTally based on sliding window
	//          benchmark=3, trend=8, requires 11 points
	// adjust: how many points adjusted to trend
	// amt: Average(window) * 0.80
	// cycle: % +/- (benchmark - trend) / benchmark
	// benchmark: first 3 points
	// trend: next 8 points
	// epoch: k = month, v = value
	fill      []float64
	scores    []float64
	adjust    int
	amt       float64
	cycle     float64
	benchmark float64
	trend     float64
	epoch     map[string]float64
}

// go lacks tuples
type Pair struct {
	a, b interface{}
}

func main() {
	var argv string
	if len(os.Args) > 1 {
		argv = os.Args[1]
	}

	dec := json.NewDecoder(os.Stdin)
	for {
		var m map[string]interface{}
		if err := dec.Decode(&m); err != nil {
			log.Println(err)
			return
		}

		c := FindOwner(m)

		switch argv {
		case "debug":
			Debug(c)
		case "adjust":
			Adjust(c)
		default:
			Display(c)

		}
	}
}

// Adjust -- display adjusted months
func Adjust(xs []Owner) {
	for k, v := range xs {
		months := make([]string, 0)
		for uu, vv := range v.epoch {
			if vv == v.amt {
				months = append(months, uu)
			}
		}
		fmt.Printf("[%d] owner:%s months:%v\n", k, v.name, months)
	}
}

// Average -- average
func Average(xs []float64) float64 {
	var total float64 = 0.0
	for _, v := range xs {
		total += v
	}
	return (total / (float64(len(xs))))
}

// AverageXS -- average by slice[u:v]
func AverageXS(xs []float64, u int, v int) float64 {
	if v > len(xs) {
		v = len(xs)
	}
	ys := xs[u:v]
	x := Average(ys)
	return x
}

// BenchmarkTrend - Provide averages for bench, trend
func BenchmarkTrend(xs []float64) Pair {
	bench := AverageXS(xs, 0, 2)
	trend := AverageXS(xs, 3, len(xs))
	return Pair{bench, trend}
}

// Debug -- display []Owner
func Debug(xs []Owner) {
	for k, v := range xs {
		fmt.Printf("[%d] owner:%s avgTally:%v fill:%v scores:%v adjust:%d amt:%.2f cycle:%.2f benchmark:%.2f trend:%.2f epoch:%v\n", k, v.name, v.avgTally, v.fill, v.scores, v.adjust, v.amt, v.cycle, v.benchmark, v.trend, v.epoch)
	}
}

// Display -- Row x Column
func Display(xs []Owner) {
	var str strings.Builder
	str.WriteString("| Owner           | Cycle%   | Bench    | Trend    | Adjust | 80%Amt |\n")
	str.WriteString("| --------------- | -------- | -------- | -------- | ------ | ------ |\n")
	for _, v := range xs {
		str.WriteString(DisplayOwner(v))
	}
	fmt.Println(str.String())
}

// Display -- Row
func DisplayOwner(x Owner) string {
	return fmt.Sprintf("| %-15s | %-8.2f | %-8.2f | %-8.2f | %-6d | %-6.2f |\n", x.name, x.cycle, x.benchmark, x.trend, x.adjust, x.amt)
}

// Fill - fill []slice
// data is curated from rally report
// If no data for the epoch (Dec 2017), 15.0 is assigned.
// If team member joins mid year, 15.0 is assigned each month.
func Fill(xs []float64, v int) []float64 {
	ys := make([]float64, 0)
	l := len(xs)
	if l < v {
		i := 0
		for i < (v - l) {
			ys = append(ys, 15.0)
			i = i + 1
		}
	}
	i := 0
	for i < l {
		ys = append(ys, xs[i])
		i = i + 1

	}
	return ys
}

// FindOwner -- []Owner create
func FindOwner(m map[string]interface{}) []Owner {
	xs := make([]Owner, 0)
	for _, v := range m {
		// []list Owner
		for _, u := range v.([]interface{}) {
			x := MakeOwner(u)
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

// MakeCycle -- %cycle time improvement
func MakeCycle(u float64, v float64) float64 {
	if u < 0.0 {
		u = 1.0
	}
	return 100.0 * (u - v) / u
}

// MakeEpoch -- Set Month names to values
func MakeEpoch(xs []float64) map[string]float64 {
	epoch := map[int]string{0: "eoy", 1: "jan", 2: "feb", 3: "mar", 4: "apr", 5: "may", 6: "jun", 7: "jul", 8: "aug", 9: "sep", 10: "oct", 11: "nov", 12: "dec"}
	m := make(map[string]float64)
	for k, v := range xs {
		if k > 12 {
			k = k - 12
		}
		m[epoch[k]] = v
	}
	return m
}

// MakeOwner -- Read data from our json
func MakeOwner(u interface{}) Owner {
	var x Owner
	uu, ok := u.(map[string]interface{})
	if ok {
		x.name = LookupMapString(uu, "name")
		x.avgTally = LookupMapFloatXS(uu, "averageTally")
	}

	// 1st: compute fill, amt
	p0 := WindowFillAverage(x.avgTally, 11)
	x.fill = p0.a.([]float64)
	x.amt = p0.b.(float64)

	// 2nd: scores, adjust
	p1 := Sanitize(x.fill, x.amt)
	x.scores = p1.a.([]float64)
	x.adjust = p1.b.(int)

	// 3rd: compute benchmark, trend
	p2 := BenchmarkTrend(x.scores)
	x.benchmark = p2.a.(float64)
	x.trend = p2.b.(float64)

	// Finally, %cycle and epoch
	x.cycle = MakeCycle(x.benchmark, x.trend)
	x.epoch = MakeEpoch(x.scores)

	return x
}

// Sanitize for working with raw averages
// do not trust < u
// do not trust > 2*u
// return adjustments
func Sanitize(xs []float64, u float64) Pair {
	ys := make([]float64, 0)
	adjust := 0
	for _, v := range xs {
		// less than trend
		if v < u {
			v = u
			adjust += 1
		}
		// 2x trend
		if v > 2*u {
			v = u
			adjust += 1
		}
		ys = append(ys, v)
	}
	return Pair{ys, adjust}
}

// Window -- creates slices
func Window(xs []float64, u int) []float64 {
	ys := make([]float64, 0)
	l := len(xs)
	if u > l {
		u = l
	}
	v := l - u
	if v < 0 {
		v = 0
	}
	for _, k := range xs[v:] {
		ys = append(ys, k)
	}
	return ys
}

// WindowFillAverage -- Fill Window and Average
func WindowFillAverage(xs []float64, u int) Pair {
	ys := WindowFill(xs, u)
	avg := Average(ys) * 0.80
	return Pair{ys, avg}
}

// WindowFill -- Fill Window
func WindowFill(xs []float64, u int) []float64 {
	ys := Fill(Window(xs, u), u)
	return ys
}
