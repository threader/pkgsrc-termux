package main

import (
	"io/ioutil"
	"netbsd.org/pkglint/line"
	"os"
	"strings"
)

func LoadNonemptyLines(fname string, joinBackslashLines bool) []line.Line {
	lines, err := readLines(fname, joinBackslashLines)
	if err != nil {
		NewLineWhole(fname).Errorf("Cannot be read.")
		return nil
	}
	if len(lines) == 0 {
		NewLineWhole(fname).Errorf("Must not be empty.")
		return nil
	}
	return lines
}

func LoadExistingLines(fname string, joinBackslashLines bool) []line.Line {
	lines, err := readLines(fname, joinBackslashLines)
	if err != nil {
		NewLineWhole(fname).Fatalf("Cannot be read.")
	}
	if lines == nil {
		NewLineWhole(fname).Fatalf("Must not be empty.")
	}
	return lines
}

func getLogicalLine(fname string, rawLines []*RawLine, pindex *int) line.Line {
	{ // Handle the common case efficiently
		index := *pindex
		rawLine := rawLines[index]
		textnl := rawLine.textnl
		if hasSuffix(textnl, "\n") && !hasSuffix(textnl, "\\\n") {
			*pindex = index + 1
			return NewLine(fname, rawLine.Lineno, textnl[:len(textnl)-1], rawLines[index:index+1])
		}
	}

	text := ""
	index := *pindex
	firstlineno := rawLines[index].Lineno
	var lineRawLines []*RawLine
	interestingRawLines := rawLines[index:]

	for i, rawLine := range interestingRawLines {
		indent, rawText, outdent, cont := splitRawLine(rawLine.textnl)

		if text == "" {
			text += indent
		}
		text += rawText
		lineRawLines = append(lineRawLines, rawLine)

		if cont != "" && i != len(interestingRawLines)-1 {
			text += " "
			index++
		} else {
			text += outdent + cont
			break
		}
	}

	lastlineno := rawLines[index].Lineno
	*pindex = index + 1

	return NewLineMulti(fname, firstlineno, lastlineno, text, lineRawLines)
}

func splitRawLine(textnl string) (leadingWhitespace, text, trailingWhitespace, cont string) {
	i, m := 0, len(textnl)

	if m > i && textnl[m-1] == '\n' {
		m--
	}

	if m > i && textnl[m-1] == '\\' {
		m--
		cont = textnl[m : m+1]
	}

	trailingEnd := m
	for m > i && (textnl[m-1] == ' ' || textnl[m-1] == '\t') {
		m--
	}
	trailingStart := m
	trailingWhitespace = textnl[trailingStart:trailingEnd]

	leadingStart := i
	for i < m && (textnl[i] == ' ' || textnl[i] == '\t') {
		i++
	}
	leadingEnd := i
	leadingWhitespace = textnl[leadingStart:leadingEnd]

	text = textnl[leadingEnd:trailingStart]
	return
}

func readLines(fname string, joinBackslashLines bool) ([]line.Line, error) {
	rawText, err := ioutil.ReadFile(fname)
	if err != nil {
		return nil, err
	}

	return convertToLogicalLines(fname, string(rawText), joinBackslashLines), nil
}

func convertToLogicalLines(fname string, rawText string, joinBackslashLines bool) []line.Line {
	var rawLines []*RawLine
	for lineno, rawLine := range strings.SplitAfter(rawText, "\n") {
		if rawLine != "" {
			rawLines = append(rawLines, &RawLine{1 + lineno, rawLine, rawLine})
		}
	}

	var loglines []line.Line
	if joinBackslashLines {
		for lineno := 0; lineno < len(rawLines); {
			loglines = append(loglines, getLogicalLine(fname, rawLines, &lineno))
		}
	} else {
		for _, rawLine := range rawLines {
			text := strings.TrimSuffix(rawLine.textnl, "\n")
			logline := NewLine(fname, rawLine.Lineno, text, []*RawLine{rawLine})
			loglines = append(loglines, logline)
		}
	}

	if 0 < len(rawLines) && !hasSuffix(rawLines[len(rawLines)-1].textnl, "\n") {
		NewLineEOF(fname).Errorf("File must end with a newline.")
	}

	return loglines
}

func SaveAutofixChanges(lines []line.Line) (autofixed bool) {
	if !G.opts.Autofix {
		for _, line := range lines {
			if line.IsChanged() {
				G.autofixAvailable = true
			}
		}
		return
	}

	changes := make(map[string][]string)
	changed := make(map[string]bool)
	for _, line := range lines {
		if line.IsChanged() {
			changed[line.Filename()] = true
		}
		changes[line.Filename()] = append(changes[line.Filename()], line.(*LineImpl).modifiedLines()...)
	}

	for fname := range changed {
		changedLines := changes[fname]
		tmpname := fname + ".pkglint.tmp"
		text := ""
		for _, changedLine := range changedLines {
			text += changedLine
		}
		err := ioutil.WriteFile(tmpname, []byte(text), 0666)
		if err != nil {
			NewLineWhole(tmpname).Errorf("Cannot write.")
			continue
		}
		err = os.Rename(tmpname, fname)
		if err != nil {
			NewLineWhole(fname).Errorf("Cannot overwrite with auto-fixed content.")
			continue
		}
		msg := "Has been auto-fixed. Please re-run pkglint."
		logs(llAutofix, fname, "", msg, msg)
		autofixed = true
	}
	return
}
