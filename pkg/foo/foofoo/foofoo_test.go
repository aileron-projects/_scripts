package foofoo

import (
	"testing"
)

func TestSub(t *testing.T) {
	t.Parallel()
	if Sub(1, 2) != -1 {
		t.Error("fail")
	}
}

func TestReadFile(t *testing.T) {
	t.Parallel()
	s, err := ReadFile("testdata/data.txt")
	if err != nil {
		t.Error(err)
	}
	if s != "foofoo" {
		t.Error("fail")
	}
}
