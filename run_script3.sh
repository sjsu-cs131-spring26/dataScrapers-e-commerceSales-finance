#!/usr/bin/env bash
set -euo pipefail

# CS 131 Project, Sprint 3
# Entry script to generate the Evidence Pack used in the Decision Brief.
#
# Usage:
#   ./scripts/run_sprint3.sh <DATASET_PATH> <DELIM>
#
# Example:
#   ./scripts/run_sprint3.sh /path/to/data.tsv $'\\t'
#
# Outputs:
#   out/evidence/ (evidence artifacts referenced by the Decision Brief)
#   out/run_sprint3.log
#   out/errors.log

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <DATASET_PATH> <DELIM>" >&2
  exit 1
fi

DATASET_PATH="$1"
DELIM="$2"

OUT_DIR="out1"
EVID_DIR="${OUT_DIR}/evidence"
LOG="${OUT_DIR}/run_sprint3.log"
ERR="${OUT_DIR}/errors.log"

mkdir -p "${EVID_DIR}"
: > "${LOG}"
: > "${ERR}"

exec > >(tee -a "${LOG}") 2> >(tee -a "${ERR}" >&2)

echo "Sprint 3 evidence pack run"
date
echo "Dataset: ${DATASET_PATH}"
echo "Delimiter: '${DELIM}'"
echo

if [[ ! -f "${DATASET_PATH}" ]]; then
  echo "ERROR: dataset not found at: ${DATASET_PATH}" >&2
  exit 2
fi

echo "File size"
ls -lh "${DATASET_PATH}" | tee "${EVID_DIR}/file_size.txt"
echo

echo "Header preview"
head -n 3 "${DATASET_PATH}" | tee "${EVID_DIR}/header_preview.txt"
echo

echo "Row count"
wc -l "${DATASET_PATH}" | tee "${EVID_DIR}/row_count.txt"
echo

# Configure fields (edit these for your dataset), 1-based indexing for cut
FIELD_ORDER_ID=1
FIELD_ORDER_DATE=2
FIELD_CUSTOMER_ID=3
FIELD_PRODUCT_ID=5
FIELD_PRODUCT_NAME=6
FIELD_CATEGORY=7
FIELD_BRAND=8
FIELD_QUANTITY=9
FIELD_UNIT_PRICE=10
FIELD_DISCOUNT=11
FIELD_TAX=12
FIELD_SHIPPING_COST=13
FIELD_TOTAL_AMOUNT=14
FIELD_PAYMENT_METHOD=15
FIELD_ORDER_STATUS=16
FIELD_CITY=17
FIELD_STATE=18
FIELD_COUNTRY=19
FIELD_SELLER_ID=20


# Decision-driving artifact 1: top us states by total revenue
echo "Generating top10_us_states_by_revenue.txt"

awk -F "${DELIM}" \
  -v state="${FIELD_STATE}" \
  -v country="${FIELD_COUNTRY}" \
  -v total="${FIELD_TOTAL_AMOUNT}" '
NR==1 { next }
{
  if ($country=="United States" && $state!="" && $total!="") {
    revenue[$state] += $total;
  }
}
END {
  print "state\ttotal_revenue";
  for (s in revenue) {
    printf "%s\t%.2f\n", s, revenue[s];
  }
}' "${DATASET_PATH}" \
| sort -k2,2nr \
| head -n 11 \
| tee "${EVID_DIR}/top10_us_states_by_revenue.txt"

echo

# Decision-driving artifact 2: order status breakdown by state (for US states)
echo "Generating order_status_breakdown_by_state.txt"

awk -F "${DELIM}" \
  -v state="${FIELD_STATE}" \
  -v country="${FIELD_COUNTRY}" \
  -v status="${FIELD_ORDER_STATUS}" '
NR==1 { next }
{
  if ($country=="United States" && $state!="" && $status!="") {
    count[$state, $status]++;
    total[$state]++;
  }
}
END {
  print "state\torder_status\tcount\tstate_total\tpct_within_state";
  for (k in count) {
    split(k, a, SUBSEP);
    s=a[1]; st=a[2];
    c=count[k];
    t=total[s];
    pct=(t>0 ? c/t : 0);
    printf "%s\t%s\t%d\t%d\t%.4f\n", s, st, c, t, pct;
  }
}' "${DATASET_PATH}" \
| sort -k1,1 -k3,3nr \
| tee "${EVID_DIR}/order_status_breakdown_by_state.txt"

echo

# Decision-driving artifact 3: top 20 sellers by performance (total revenue, order count, avg order value)
echo "Generating top20_seller_performance.txt"

awk -F "${DELIM}" \
  -v seller="${FIELD_SELLER_ID}" \
  -v total="${FIELD_TOTAL_AMOUNT}" '
NR==1 { next }
{
  if ($seller!="" && $total!="") {
    revenue[$seller] += $total;
    orders[$seller]++;
  }
}
END {
  print "seller_id\torder_count\ttotal_revenue\tavg_order_value";
  for (s in revenue) {
    avg = revenue[s] / orders[s];
    printf "%s\t%d\t%.2f\t%.2f\n", s, orders[s], revenue[s], avg;
  }
}' "${DATASET_PATH}" \
| sort -k3,3nr \
| head -n 21 \
| tee "${EVID_DIR}/top20_seller_performance.txt"

echo

# trust check: missing value analysis for key fields (state, order_status, total_amount)
echo "Generating trust_check_missing_values.txt"

awk -F "${DELIM}" \
  -v state="${FIELD_STATE}" \
  -v status="${FIELD_ORDER_STATUS}" \
  -v total="${FIELD_TOTAL_AMOUNT}" '
NR==1 { next }
{
  n++;
  miss_state += ($state=="");
  miss_status += ($status=="");
  miss_total += ($total=="");
}
END {
  print "field\tmissing_count\tmissing_rate";
  printf "state\t%d\t%.4f\n", miss_state, (n?miss_state/n:0);
  printf "order_status\t%d\t%.4f\n", miss_status, (n?miss_status/n:0);
  printf "total_amount\t%d\t%.4f\n", miss_total, (n?miss_total/n:0);
  print "total_rows\t" n;
}' "${DATASET_PATH}" \
| tee "${EVID_DIR}/trust_check_missing_values.txt"

echo

# Decision-driving artifact 4: payment method breakdown (count and percentage of total orders)
echo "Generating payment_method_breakdown.txt"
 
awk -F "${DELIM}" \
  -v payment="${FIELD_PAYMENT_METHOD}" '
NR==1 { next }
{
  if ($payment!="" ) {
    count[$payment]++;
    n++;
  }
}
END {
  print "payment_method\torder_count\tpct_of_total";
  for (p in count) {
    pct = (n>0 ? count[p]/n : 0);
    printf "%s\t%d\t%.4f\n", p, count[p], pct;
  }
}' "${DATASET_PATH}" \
| sort -k2,2nr \
| tee "${EVID_DIR}/payment_method_breakdown.txt"

echo

# Assumption test: discount should be between 0 and 1 (if present)
echo "Generating assumption_test_discount_range.txt"

awk -F "${DELIM}" -v d="${FIELD_DISCOUNT}" '
NR==1 { next }
{
  n++;
  if ($d=="") {
    missing++;
  } else {
    val=$d+0;
    if (val<0 || val>1) invalid++;
    else valid++;
  }
}
END {
  print "total_rows=" n;
  print "valid_discount_rows=" valid;
  print "invalid_discount_rows=" invalid;
  print "missing_discount_rows=" missing;
  if (n>0) printf "invalid_rate=%.4f\n", invalid/n;
}' "${DATASET_PATH}" \
| tee "${EVID_DIR}/assumption_test_discount_range.txt"

echo
