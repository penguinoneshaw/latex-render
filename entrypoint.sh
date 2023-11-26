#!/usr/bin/env sh

if [ -e "$EXTRA_PACKAGES_FILE" ]; then
    xargs tlmgr install <"$EXTRA_PACKAGES_FILE"
else
    echo "::warning file=$EXTRA_PACKAGES_FILE::Extra packages file not found."
fi
mkdir output
output_dir="output"

cd "$(dirname "$1")" || exit 1

file="$(basename "$1")"

echo "::group::LaTeXmk build"
latexmk -f -interaction=batchmode -pdfxe "$file" -output-directory="$output_dir"

latexmk -c "$file"
echo "::endgroup::"

echo "output-dir=$output_dir" >>"$GITHUB_OUTPUT"
