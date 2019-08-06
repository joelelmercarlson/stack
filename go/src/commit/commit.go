package main

import (
	"fmt"
	"log"
	"os/exec"
	"time"
)

func main() {
	git := "/usr/bin/git"
	now := time.Now()
	secs := now.Unix()
	seconds := fmt.Sprintf("%d", secs)

	Command([]string{git, "pull"})
	Command([]string{git, "add", "."})
	Command([]string{git, "commit", "-m", seconds})
	Command([]string{git, "push"})
}

func Command(xs []string) error {
	out, err := exec.Command(xs[0], xs[1:]...).Output()
	log.Printf("%s", xs)
	if err != nil {
		log.Printf("stdout: %s", out)
		log.Printf("stderr: %v", err)
	}
	return err
}
