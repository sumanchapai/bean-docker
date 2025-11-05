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

# Create the .gitignore file if it doesn't exist
touch "$GITIGNORE"

# Append .env only if it's not already in the file
if ! grep -qxF ".env" "$GITIGNORE"; then
  echo ".env" >> "$GITIGNORE"
  echo "Added .env to .gitignore"
else
  echo ".env already present in .gitignore"
fi

if ! grep -qxF ".DS_Store" "$GITIGNORE"; then
  echo ".DS_Store" >> "$GITIGNORE"
  echo "Added .DS_Store to .gitignore"
else
  echo ".DS_Store already present in .gitignore"
fi

if ! grep -qxF "documents/" "$GITIGNORE"; then
  echo "documents/" >> "$GITIGNORE"
  echo "Added documents/ to .gitignore"
else
  echo "documents/ already present in .gitignore"
fi


exec "$@"
