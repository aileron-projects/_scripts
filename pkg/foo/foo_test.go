package foo

import (
	"testing"
)

func TestAdd(t *testing.T) {
	t.Parallel()
	if Add(1, 2) != 3 {
		t.Error("fail")
	}
}

func TestReadFile(t *testing.T) {
	t.Parallel()
	s, err := ReadFile("testdata/data.txt")
	if err != nil {
		t.Error(err)
	}
	if s != "foo" {
		t.Error("fail")
	}
}
