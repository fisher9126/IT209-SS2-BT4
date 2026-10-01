# Session 02 — Ex4: Cấu hình tường lửa cho VPS

## Thông tin máy chủ

| Thông số | Giá trị |
|---|---|
| Nhà cung cấp | AZVPS |
| Hostname | fisher-9126 |
| IP | 160.187.229.65 |
| OS | Ubuntu 22.04.1 LTS |
| Gói | Cheap 2 (2GB RAM / 20GB Disk) |

## 1. Kiểm tra Cloud Firewall ở tầng hạ tầng

Panel quản trị AZVPS cho VPS này chỉ có các mục: **Tổng quan, Tài nguyên, Cài đặt, Sao lưu, Lịch sử**. Không có mục Firewall / Network / Security ở tầng hạ tầng, và AZVPS cũng không mở panel ảo hóa (Virtualizor/SolusVM) để tự cấu hình tường lửa biên.

Kết luận: Nhà cung cấp AZVPS **không hỗ trợ Cloud Firewall** ở tầng hạ tầng như DigitalOcean.

## 2. Giải pháp: UFW (tường lửa cấp hệ điều hành)

Do không có Cloud Firewall, bài tập triển khai bảo mật bằng **UFW (Uncomplicated Firewall)** — tường lửa chạy ở cấp hệ điều hành. Về mặt khái niệm, UFW đảm nhận vai trò lọc gói tin tương đương Cloud Firewall, chỉ khác về vị trí lọc.

### So sánh hai lớp

| | Cloud Firewall (DigitalOcean) | UFW (cấp OS) |
|---|---|---|
| Vị trí lọc | Biên mạng datacenter, **trước khi** gói tin chạm VPS | Tại kernel của OS, **sau khi** gói tin đã tới VPS |
| Tài nguyên VPS | Traffic bị chặn không tốn CPU/băng thông của VPS | Tốn một ít CPU để kernel lọc |
| Kiểm soát | Qua panel nhà cung cấp | Toàn quyền trong máy, cấu hình linh hoạt |

Phòng thủ nhiều lớp lý tưởng dùng cả hai. Trong môi trường AZVPS không có lớp biên, UFW là lớp bảo vệ chính.

## 3. Quy tắc đã áp dụng

- Mặc định: **chặn** toàn bộ inbound, **cho phép** toàn bộ outbound.
- Chỉ mở inbound: cổng **22** (SSH) và cổng **80** (HTTP).

```bash
# Mặc định
ufw default deny incoming
ufw default allow outgoing

# Mở cổng cần thiết
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP

# Bật firewall
ufw enable
```

> ⚠️ Luôn mở cổng 22 **trước** khi `ufw enable`, nếu không sẽ tự khóa mình khỏi phiên SSH.

## 4. Kiểm chứng

```bash
ufw status verbose
```

Kết quả mong đợi:

```
Status: active
Default: deny (incoming), allow (outgoing), disabled (routed)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
80/tcp (v6)                ALLOW IN    Anywhere (v6)
```

*(Đính kèm ảnh chụp màn hình `ufw status verbose` để chứng minh firewall thật đang chạy.)*
