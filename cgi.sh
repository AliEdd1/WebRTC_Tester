## 🖥️ FastCGI Script — `/usr/lib/cgi-bin/conninfo.sh`
#!/bin/bash
echo "Content-Type: application/json"
echo ""

CLIENT_IP="${HTTP_CF_CONNECTING_IP:-$HTTP_X_REAL_IP}"
[ -z "$CLIENT_IP" ] && CLIENT_IP="${REMOTE_ADDR}"

GEO_JSON="$(curl -s --max-time 2 "https://ipwho.is/${CLIENT_IP}")"
[ -z "$GEO_JSON" ] && GEO_JSON='{"success":false,"message":"geo lookup failed"}'

cat <<JSON
{
  "client_ip": "${CLIENT_IP}",
  "geo": ${GEO_JSON}
}
JSON
