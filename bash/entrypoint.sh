#!/usr/bin/env bash
set -euo pipefail

# You need jq installed
command -v jq >/dev/null || { echo "jq required but not installed!"; exit 1; }

# Load secrets from Docker secrets (or wherever mounted)
USER_PASSWORD_SECRET=$(cat /run/secrets/USER_PASSWORD.secret)
CLIENT_SECRET_SECRET=$(cat /run/secrets/CLIENT_SECRET.secret)

# Substitute secrets in MAKE87_CONFIG
MAKE87_CONFIG_RESOLVED=$(echo "$MAKE87_CONFIG" \
  | sed "s/{{ secret.USER_PASSWORD }}/$USER_PASSWORD_SECRET/g" \
  | sed "s/{{ secret.CLIENT_SECRET }}/$CLIENT_SECRET_SECRET/g"
)

# Helper for assertions with line numbers
assert_eq() {
  local desc="$1"
  local left="$2"
  local right="$3"
  if [ "$left" != "$right" ]; then
    echo "❌ Assertion failed: $desc"
    echo "   Left:  '$left'"
    echo "   Right: '$right'"
    exit 1
  fi
}

CONFIG='.config'

# Assertions
assert_eq "username" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.username")" "make87_user"
assert_eq "password" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.password")" "$USER_PASSWORD_SECRET"
assert_eq "retry_count" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.retry_count")" "5"
assert_eq "timeout_seconds" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.timeout_seconds")" "10.5"
assert_eq "enabled" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.enabled")" "true"
assert_eq "start_date" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.start_date")" "2025-07-07"
assert_eq "api_url" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.api_url")" "https://api.make87.com/v1/data"

assert_eq "ip_whitelist[0]" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.ip_whitelist[0]")" "192.168.1.1"
assert_eq "ip_whitelist[1]" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.ip_whitelist[1]")" "10.0.0.2"

assert_eq "features.core" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.features.core")" "true"
assert_eq "features.advanced" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.features.advanced")" "true"
assert_eq "features.experimental" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.features.experimental")" "false"

assert_eq "mode" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.mode")" "advanced"
assert_eq "options.type" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.options.type")" "url"
assert_eq "options.link" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.options.link")" "https://example.com/data.json"

assert_eq "credentials.client_id" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.credentials.client_id")" "my-client-id"
assert_eq "credentials.client_secret" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.credentials.client_secret")" "$CLIENT_SECRET_SECRET"

assert_eq "nested_array[0].id" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.nested_array[0].id")" "1"
assert_eq "nested_array[0].tags[0]" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.nested_array[0].tags[0]")" "camera"
assert_eq "nested_array[0].tags[1]" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.nested_array[0].tags[1]")" "sensor"
assert_eq "nested_array[1].id" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.nested_array[1].id")" "2"
assert_eq "nested_array[1].tags length" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.nested_array[1].tags | length")" "0"

assert_eq "toggle_feature" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.toggle_feature")" "true"
assert_eq "feature_config.level" "$(echo "$MAKE87_CONFIG_RESOLVED" | jq -r "$CONFIG.feature_config.level")" "high"


echo "✅ All config assertions passed successfully. Running forever now..."
tail -f /dev/null
