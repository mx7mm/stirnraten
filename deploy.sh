#!/usr/bin/env bash
# deploy.sh - kopiert den Projektinhalt per SFTP zu Netcup
# Nutzung:
#   export NETCUP_SFTP_USER="youruser"
#   export NETCUP_SFTP_HOST="ae9cc.netcup.net"
#   export NETCUP_SFTP_PATH="/mx7m.de/httpdocs"
#   export NETCUP_SFTP_PORT="22"
#   ./deploy.sh

set -euo pipefail

if [[ -z "${NETCUP_SFTP_USER:-}" || -z "${NETCUP_SFTP_HOST:-}" || -z "${NETCUP_SFTP_PATH:-}" ]]; then
  echo "Fehler: Setze NETCUP_SFTP_USER, NETCUP_SFTP_HOST und NETCUP_SFTP_PATH."
  echo "Beispiel: export NETCUP_SFTP_USER='hosting228638'; export NETCUP_SFTP_HOST='ae9cc.netcup.net'; export NETCUP_SFTP_PATH='/mx7m.de/httpdocs'"
  exit 1
fi

LOCAL_DIR="$(pwd)/"
REMOTE_DIR="${NETCUP_SFTP_PATH%/}/"
PORT_OPT="${NETCUP_SFTP_PORT:-22}"

echo "Deploying from $LOCAL_DIR to ${NETCUP_SFTP_USER}@${NETCUP_SFTP_HOST}:${REMOTE_DIR} (Port ${PORT_OPT})"

rsync -avz --delete \
  -e "ssh -p ${PORT_OPT}" \
  --exclude '.git/' \
  --exclude 'deploy.sh' \
  "$LOCAL_DIR" "${NETCUP_SFTP_USER}@${NETCUP_SFTP_HOST}:${REMOTE_DIR}"

echo "Deploy abgeschlossen."
