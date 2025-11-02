#!/bin/sh
set -euo pipefail

DIR="/app/data"

# Ensure that the data directory exists and is empty
if [ ! -d "$DIR" ]; then
  echo "❌ $DIR does not exist"
  exit 1
fi

# Create documents directory
mkdir -p  /app/data/documents
mkdir -p /app/data/journals

YEAR=$(date +%Y)

ACCOUNTS_FILE="accounts.bean"

if [ ! -e "$ACCOUNTS_FILE" ]; then
cat > "$ACCOUNTS_FILE" <<EOF
1970-01-01 open Assets:Cash
1970-01-01 open Equity:Opening-Balances
EOF
fi

YEAR_FILE="journals/${YEAR}.bean"

if [ ! -e "$YEAR_FILE" ]; then
cat > "$YEAR_FILE" <<EOF
;
; All transactions for $YEAR
;

EOF
fi

# Create the main.beancount file
MAIN_BEAN_FILE="${DIR}/main.bean"

if [ ! -e "$MAIN_BEAN_FILE" ]; then
cat > "$MAIN_BEAN_FILE" <<EOF
option "title" "$BUSINESS_NAME"
option "documents" "documents"

;; Currencies
option "operating_currency" "USD"
1970-01-01 commodity USD
  precision: 2

option "operating_currency" "INR"
1970-01-01 commodity INR
  precision: 2

option "operating_currency" "NPR"
1970-01-01 commodity NPR
  precision: 2

; Add link to sidebar
1970-01-01 custom "fava-sidebar-link" "Git" "/git"

;;; Include files
include "$ACCOUNTS_FILE"
include "$YEAR_FILE"

EOF
fi

exec "$@"
