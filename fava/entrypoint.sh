#!/bin/sh
set -euo pipefail

DIR="/app/data"

# Ensure that the data directory exists and is empty
if [ -d "$DIR" ]; then
  if [ -z "$(ls -A "$DIR")" ]; then
    echo "✅ Directory is empty"
  else
    echo "❌ Directory is not empty"
    exit 1
  fi
else
  echo "❌ $DIR does not exist"
  exit 1
fi

# Create documents directory
mkdir  /app/data/documents
mkdir  /app/data/journals

YEAR=$(date +%Y)

ACCOUNTS_FILE="accounts.bean"

cat > "$ACCOUNTS_FILE" <<EOF
1970-01-01 open Assets:Cash
1970-01-01 open Equity:Opening-Balances

EOF

YEAR_FILE="journals/${YEAR}.bean"

cat > "$YEAR_FILE" <<EOF
;
; All transactions for $YEAR
;

EOF

# Create the main.beancount file
MAIN_BEAN_FILE="${DIR}/main.bean"

cat > "$MAIN_BEAN_FILE" <<EOF
option "title" "$BUSINESS_NAME"
option "documents" "documents"

;; Currencies
option "operating_currency" "USD"
option "operating_currency" "INR"
option "operating_currency" "NPR"

1970-01-01 custom "fava-sidebar-link" "Git" "/git"

;;; Include files
include "$ACCOUNTS_FILE"
include "$YEAR_FILE"

EOF

exec "$@"
