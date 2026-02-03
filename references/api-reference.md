# Dynadot API v3 Reference

## Base URL
- Production: `https://api.dynadot.com/api3.json`
- Sandbox: `https://api-sandbox.dynadot.com/api3.json`

All requests: `GET {base}?key={API_KEY}&command={command}&...`

## Response Format
All responses include:
- `SuccessCode` or `ResponseCode`: 0 = success, -1 = failure
- `Status`: "success" or "error"
- `Error`: error message (on failure only)

---

## Domain Commands

### search
Search domain availability (up to 100 domains for bulk accounts).
```
domain0=example.com&domain1=example.net&show_price=1&currency=USD
```
Response: `SearchResults[].{DomainName, Available, Price}`

### register
Register a domain. Requires sufficient account balance.
```
domain=example.com&duration=1&currency=USD
```
Optional: `registrant_contact`, `admin_contact`, `technical_contact`, `billing_contact`, `premium=1`, `coupon`
Response: `{DomainName, Expiration, Status}`

### bulk_register
Register up to 100 domains.
```
domain0=a.com&domain1=b.com&currency=USD
```

### renew
Renew a domain.
```
domain=example.com&duration=1&currency=USD
```
Optional: `price_check=1` (check price without renewing), `coupon`, `no_renew_if_late_renew_fee_needed=1`

### delete
Delete domain in grace period (refunds registration fee).
```
domain=example.com
```

### domain_info
Get full domain details.
```
domain=example.com
```
Response: Name, Expiration, Registration, NameServerSettings, Whois, Locked, Privacy, Status, RenewOption, Folder, etc.

### list_domain
List all domains in account. No additional parameters.

### lock_domain
Lock or unlock a domain.
```
domain=example.com&lock=1  (lock)
domain=example.com&lock=0  (unlock)
```

### set_privacy
```
domain=example.com&privacy=full  (enable)
domain=example.com&privacy=off   (disable)
```

### set_renew_option
```
domain=example.com&renew_option=auto|reset|no
```

### set_note
```
domain=example.com&note=My+note
```

### set_folder
```
domain=example.com&folder=folderId
```

---

## DNS & Nameserver Commands

### set_ns
Set nameservers (up to 13). Nameservers must exist in your account.
```
domain=example.com&ns0=ns1.host.com&ns1=ns2.host.com
```

### set_dns2
Set DNS records directly. Supports multiple record types.

**Main domain records:**
```
domain=example.com&main_record_type0=A&main_record0=1.2.3.4&main_record_type1=MX&main_record1=mail.example.com&main_recordx1=10
```

**Subdomain records:**
```
&subdomain0=www&sub_record_type0=A&sub_record0=1.2.3.4
&subdomain1=mail&sub_record_type1=CNAME&sub_record1=mail.host.com
```

Supported types: A, AAAA, CNAME, MX, TXT, SRV, CAA, TLSA, FORWARD

For MX: use `main_recordx0` for priority
For TXT: value is the TXT content

### get_dns
Get current DNS records.
```
domain=example.com
```

### set_forwarding
```
domain=example.com&forward_url=https://target.com
```

### set_stealth
Stealth forwarding (iframe).
```
domain=example.com&stealth_url=https://target.com&stealth_title=My+Site
```

### set_parking
Park domain with optional ads.
```
domain=example.com&with_ads=no
```

### set_email_forward
```
domain=example.com&forward_type=forward&username0=info&address0=user@gmail.com
```

---

## Nameserver Management

### add_ns / register_ns
Add or register a nameserver.
```
command=add_ns&host=ns1.example.com
command=register_ns&host=ns1.example.com&ip=1.2.3.4
```

### set_ns_ip
Update nameserver IP.
```
host=ns1.example.com&ip=1.2.3.4
```

### delete_ns
```
host=ns1.example.com
```

### server_list
List all nameservers. No additional parameters.

---

## Transfer Commands

### transfer
Transfer domain to Dynadot.
```
domain=example.com&auth=AUTH_CODE&currency=USD
```
Optional: `privacy=on|off`, `name_servers=ns1.com,ns2.com`, contacts, `coupon`

### get_transfer_status
```
domain=example.com
```

### cancel_transfer
```
domain=example.com
```

### get_transfer_auth_code
Get auth code for transferring away.
```
domain=example.com
```

### authorize_transfer_away
```
domain=example.com
```

---

## Push Commands

### push
Push domain to another Dynadot account.
```
domain=example.com&receiver_push_username=username
```
Optional: `unlock_domain_for_push=1`, `receiver_email`

### get_domain_push_request
List incoming push requests.

### set_domain_push_request
Accept/reject push request.
```
push_id=123&action=accept|reject
```

---

## Contact Commands

### create_contact
```
name=John+Doe&email=john@example.com&phonenumcc=1&phonenum=5551234567
&address1=123+Main+St&city=San+Francisco&state=CA&country=US&zip=94102
```

### edit_contact
```
contact_id=12345&name=New+Name&...
```

### delete_contact
```
contact_id=12345
```

### contact_list
List all contacts. No additional parameters.

### get_contact
```
contact_id=12345
```

---

## Account Commands

### account_info
Get account details. No additional parameters.

### get_account_balance
Get account balance. No additional parameters.

### tld_price
Get pricing for all TLDs.
```
currency=USD
```

---

## Folder Commands

### create_folder
```
folder_name=My+Folder
```

### delete_folder
```
folder_id=123
```

### folder_list
List all folders. No additional parameters.

### set_folder_name
```
folder_id=123&folder_name=New+Name
```

Set folder-level defaults: `set_folder_ns`, `set_folder_dns2`, `set_folder_forwarding`, etc.

---

## Aftermarket Commands

### get_open_auctions
List open auctions. No additional parameters.

### get_auction_details
```
auction_id=123
```

### place_auction_bid
```
auction_id=123&amount=100&currency=USD
```

### get_listings / get_listing_item / buy_it_now
Browse and purchase aftermarket listings.

### Backorders
`add_backorder_request`, `delete_backorder_request`, `backorder_request_list`

---

## DNSSEC Commands

### set_dnssec
```
domain=example.com&key_tag0=12345&algorithm0=13&digest_type0=2&digest0=abc123...
```

### get_dnssec
```
domain=example.com
```

### clear_dnssec
```
domain=example.com
```

---

## Other Commands

### set_for_sale
```
domain=example.com&for_sale=1&price=1000&currency=USD
```

### order_list
List recent orders. No additional parameters.

### is_processing
Check if account has orders processing. No additional parameters.

### list_coupons
List available coupons. No additional parameters.
