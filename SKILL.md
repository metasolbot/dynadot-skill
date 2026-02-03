---
name: dynadot
description: >
  Dynadot domain registrar API for searching, registering, and managing domains.
  Use when: (1) Searching domain availability, (2) Registering new domains,
  (3) Managing DNS/nameservers, (4) Setting forwarding or parking,
  (5) Renewing domains, (6) Getting domain info or TLD pricing,
  (7) Managing WHOIS contacts, (8) Listing owned domains,
  (9) Transferring domains, (10) Any Dynadot account operations.
---

# Dynadot Domain Management

Manage domains via the Dynadot API v3. All API calls use JSON format.

**Links:**
- Website: https://www.dynadot.com
- API Docs: https://www.dynadot.com/domain/api-commands
- API Control Panel: https://www.dynadot.com/account/domain/setting/api.html
- Sandbox: https://api-sandbox.dynadot.com
- Help: https://www.dynadot.com/community/help

## Setup

Store API key at `~/.credentials/dynadot.txt`:
```
API_KEY=your_api_key_here
```

## Quick Reference

### API Base URL
```
https://api.dynadot.com/api3.json
```

All requests use query parameters: `?key={API_KEY}&command={command}&...`

### Common Commands

**Search domain availability:**
```bash
curl -s "https://api.dynadot.com/api3.json?key=${API_KEY}&command=search&domain0=example.com&show_price=1&currency=USD"
```

**Register a domain:**
```bash
curl -s "https://api.dynadot.com/api3.json?key=${API_KEY}&command=register&domain=example.com&duration=1&currency=USD"
```

**Get domain info:**
```bash
curl -s "https://api.dynadot.com/api3.json?key=${API_KEY}&command=domain_info&domain=example.com"
```

**List all domains:**
```bash
curl -s "https://api.dynadot.com/api3.json?key=${API_KEY}&command=list_domain"
```

**Renew domain:**
```bash
curl -s "https://api.dynadot.com/api3.json?key=${API_KEY}&command=renew&domain=example.com&duration=1&currency=USD"
```

**Check account balance:**
```bash
curl -s "https://api.dynadot.com/api3.json?key=${API_KEY}&command=get_account_balance"
```

**Get TLD pricing:**
```bash
curl -s "https://api.dynadot.com/api3.json?key=${API_KEY}&command=tld_price&currency=USD"
```

## CLI Script

Use the bundled `scripts/dynadot.sh` for common operations:

```bash
# Search
./scripts/dynadot.sh search example.com

# Register
./scripts/dynadot.sh register example.com 1

# Domain info
./scripts/dynadot.sh info example.com

# List domains
./scripts/dynadot.sh list

# Renew
./scripts/dynadot.sh renew example.com 1

# Set nameservers
./scripts/dynadot.sh set-ns example.com ns1.host.com ns2.host.com

# Set forwarding
./scripts/dynadot.sh forward example.com https://target.com

# Set DNS records
./scripts/dynadot.sh set-dns example.com A 1.2.3.4

# Account balance
./scripts/dynadot.sh balance

# TLD pricing
./scripts/dynadot.sh tld-price

# Lock/unlock domain
./scripts/dynadot.sh lock example.com
./scripts/dynadot.sh unlock example.com

# Set privacy
./scripts/dynadot.sh privacy example.com on

# Delete domain (grace period only)
./scripts/dynadot.sh delete example.com
```

## DNS Management

### Set nameservers
```
command=set_ns&domain=example.com&ns0=ns1.host.com&ns1=ns2.host.com
```

### Set DNS records (set_dns2)
Supports A, AAAA, CNAME, MX, TXT, SRV, CAA, TLSA, FORWARD records.
```
command=set_dns2&domain=example.com&main_record_type0=A&main_record0=1.2.3.4
```

Subdomain records:
```
&subdomain0=www&sub_record_type0=A&sub_record0=1.2.3.4
```

### Set forwarding
```
command=set_forwarding&domain=example.com&forward_url=https://target.com
```

### Set email forwarding
```
command=set_email_forward&domain=example.com&forward_type=forward&username0=info&address0=user@gmail.com
```

## Important Notes

- Account must have sufficient balance for registration/renewal
- Use `currency=USD` to get prices in USD
- Bulk operations: up to 100 domains, comma-separated
- Domain locking: lock domains after registration for security
- Privacy: set `set_privacy` to enable WHOIS privacy
- All responses include `SuccessCode` (0=success, -1=failure)

## Advanced Operations

For transfer, push, DNSSEC, contacts, folders, aftermarket, and other commands, see `references/api-reference.md`.
