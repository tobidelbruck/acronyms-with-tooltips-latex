# acronyms-with-tooltips-latex

Adds tooltip popups for LaTeX PDF projects so readers have an easier time understanding your acronyms.

See the example Overleaf project: https://www.overleaf.com/read/fyvbnxpwwjss#6de35b

<img width="682" height="361" alt="tooltip-example" src="https://github.com/user-attachments/assets/f6833abb-d5f2-44f3-8739-b54e1cbd18bb" />

## How it works

Uses the [glossaries](https://ctan.org/pkg/glossaries) package and [pdfcomment](https://ctan.org/pkg/pdfcomment), with a patch that emits **both** annotation types on each tooltip:

- `/Subtype /Square` with `/Contents` (SumatraPDF/muPDF-friendly)
- Original `/Subtype /Widget` `/Btn` with `/TU` (Acrobat-friendly)

They share the same rectangle and overlap; viewers pick what they support.

## Overleaf upload checklist

Upload these files to your Overleaf project (no shell escape needed):

| File | Purpose |
|------|---------|
| `acronymtooltips.sty` | Main package (`\xx`, `\xxx`, glossaries setup) |
| `acronymtooltips-pdfcomment.tex` | pdfcomment patch (loaded by the `.sty`) |
| `myacronyms.tex` | Your `\newacronym{...}` definitions only |

Optional for a standalone example: upload `main.tex` as your project root.

Dependencies (`glossaries`, `pdfcomment`, `xcolor`) are already on Overleaf.

## Standalone example

Use `main.tex` in this repo as a template:

```latex
\documentclass[12pt]{article}
\usepackage{acronymtooltips}
\input{myacronyms}

\begin{document}
Testing \xx{of} algorithms is hard because \xx{of} requires good \xx{gt} data.
\end{document}
```

Compile with pdfLaTeX (twice if references change).

## Integrate into an existing Overleaf paper

Copy the contents of `integration-snippet.tex` into your preamble (after `\documentclass`, before `\begin{document}`):

```latex
\usepackage{acronymtooltips}
\input{myacronyms}
```

Replace `\gls{key}` or manual acronyms with `\xx{key}` (singular) and `\xxx{key}` (plural). First use expands the full definition with bold/colored short form; later uses show the short form with a PDF tooltip on hover.

Customize colors in `acronymtooltips.sty` or redefine `\accolor` and `\acfirstformat` after `\usepackage{acronymtooltips}`.

## Commands

| Command | Meaning |
|---------|---------|
| `\xx{key}` | Singular acronym; tooltip on subsequent uses |
| `\xxx{key}` | Plural acronym; tooltip on subsequent uses |
| `\newacronym{key}{SHORT}{Long form}` | Define in `myacronyms.tex` |
| `\newacronym[description={...}]{key}{SHORT}{Long}` | Optional longer tooltip text |

## PDF viewer compatibility

| Viewer | Tooltips on hover | Notes |
|--------|-------------------|-------|
| Adobe Acrobat / Reader | Yes | Reference behavior |
| SumatraPDF (muPDF) | Yes | Needs Square patch (default pdfcomment `/Btn` does not work) |
| muPDF | Same as SumatraPDF | |
| Cursor / VS Code PDF preview (PDF.js) | Partial | Yellow popup with split layout; text usually visible |
| Overleaf built-in preview (PDF.js) | Yes | Hover tooltip works |
| Firefox PDF viewer (PDF.js) | Variable | PDF.js-based |
| Google Chrome built-in PDF viewer (PDF.js) | No | No tooltip on hover; toggling annotations does not help |
| Okular | Yes | Enable “show annotations”; tooltip on hover |
| Evince | Yes | Tooltip on hover |

The PDF spec does not strictly define tooltip behavior; viewers differ. Dual annotations cover both common mechanisms (`/Square` `/Contents` vs `/Btn` `/TU`); viewers use whichever they support.

On Linux, Evince and Okular work for hover tooltips with this dual-annotation PDF (Okular requires annotations visible). Overleaf preview works. Chrome’s built-in viewer does not.

## Sync to Overleaf (Dropbox)

If this repo is synced separately from your Overleaf Dropbox folder, copy builds into the synced test project:

```bash
./sync-to-overleaf.sh
```

Default target: `/home/tobi/Dropbox/Apps/Overleaf/acronyms_with_tooltip_test`. Override with:

```bash
OVERLEAF_DST=/path/to/your/overleaf/project ./sync-to-overleaf.sh
```

Then compile in Overleaf or open the synced PDF locally (Evince, Okular, or Overleaf preview).

## Legacy files

| File | Status |
|------|--------|
| `acronyms.tex` | Thin wrapper: `\usepackage{acronymtooltips}` + `\input{myacronyms}` — for `\include{acronyms}` |
| `pdfcomment-patched.tex` | Redirects to `acronymtooltips-pdfcomment.tex` |

Prefer `\usepackage{acronymtooltips}` and `\input{myacronyms}` in new projects.

## Local build

```bash
pdflatex main.tex
pdflatex main.tex
```

Open `main.pdf` in Evince, Okular (annotations on), Overleaf preview, or Acrobat and hover over repeated acronyms (e.g. the second `\xx{of}`) to see tooltips.
