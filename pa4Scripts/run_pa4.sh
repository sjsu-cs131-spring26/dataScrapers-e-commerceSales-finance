#!/usr/bin/env bash
set -euo pipefail

INPUT="${1:?Usage: bash run_pa4.sh <INPUT_TSV>}"
if [[ ! -f "$INPUT" ]]; then
  echo "ERROR: File not found: $INPUT" >&2
  exit 1
fi
chmod -R g+rX "$(dirname "$INPUT")" 2>/dev/null || true

mkdir -p out logs

# 1. Clean and normalize (SED)
# Save small sample before cleaning
head -6 "$INPUT" > out/before_clean_sample.tsv

# Trim leading/trailing whitespace
# Normalize HTML entities &#34; to "
# Strip HTML <br /> tags
# Strip empty image brackets []
# Collapse multiple spaces to single space
sed -E '
s/^[[:space:]]+//
s/[[:space:]]+$//
s/\&#34;/"/g
s/<br[[:space:]]*\/?>//g
s/\[\]//g
s/  +/ /g
' "$INPUT" > out/cleaned.tsv

# Save small sample after cleaning
head -6 out/cleaned.tsv > out/after_clean_sample.tsv
echo "Task 1, SED cleaning: done."

# 2. Quality filters (AWK)
# Keep header row, then apply business rules:
# - rating must be 1-5
# - title (field 2) must be non-empty
# - text (field 3) must be non-empty
# - asin (field 5) must be non-empty
# - timestamp (field 8) must be positive
# - helpful_vote (field 9) must be non-negative
awk -F'\t' '
BEGIN { OFS="\t"; removed=0 }
NR==1 { print; next }
($1+0) < 1 || ($1+0) > 5 { removed++; next }
$2 == "" { removed++; next }
$3 == "" { removed++; next }
$5 == "" { removed++; next }
($8+0) <= 0 { removed++; next }
($9+0) < 0 { removed++; next }
{ print }
END { print "Removed rows:", removed > "/dev/stderr" }
' out/cleaned.tsv > out/filtered.tsv

# Save small filtered sample
head -6 out/filtered.tsv > out/filtered_sample.tsv
echo "Task 2, AWK filtering: done."

