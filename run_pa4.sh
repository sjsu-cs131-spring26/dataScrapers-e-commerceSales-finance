set -euo pipefail

INPUT="${1:?Usage: bash run_pa4.sh <INPUT_TSV>}"
if [[ ! -f "$INPUT" ]]; then
  echo "ERROR: File not found: $INPUT" >&2
  exit 1
fi
chmod -R g+rX "$(dirname "$INPUT")" 2>/dev/null || true

mkdir -p out logs

