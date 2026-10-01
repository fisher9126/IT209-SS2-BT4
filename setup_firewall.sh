#!/bin/bash
# setup_firewall.sh — Cấu hình UFW cho VPS (Session 02 - Ex4)
# Chạy với quyền root:  bash setup_firewall.sh

set -e

echo "==> Cài đặt UFW (nếu chưa có)..."
apt update -y
apt install -y ufw

echo "==> Thiết lập quy tắc mặc định..."
ufw default deny incoming
ufw default allow outgoing

echo "==> Mở cổng SSH (22) và HTTP (80)..."
ufw allow 22/tcp
ufw allow 80/tcp

echo "==> Bật firewall..."
ufw --force enable

echo "==> Trạng thái hiện tại:"
ufw status verbose
