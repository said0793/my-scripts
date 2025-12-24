#!/bin/bash

CERTS=("lam-evnfmreg1.nfvi-vepc.ms.fcm.crt" "lam-evnfmiam1.nfvi-vepc.ms.fcm.crt" "lam-evnfmhelmreg1.nfvi-vepc.ms.fcm.crt" "lam-evnfmgas1.nfvi-vepc.ms.fcm.crt" "lam-evnfm1.nfvi-vepc.ms.fcm.crt")

for CERT in "${CERTS[@]}"; do
  if [ ! -f "$CERT" ]; then
    echo "File not found: $CERT"
    continue
  fi

  END_DATE=$(openssl x509 -enddate -noout -in "$CERT" | cut -d= -f2)
  END_SECONDS=$(date -d "$END_DATE" +%s)
  NOW_SECONDS=$(date +%s)
  DAYS_LEFT=$(( (END_SECONDS - NOW_SECONDS) / 86400 ))

  echo "==== $CERT ===="
  echo "Expires on : $END_DATE"
  echo "Days left  : $DAYS_LEFT"

  if [ "$DAYS_LEFT" -lt 0 ]; then
    echo "❌ Certificate EXPIRED"
  elif [ "$DAYS_LEFT" -lt 30 ]; then
    echo "⚠️  Expiring soon"
  else
    echo "✅ Certificate valid"
  fi
  echo
done
