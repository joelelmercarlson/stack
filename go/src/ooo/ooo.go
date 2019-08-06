package main

import "fmt"

func main() {
	x := needHelp()
	y := OOO(x)

	fmt.Println(y)
}

func OOO(x string) string {
	str := ("Joel E Carlson is on PTO. For Assistance:")
	switch x {
	case "team":
		str += "\n -> mailto:joel.elmer.carlson@gmail.com"
		str += "\nPlanned Return: September 4th, 2019"
		str += clear("\n")
		str += black("Haskell")
		str += clear("\n")
	case "test":
		str = "PTO"
	default:
	}
	return str
}

func needHelp() string {
	return "team"
}

func black(x string) string {
	return "\x1b[30;1m" + x
}

func red(x string) string {
	return "\x1b[31;1m" + x
}

func green(x string) string {
	return "\x1b[32;1m" + x
}

func yellow(x string) string {
	return "\x1b[33;1m" + x
}

func blue(x string) string {
	return "\x1b[34;1m" + x
}

func magenta(x string) string {
	return "\x1b[35;1m" + x
}

func cyan(x string) string {
	return "\x1b[36;1m" + x
}

func white(x string) string {
	return "\x1b[37;1m" + x
}

func clear(x string) string {
	return "\x1b[0m" + x
}
