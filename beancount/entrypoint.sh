#!/bin/sh
set -e

echo "ENTRYPOINT running ..." > /proc/1/fd/1

BEAN_FILE="/app/data/main.beancount"

# Create default beancount file if it doesn't exist
if [ ! -f "$BEAN_FILE" ]; then
  echo "option \"title\" \"$BUSINESS_NAME\"" > "$BEAN_FILE"

  if [ -n "$CURRENCY" ]; then
    IFS=','
    for cur in $CURRENCY; do
      echo "option \"operating_currency\" \"$cur\"" >> "$BEAN_FILE"
    done
    unset IFS
  fi

  echo "\n\n2001-01-01 custom \"fava-sidebar-link\" \"Git\" \"/git\"" >> "$BEAN_FILE"

  echo "\n\n\n1970-01-01 open Assets:Cash" >> "$BEAN_FILE"
  echo "Created default $BEAN_FILE"
fi

exec "$@"

