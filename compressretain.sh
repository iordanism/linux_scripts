#!/bin/sh

# Usage:
#   ./compressretain.sh [LOGDIR] [COMPRESSION_DAYS] [RETENTION_DAYS]
#
# Example:
#   ./compressretain.sh /var/log/myapp 30 360

LOGDIR="${1:-/var/log/myapp}"
COMPRESSION_DAYS="${2:-30}"
RETENTION_DAYS="${3:-360}"

# Basic validation
if [ ! -d "$LOGDIR" ]; then
  echo "Error: LOGDIR does not exist: $LOGDIR" >&2
  exit 1
fi

# Compress logs older than COMPRESSION_DAYS and not already compressed
find "$LOGDIR" \
  -type f \
  -name "*.log" \
  ! -name "*.gz" \
  -mtime +"$COMPRESSION_DAYS" \
  -exec gzip {} \;

# Delete logs older than RETENTION_DAYS
find "$LOGDIR" \
  -type f \
  -name "*.log.*.gz" \
  -mtime +"$RETENTION_DAYS" \
  -delete