package main

import (
	"bytes"
	"crypto/sha1"
	"fmt"
	"io/ioutil"
	"netbsd.org/pkglint/line"
	"netbsd.org/pkglint/linechecks"
	"netbsd.org/pkglint/trace"
	"strings"
)

func ChecklinesDistinfo(lines []line.Line) {
	if trace.Tracing {
		defer trace.Call1(lines[0].Filename())()
	}

	fname := lines[0].Filename()
	patchesDir := "patches"
	patchesDirSet := false
	if G.Pkg != nil && contains(fname, "lang/php") {
		phpdir := G.globalData.Latest("lang", `^php[0-9]+$`, "/lang/$0")
		if hasSuffix(fname, phpdir+"/distinfo") {
			patchesDir = G.CurPkgsrcdir + phpdir + "/patches"
			patchesDirSet = true
		}
	}
	if G.Pkg != nil && !patchesDirSet && dirExists(G.CurrentDir+"/"+G.Pkg.Patchdir) {
		patchesDir = G.Pkg.Patchdir
	}
	if trace.Tracing {
		trace.Step1("patchesDir=%q", patchesDir)
	}

	ck := &distinfoLinesChecker{
		fname, patchesDir, isCommitted(fname),
		make(map[string]bool), nil, "", false, nil}
	ck.checkLines(lines)
	ChecklinesTrailingEmptyLines(lines)
	ck.checkUnrecordedPatches()
	SaveAutofixChanges(lines)
}

type distinfoLinesChecker struct {
	distinfoFilename    string
	patchdir            string // Relative to G.currentDir
	distinfoIsCommitted bool

	patches          map[string]bool // "patch-aa" => true
	currentFirstLine line.Line
	currentFilename  string
	isPatch          bool
	algorithms       []string
}

func (ck *distinfoLinesChecker) checkLines(lines []line.Line) {
	linechecks.CheckRcsid(lines[0], ``, "")
	if 1 < len(lines) && lines[1].Text() != "" {
		lines[1].Notef("Empty line expected.")
	}

	for i, line := range lines {
		if i < 2 {
			continue
		}
		m, alg, filename, hash := match3(line.Text(), `^(\w+) \((\w[^)]*)\) = (.*)(?: bytes)?$`)
		if !m {
			line.Errorf("Invalid line.")
			continue
		}

		if filename != ck.currentFilename {
			ck.onFilenameChange(line, filename)
		}
		ck.algorithms = append(ck.algorithms, alg)

		ck.checkGlobalMismatch(line, filename, alg, hash)
		ck.checkUncommittedPatch(line, filename, hash)
	}
	ck.onFilenameChange(NewLineEOF(ck.distinfoFilename), "")
}

func (ck *distinfoLinesChecker) onFilenameChange(line line.Line, nextFname string) {
	currentFname := ck.currentFilename
	if currentFname != "" {
		algorithms := strings.Join(ck.algorithms, ", ")
		if ck.isPatch {
			if algorithms != "SHA1" {
				line.Errorf("Expected SHA1 hash for %s, got %s.", currentFname, algorithms)
			}
		} else if hasPrefix(currentFname, "patch-") && algorithms == "SHA1" {
			ck.currentFirstLine.Warnf("Patch file %q does not exist in directory %q.", currentFname, cleanpath(ck.patchdir))
			Explain(
				"If the patches directory looks correct, the patch may have been",
				"removed without updating the distinfo file.  In such a case please",
				"update the distinfo file.",
				"",
				"If the patches directory looks wrong, pkglint needs to be improved.")
		} else if algorithms != "SHA1, RMD160, Size" && algorithms != "SHA1, RMD160, SHA512, Size" {
			line.Errorf("Expected SHA1, RMD160, SHA512, Size checksums for %q, got %s.", currentFname, algorithms)
		}
	}

	ck.isPatch = hasPrefix(nextFname, "patch-") && fileExists(G.CurrentDir+"/"+ck.patchdir+"/"+nextFname)
	ck.currentFilename = nextFname
	ck.currentFirstLine = line
	ck.algorithms = nil
}

func (ck *distinfoLinesChecker) checkPatchSha1(line line.Line, patchFname, distinfoSha1Hex string) {
	patchBytes, err := ioutil.ReadFile(G.CurrentDir + "/" + patchFname)
	if err != nil {
		line.Errorf("%s does not exist.", patchFname)
		return
	}

	h := sha1.New()
	netbsd := []byte("$" + "NetBSD")
	for _, patchLine := range bytes.SplitAfter(patchBytes, []byte("\n")) {
		if !bytes.Contains(patchLine, netbsd) {
			h.Write(patchLine)
		}
	}
	fileSha1Hex := fmt.Sprintf("%x", h.Sum(nil))
	if distinfoSha1Hex != fileSha1Hex {
		if !line.AutofixReplace(distinfoSha1Hex, fileSha1Hex) {
			line.Errorf("%s hash of %s differs (distinfo has %s, patch file has %s). Run \"%s makepatchsum\".", "SHA1", patchFname, distinfoSha1Hex, fileSha1Hex, confMake)
		}
	}
}

func (ck *distinfoLinesChecker) checkUnrecordedPatches() {
	files, err := ioutil.ReadDir(G.CurrentDir + "/" + ck.patchdir)
	if err != nil {
		if trace.Tracing {
			trace.Stepf("Cannot read patchesDir %q: %s", ck.patchdir, err)
		}
		return
	}

	for _, file := range files {
		patch := file.Name()
		if file.Mode().IsRegular() && !ck.patches[patch] && hasPrefix(patch, "patch-") {
			NewLineWhole(ck.distinfoFilename).Errorf("patch %q is not recorded. Run \"%s makepatchsum\".", ck.patchdir+"/"+patch, confMake)
		}
	}
}

// Inter-package check for differing distfile checksums.
func (ck *distinfoLinesChecker) checkGlobalMismatch(line line.Line, fname, alg, hash string) {
	if G.Hash != nil && !hasPrefix(fname, "patch-") { // Intentionally checking the filename instead of ck.isPatch
		key := alg + ":" + fname
		otherHash := G.Hash[key]
		if otherHash != nil {
			if otherHash.hash != hash {
				line.Errorf("The hash %s for %s is %s, which differs from %s in %s.",
					alg, fname, hash, otherHash.hash, otherHash.line.ReferenceFrom(line))
			}
		} else {
			G.Hash[key] = &Hash{hash, line}
		}
	}
}

func (ck *distinfoLinesChecker) checkUncommittedPatch(line line.Line, patchName, sha1Hash string) {
	if ck.isPatch {
		patchFname := ck.patchdir + "/" + patchName
		if ck.distinfoIsCommitted && !isCommitted(G.CurrentDir+"/"+patchFname) {
			line.Warnf("%s is registered in distinfo but not added to CVS.", patchFname)
		}
		ck.checkPatchSha1(line, patchFname, sha1Hash)
		ck.patches[patchName] = true
	}
}
