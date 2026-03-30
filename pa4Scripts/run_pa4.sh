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

# 3. Ratios, buckets, and per-entity summaries (AWK)
FILTERED="out/filtered.tsv"
REPORT="out/task3_summary.txt"

awk -F'\t' '
NR == 1 {next} 
$5 !~ /^B[A-Z0-9]{9}$/ { next }
{
  # Amazon Standard Identification Number
  asin = $5
  helpful = ($9 + 0)
  verified = ($10 == "True")
  rating = ($1 + 0)
  count[asin]++
  sum_rating[asin]   += rating
  sum_helpful[asin]  += helpful
  sum_verified[asin] += verified 
  if (!(asin in min_rating) || rating < min_rating[asin]) min_rating[asin] = rating
  if (!(asin in max_rating) || rating > max_rating[asin]) max_rating[asin] = rating
  total_reviews++
  total_helpful += helpful
}
END {
  if (total_reviews == 0) {
    print "No data found."
    exit 1
  }
  global_ratio = total_helpful / total_reviews
# print totals, reviews, helpful, helpful ratio
  printf "Total reviews : %d\n",   total_reviews
  printf "Total helpful : %d\n",   total_helpful
  printf "Helpful/reviews: %.4f\n\n", global_ratio
  print "======================================================"
# asin, bucket, count, avg, "help ratio"
printf "%-15s  %-7s  %-6s  %-6s  %-6s  %-7s  %s\n",
       "ASIN", "BUCKET", "COUNT", "AVG_R", "MIN_R", "MAX_R",  "HELP_RATIO"
printf "%-15s  %-7s  %-6s  %-6s  %s\n",
       "---------------","-------","------","------","------","-------","----------"
for (asin in count) {
  n = count[asin]
  avg_r      = sum_rating[asin]  / n
  help_ratio = (n > 0) ? sum_helpful[asin] / n : 0   # guard ÷0
  # assign bucket
  if      (help_ratio == 0)    bucket = "ZERO"
  else if (help_ratio <  0.25) bucket = "LO"
  else if (help_ratio <  0.75) bucket = "MID"
  else                         bucket = "HI"
  bucket_count[bucket]++
        printf "%-15s  %-7s  %-6d  %-6.2f  %-6d  %-7d  %.4f\n",
               asin, bucket, n, avg_r,
               min_rating[asin], max_rating[asin],
               help_ratio
 }
# bucket count
print "BUCKET COUNTS"
  print "======================================================"
  for (b in bucket_count)
    printf "  %-6s : %d\n", b, bucket_count[b]
}
' "$FILTERED" > "$REPORT"
echo "Task 3, Ratios/buckets/summaries: done. -> $REPORT"

# 4. Temporal: convert unix timestamp (ms) to YYYY-MM, emit month|count|avg_rating, sorted chronologically
awk -F'\t' '
NR == 1 { next }
$5 !~ /^B[A-Z0-9]{9}$/ { next }
{
  m = strftime( "%Y-%m", $8/1000 ) 
  count[m]++
  sum[m] += $1
}
END {
  for (m in count)
    printf "%-10s  %-8d  %.2f\n", m, count[m], sum[m] / count[m] 
}' "$FILTERED" | sort | awk '
BEGIN {
  print "======================================================"
  print " MONTHLY SUMMARY (month | count | avg_rating)"
  print "======================================================"
  printf "%-10s  %-8s  %s\n", "MONTH", "COUNT", "AVG_RATING"
  printf "%-10s  %-8s  %s\n", "----------", "--------", "----------"
}
{ print }' > out/task4_monthly.txt
echo "Task 4, Temporal monthly summary: done. -> out/task4_monthly.txt"

# 5. Signal discovery – keyword frequency by rating group (AWK)
# Case-fold title+text, tokenize, count words in HIGH (4-5) vs LOW (1-2) reviews
# Emit top keyword signals ranked by lift (HIGH share / LOW share)
awk -F'\t' '
NR == 1 { next }
{
  rating = ($1 + 0)
  if      (rating >= 4) grp = "H"
  else if (rating <= 2) grp = "L"
  else next
 
  blob = tolower($2 " " $3)
  gsub(/[^a-z ]/, " ", blob)
  n = split(blob, words, " ")
  for (i = 1; i <= n; i++) {
    w = words[i]
    if (length(w) < 3) continue
    freq[grp, w]++
    tot[grp]++
    seen[w] = 1
  }
}
END {
  # basic stopwords
  ns = split("the and for that this with was but are not you have has its from they were will can all just more also your about than into them some her she his him out who would what there their when which how very could should did does got get one two our may any own only over such after then too most other being those because each made still back even said use like", sw, " ")
  for (k = 1; k <= ns; k++) stop[sw[k]] = 1
 
  printf "%-15s  %6s  %6s  %8s\n", "KEYWORD", "H_CNT", "L_CNT", "LIFT"
  printf "%-15s  %6s  %6s  %8s\n", "---------------", "------", "------", "--------"
  for (w in seen) {
    if (w in stop) continue
    h = freq["H", w] + 0
    l = freq["L", w] + 0
    if (h + l < 3) continue
    h_pct = (tot["H"] > 0) ? h / tot["H"] : 0
    l_pct = (tot["L"] > 0) ? l / tot["L"] : 0
    lift  = (l_pct > 0) ? h_pct / l_pct : 999.99
    printf "%-15s  %6d  %6d  %8.2f\n", w, h, l, lift
  }
}
' "$FILTERED" > out/_tmp5.txt
head -2 out/_tmp5.txt > out/task5_signals.txt
tail -n +3 out/_tmp5.txt | sort -t' ' -k4 -rn >> out/task5_signals.txt
rm -f out/_tmp5.txt
echo "Task 5, Signal discovery (keyword lift): done. -> out/task5_signals.txt"

echo "All tasks complete."
