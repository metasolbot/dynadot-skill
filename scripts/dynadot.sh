#!/usr/bin/env bash
# Dynadot API CLI wrapper
# Usage: dynadot.sh <command> [args...]
#
# Commands:
#   search <domain> [domain2...]    Search domain availability
#   register <domain> [years]       Register a domain (default: 1 year)
#   info <domain>                   Get domain information
#   list                            List all domains
#   renew <domain> [years]          Renew a domain
#   set-ns <domain> <ns1> [ns2...]  Set nameservers
#   forward <domain> <url>          Set URL forwarding
#   set-dns <domain> <type> <value> Set main DNS record
#   balance                         Check account balance
#   tld-price                       Get TLD pricing
#   lock <domain>                   Lock domain
#   unlock <domain>                 Unlock domain
#   privacy <domain> <on|off>       Set WHOIS privacy
#   delete <domain>                 Delete domain (grace period)
#   contacts                        List contacts
#   create-contact                  Interactive contact creation

set -euo pipefail

CRED_FILE="${DYNADOT_CRED_FILE:-$HOME/.credentials/dynadot.txt}"
API_BASE="https://api.dynadot.com/api3.json"
CURRENCY="${DYNADOT_CURRENCY:-USD}"

# Load API key
load_key() {
  if [[ ! -f "$CRED_FILE" ]]; then
    echo "Error: Credentials file not found at $CRED_FILE" >&2
    echo "Create it with: echo 'API_KEY=your_key' > $CRED_FILE" >&2
    exit 1
  fi
  API_KEY=$(grep '^API_KEY=' "$CRED_FILE" | cut -d= -f2)
  if [[ -z "$API_KEY" ]]; then
    echo "Error: API_KEY not found in $CRED_FILE" >&2
    exit 1
  fi
}

# Make API request
api() {
  local params="key=${API_KEY}&$1"
  curl -s "${API_BASE}?${params}"
}

# Pretty print JSON
pp() {
  if command -v jq &>/dev/null; then
    jq .
  else
    cat
  fi
}

cmd_search() {
  local params="command=search&show_price=1&currency=${CURRENCY}"
  local i=0
  for domain in "$@"; do
    params+="&domain${i}=${domain}"
    ((i++))
  done
  api "$params" | pp
}

cmd_register() {
  local domain="$1"
  local duration="${2:-1}"
  api "command=register&domain=${domain}&duration=${duration}&currency=${CURRENCY}" | pp
}

cmd_info() {
  api "command=domain_info&domain=$1" | pp
}

cmd_list() {
  api "command=list_domain" | pp
}

cmd_renew() {
  local domain="$1"
  local duration="${2:-1}"
  api "command=renew&domain=${domain}&duration=${duration}&currency=${CURRENCY}" | pp
}

cmd_set_ns() {
  local domain="$1"
  shift
  local params="command=set_ns&domain=${domain}"
  local i=0
  for ns in "$@"; do
    params+="&ns${i}=${ns}"
    ((i++))
  done
  api "$params" | pp
}

cmd_forward() {
  local domain="$1"
  local url="$2"
  api "command=set_forwarding&domain=${domain}&forward_url=${url}" | pp
}

cmd_set_dns() {
  local domain="$1"
  local type="$2"
  local value="$3"
  api "command=set_dns2&domain=${domain}&main_record_type0=${type}&main_record0=${value}" | pp
}

cmd_balance() {
  api "command=get_account_balance" | pp
}

cmd_tld_price() {
  api "command=tld_price&currency=${CURRENCY}" | pp
}

cmd_lock() {
  api "command=lock_domain&domain=$1&lock=1" | pp
}

cmd_unlock() {
  api "command=lock_domain&domain=$1&lock=0" | pp
}

cmd_privacy() {
  local domain="$1"
  local status="$2"
  local privacy_val
  case "$status" in
    on|full) privacy_val="full" ;;
    off|none) privacy_val="off" ;;
    *) echo "Usage: privacy <domain> <on|off>" >&2; exit 1 ;;
  esac
  api "command=set_privacy&domain=${domain}&privacy=${privacy_val}" | pp
}

cmd_delete() {
  api "command=delete&domain=$1" | pp
}

cmd_contacts() {
  api "command=contact_list" | pp
}

# Main
load_key

case "${1:-help}" in
  search)     shift; cmd_search "$@" ;;
  register)   shift; cmd_register "$@" ;;
  info)       shift; cmd_info "$@" ;;
  list)       cmd_list ;;
  renew)      shift; cmd_renew "$@" ;;
  set-ns)     shift; cmd_set_ns "$@" ;;
  forward)    shift; cmd_forward "$@" ;;
  set-dns)    shift; cmd_set_dns "$@" ;;
  balance)    cmd_balance ;;
  tld-price)  cmd_tld_price ;;
  lock)       shift; cmd_lock "$@" ;;
  unlock)     shift; cmd_unlock "$@" ;;
  privacy)    shift; cmd_privacy "$@" ;;
  delete)     shift; cmd_delete "$@" ;;
  contacts)   cmd_contacts ;;
  help|*)
    echo "Dynadot Domain CLI"
    echo ""
    echo "Usage: dynadot.sh <command> [args...]"
    echo ""
    echo "Commands:"
    echo "  search <domain> [domain2...]    Search domain availability"
    echo "  register <domain> [years]       Register a domain"
    echo "  info <domain>                   Get domain information"
    echo "  list                            List all domains"
    echo "  renew <domain> [years]          Renew a domain"
    echo "  set-ns <domain> <ns1> [ns2...]  Set nameservers"
    echo "  forward <domain> <url>          Set URL forwarding"
    echo "  set-dns <domain> <type> <value> Set main DNS record"
    echo "  balance                         Check account balance"
    echo "  tld-price                       Get TLD pricing"
    echo "  lock <domain>                   Lock domain"
    echo "  unlock <domain>                 Unlock domain"
    echo "  privacy <domain> <on|off>       Set WHOIS privacy"
    echo "  delete <domain>                 Delete domain (grace period)"
    echo "  contacts                        List contacts"
    ;;
esac
