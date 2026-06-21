Telegram bot to manage servers (inside the bot)
- VLESS (Reality OR Websocket OR XHTTP) — with advanced settings: flow control, custom TLS fingerprint, Reality maxTimeDiff, multiple shortIds rotation, fragment (anti-DPI), padding, mux.cool
- Hysteria 2 — with bandwidth control (Brutal/BBR), obfuscation (salamander), speed test, port hopping
- NaiveProxy
- OpenConnect
- Wireguard
- Amnezia
- AdguardHome
- MTProto
- PAC
- automatic ssl
---
environment: ubuntu 22.04/24.04, debian 11/12/13

## Install:
```shell
wget -O- https://raw.githubusercontent.com/kqbmvx/vpnbot/master/scripts/init.sh | sh -s YOUR_TELEGRAM_BOT_KEY master
```
#### Restart:
```shell
make r
```
#### autoload:
```shell
crontab -e
```
add `@reboot cd /root/vpnbot && make r` and save

---

## Notable changes from upstream (mercurykd/vpnbot)

**Hysteria 2** (was v1):
- Upgraded to Hysteria v2 protocol
- Bandwidth limits with Brutal congestion control, or force BBR via "ignore client bandwidth"
- Obfuscation (salamander) with dedicated password
- Speed test and UDP proxy toggles
- Port hopping (UDP range redirect via iptables), persists across `make r` restarts
- One-tap random password generation (auth + obfs)

**VLESS/Xray Advanced menu**:
- Flow control: `xtls-rprx-vision` or `none` (compat mode)
- TLS fingerprint rotation: chrome / firefox / safari / ios / android / edge / random
- Reality `maxTimeDiff` configuration
- Multiple `shortIds` rotation (1-16)
- TLS ClientHello fragmentation for DPI evasion
- Padding bytes for XHTTP/WS transports
- mux.cool toggle
