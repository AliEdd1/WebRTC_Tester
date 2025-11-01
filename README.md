# WebRTC IP & DNS Leak Test Server

A self-hosted WebRTC leak-testing setup built with **Nginx**, **FastCGI (fcgiwrap)**, and a lightweight HTML + JavaScript front-end.

It lets you verify whether your VPN or proxy setup exposes your **real IP** through WebRTC, and shows your **server-side detected IP and location**.
## 🚀 Features
- 🔍 **Client-side WebRTC test** — lists all ICE candidates (host / srflx / relay)
- 🌐 **Server endpoint `/conninfo`** — returns the client’s IP + geo data (via `ipwho.is`)
- ⚙️ **FastCGI-based** — no heavy back-end, just `fcgiwrap` + `curl`
- 🧩 Works on any Debian / Ubuntu server with Nginx
- ✅ Mobile + desktop compatible (HTTPS recommended for mobile)
## 🧩 Installation (on Debian / Ubuntu)

```bash
sudo apt update
sudo apt install -y nginx fcgiwrap curl
sudo systemctl enable --now fcgiwrap.socket

---

### 🧠 **Section 5 — FastCGI Script**
```markdown
## 🖥️ FastCGI Script — `/usr/lib/cgi-bin/conninfo.sh`
```bash
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



sudo chmod +x /usr/lib/cgi-bin/conninfo.sh




---

### 🌐 **Section 6 — Nginx Site Config**
```markdown
## ⚙️ Nginx Site Config — `/etc/nginx/sites-available/default`
```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/html;
    index index.html index.htm webrtc-leak.html;

    # Serve static files
    location / {
        try_files $uri $uri/ =404;
    }

    # FastCGI endpoint for /conninfo
    location = /conninfo {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /usr/lib/cgi-bin/conninfo.sh;
        fastcgi_pass unix:/run/fcgiwrap.socket;
    }

    # Basic hardening
    location ~ /\.ht { deny all; }
}


nginx -t && sudo systemctl reload nginx



---

### 🧾 **Section 7 — WebRTC Test Page**
```markdown
## 🌍 WebRTC Leak Test Page — `/var/www/html/webrtc-leak.html`

This page lists all WebRTC ICE candidates and fetches `/conninfo` to show the server-side IP and geo info.

Full source is under `web/webrtc-leak.html`.

Open → `http://<server-ip>/webrtc-leak.html`
## 🧪 Verify
```bash
curl -s http://<server-ip>/conninfo | jq .

