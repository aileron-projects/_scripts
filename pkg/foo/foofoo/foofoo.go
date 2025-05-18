package foofoo

import "os"

// Sub returns x - y.
func Sub(x, y int) int {
	return x - y
}

// ReadFile returns the content of given file.
func ReadFile(path string) (string, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	return string(b), nil
}
