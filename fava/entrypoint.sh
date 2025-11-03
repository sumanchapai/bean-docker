#!/bin/sh
set -euo pipefail

DIR="/app/data"

# Create documents directory
mkdir -p  /app/data/documents
mkdir -p /app/data/journals

YEAR=$(date +%Y)

ACCOUNTS_FILE="accounts.bean"

# Create accounts file if it doesn't 
if [ ! -e "$ACCOUNTS_FILE" ]; then
cat > "$ACCOUNTS_FILE" <<EOF
1970-01-01 open Assets:Cash
1970-01-01 open Equity:Opening-Balances
EOF
fi

YEAR_FILE="journals/${YEAR}.bean"

# Create journal file for the current year (if it doesn't exist already)
if [ ! -e "$YEAR_FILE" ]; then
cat > "$YEAR_FILE" <<EOF
;
; All transactions for $YEAR
;

EOF
fi

# Create the main.beancount file
MAIN_BEAN_FILE="${DIR}/main.bean"

# Create main.bean file it it doesn't exist
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
1970-01-01 custom "fava-sidebar-link" "Git" "/git/"

;;; Include files
include "$ACCOUNTS_FILE"
include "$YEAR_FILE"

EOF
fi

# Create the main.beancount file
GITIGNORE="${DIR}/.gitignore"

# Append .env to the gitignore file
echo ".env" >> "$GITIGNORE"

exec "$@"
