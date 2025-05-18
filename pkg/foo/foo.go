package foo

import (
	"os"
)

// Add returns x + y.
func Add(x, y int) int {
	return x + y
}

// ReadFile returns the content of given file.
func ReadFile(path string) (string, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	return string(b), nil
}
