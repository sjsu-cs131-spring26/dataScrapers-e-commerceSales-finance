
#!/usr/bin/env bash
set -euo pipefail

file="$1"
OUT_DIR="out"
mkdir -p out
exec > "$OUT_DIR/report_$(date +%Y%m%d_%H%M%S).txt"

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

' "$1"


# time, convert unix timestamp to seconds, to YYYY-MM, emit month\tcount\tavg_metric, sorted chronologicaly
# month\tcount\tavg_metric

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

}' "$file" | sort | awk '
BEGIN {
  print "======================================================"
  print " MONTHLY SUMMARY (month | count | avg_rating)"
  print "======================================================"
  printf "%-10s  %-8s  %s\n", "MONTH", "COUNT", "AVG_RATING"
  printf "%-10s  %-8s  %s\n", "----------", "--------", "----------"
}
{ print }'

