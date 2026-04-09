# resume-cv

A minimal Markdown-based resume template that converts to a clean, print-ready PDF using [pandoc](https://pandoc.org/) and [WeasyPrint](https://weasyprint.org/).

## What's included

| File | Description |
|------|-------------|
| `resume-template.md` | Resume template with placeholder content |
| `resume-style.css` | CSS stylesheet controlling layout, fonts, and colors |
| `build_resume.sh` | Shell script to convert Markdown → PDF |

## Prerequisites

Install [pandoc](https://pandoc.org/) and [WeasyPrint](https://weasyprint.org/):

```bash
brew install pandoc weasyprint
```

## Usage

1. Copy `resume-template.md` and fill in your own content.
2. Run the build script:

```bash
# Convert all .md files in the directory
./build_resume.sh

# Or convert a specific file
./build_resume.sh my-resume.md
```

The PDF will be written alongside the Markdown file with the same base name.

## Customization

Edit `resume-style.css` to change fonts, colors, spacing, or page margins. The `@page` rule at the top controls page size and margins for print output.

The stylesheet uses:
- `letter` page size with `0.5in` margins
- Helvetica Neue / Arial as the base font
- A blue accent color (`#2563EB`) for hyperlinks — change the `color` value in the `a[href]` rule to use any color you like
- Section headers underlined with a light gray rule

## How it works

`build_resume.sh` pipes each Markdown file through pandoc to produce an HTML fragment, wraps it in a minimal HTML document referencing `resume-style.css`, then passes that to WeasyPrint to render a pixel-accurate PDF. This approach preserves all CSS including `@page` rules, which standard browser print dialogs often override.

---

Built with [Claude](https://claude.ai) by Anthropic.
