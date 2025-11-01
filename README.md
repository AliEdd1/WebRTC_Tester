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
```


### 🧠 **Section 5 — FastCGI Script**
```bash
 chmod +x /usr/lib/cgi-bin/conninfo.sh
```


```bash
nginx -t && sudo systemctl reload nginx
```

---

### 🧾 **Section 7 — WebRTC Test Page**
markdown
 🌍 WebRTC Leak Test Page — `/var/www/html/webrtc-leak.html`

This page lists all WebRTC ICE candidates and fetches `/conninfo` to show the server-side IP and geo info.

Full source is under `web/webrtc-leak.html`.

Open → `http://<server-ip>/webrtc-leak.html`
## 🧪 Verify
```bash
curl -s http://<server-ip>/conninfo | jq .
```
