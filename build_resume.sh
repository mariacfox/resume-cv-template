#!/usr/bin/env bash
# Converts resume markdown files to PDF using pandoc (markdown → HTML)
# and WeasyPrint (HTML → PDF), preserving all CSS styling.
#
# Usage:
#   ./build_resume.sh                    # convert all *.md files in the directory
#   ./build_resume.sh resume-template.md # convert specific file(s)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CSS_FILE="$SCRIPT_DIR/resume-style.css"

# Validate dependencies
if ! command -v pandoc &>/dev/null; then
    echo "Error: pandoc not found. Install with: brew install pandoc" >&2
    exit 1
fi
if ! command -v weasyprint &>/dev/null; then
    echo "Error: weasyprint not found. Install with: brew install weasyprint" >&2
    exit 1
fi
if [ ! -f "$CSS_FILE" ]; then
    echo "Error: CSS file not found at: $CSS_FILE" >&2
    exit 1
fi

# Use args if provided, otherwise convert all .md files
if [ $# -gt 0 ]; then
    files=("$@")
else
    files=("$SCRIPT_DIR"/*.md)
fi

for md_file in "${files[@]}"; do
    [[ -f "$md_file" ]] || { echo "Warning: skipping $md_file (not found)"; continue; }

    pdf_file="${md_file%.md}.pdf"
    tmp_html=$(mktemp /tmp/resume_XXXXXX.html)

    echo "Building $(basename "$md_file")..."

    # Convert markdown to HTML body only (pandoc strips YAML frontmatter automatically).
    # Filter out any embedded <link> tags since we inject the CSS ourselves below.
    html_body=$(pandoc -f markdown -t html5 "$md_file" | grep -v 'rel="stylesheet"')

    # Wrap in a minimal HTML document with the CSS properly referenced.
    cat > "$tmp_html" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <link rel="stylesheet" href="file://$CSS_FILE">
</head>
<body>
$html_body
</body>
</html>
HTML

    # Render to PDF with WeasyPrint.
    # WeasyPrint renders only what's in the HTML/CSS — no headers, footers, or page numbers added.
    # CSS @page rules (margins, page size) in resume-style.css control the layout.
    weasyprint "$tmp_html" "$pdf_file" 2>/dev/null

    rm -f "$tmp_html"
    echo "  → $(basename "$pdf_file")"
done

echo "Done."
