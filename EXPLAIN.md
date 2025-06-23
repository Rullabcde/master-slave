# Konfigurasi MySQL Master-Slave

Ini adalah setup konfigurasi MySQL untuk replikasi Master-Slave, di mana **1 Master** akan ngirim data ke **2 Slave**. Semua setting ditulis di file `my.cnf` atau `my.ini`, bagian `[mysqld]`.

---

## Konsep Singkat

- **Master** = server utama yang nyimpen dan nulis data.
- **Slave** = server backup yang copy data dari Master (read-only).
- Replikasi ini modelnya **asynchronous**, cocok buat backup & load balancing baca data.

---

## Konfigurasi Detail

### Master (server-id = 1)

```ini
[mysqld]
server-id = 1                      # ID unik buat server Master
log-bin = mysql-bin                # Aktifkan binary log (wajib buat replikasi)
binlog-format = ROW                # Format log-nya pakai ROW, lebih akurat
bind-address = 0.0.0.0             # Biar bisa diakses dari luar
max_connections = 1000             # Biar bisa handle banyak koneksi
innodb_buffer_pool_size = 256M     # Alokasi RAM buat penyimpanan InnoDB
```

### Slave-1 (server-id = 2)

```ini
[mysqld]
server-id = 2                      # ID unik buat Slave-1
log-bin = mysql-bin                # Optional, tapi bagus buat chain replication
binlog-format = ROW
bind-address = 0.0.0.0
relay-log = relay-log-slave1       # File relay log khusus Slave-1
read-only = 1                      # Supaya data nggak bisa ditulis langsung
max_connections = 500
innodb_buffer_pool_size = 128M
```

### Slave-2 (server-id = 3)

```ini
[mysqld]
server-id = 3
log-bin = mysql-bin
binlog-format = ROW
bind-address = 0.0.0.0
relay-log = relay-log-slave2       # File relay log khusus Slave-2
read-only = 1
max_connections = 500
innodb_buffer_pool_size = 128M
```

---

## Catatan

- Pastikan semua `server-id` beda-beda (unik) untuk tiap node.
- `log-bin` wajib aktif di master supaya bisa replikasi.
- Gunakan `ROW` format buat hasil replikasi yang akurat.
- `read-only = 1` di Slave penting supaya nggak ada data yang ketulis manual.
- Setting `bind-address = 0.0.0.0` biar bisa diakses dari network lain (jangan lupa atur firewall dan user aksesnya ya).

---
