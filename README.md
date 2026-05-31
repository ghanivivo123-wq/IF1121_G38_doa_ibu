# 🃏 Simulasi Permainan UNI — IF1221 Logika Komputasional

Implementasi permainan kartu **UNI** berbasis teks menggunakan **Prolog (SWI-Prolog / SICStus Prolog)**, dikerjakan sebagai tugas praktikum mata kuliah IF1221 Logika Komputasional di Institut Teknologi Bandung.

---

## 🚀 Cara Menjalankan Program

### Prasyarat
- **GNU Prolog** terinstal di sistem Anda. Unduh di: https://www.gprolog.org/

### Langkah-langkah

1. **Clone atau unduh** repositori ini ke direktori lokal:
   ```bash
   git clone <url-repositori>
   cd <nama-folder>
   ```
2. Masuk ke folder `src`:
   ```bash
   cd src
   ```
3. Jalankan GNU Prolog:
   ```bash
   gprolog
   ```
4. **Consult** file utama program:
   ```prolog
   ?- consult(main).
   ```
5. **Mulai permainan:**
   ```prolog
   ?- startGame.
   ```
6. Ikuti instruksi di layar untuk memasukkan jumlah pemain dan nama masing-masing pemain.

---

## 📁 Struktur Repository

```
/
├── docs/                   # Dokumentasi dan laporan praktikum
├── src/                    # Source code Prolog
│   ├── main.pl             # Entry point — meng-consult semua modul
│   ├── fakta.pl            # Deklarasi fakta dinamis & definisi deck kartu
│   ├── startGame.pl        # Logika inisialisasi permainan
│   ├── mainkanKartu.pl     # Logika memainkan kartu & validasi
│   ├── ambilKartu.pl       # Logika mengambil kartu dari deck
│   ├── uni.pl              # Logika seruan UNI
│   ├── tangkap.pl          # Logika menangkap pemain yang lupa UNI
│   ├── tantang.pl          # Logika menantang kartu wild draw four
│   ├── endGame.pl          # Logika akhir permainan & perhitungan poin
│   ├── saveLoad.pl         # Logika saveGame & loadGame
│   ├── godsHand.pl         # Logika fitur God's Hand
│   ├── lihatKartu.pl       # Menampilkan kartu di tangan pemain aktif
│   ├── cekInfo.pl          # Menampilkan status permainan
│   ├── lihatCommand.pl     # Menampilkan daftar perintah
│   └── game1.txt           # Contoh file save game
└── README.md               # Dokumentasi proyek
```

> Setiap fitur diimplementasikan dalam file `.pl` terpisah. `main.pl` memanggil `consult` ke seluruh modul sehingga cukup satu kali consult untuk menjalankan semua fitur.

---

## ✨ Fitur Utama

| Perintah | Deskripsi |
|---|---|
| `startGame.` | Memulai permainan baru; mengacak deck, membagikan 7 kartu per pemain, dan menentukan urutan giliran secara acak |
| `mainkanKartu(N).` | Memainkan kartu ke-N dari tangan pemain aktif (harus cocok warna/jenis, atau kartu wild) |
| `ambilKartu.` | Mengambil satu kartu dari deck ketika tidak ada kartu valid yang bisa dimainkan |
| `uni(N).` | Memainkan kartu kedua terakhir sekaligus menyerukan "UNI!" agar aman dari tangkapan |
| `tangkap(Nama).` | Menghukum pemain lain yang lupa menyerukan UNI (2 kartu penalti jika berhasil, 1 kartu penalti jika salah tuduh) |
| `tantang.` | Menantang keabsahan kartu `wild_draw_four` yang dimainkan pemain sebelumnya |
| `cekInfo.` | Menampilkan status permainan: giliran, kartu teratas, warna aktif, dan jumlah kartu tiap pemain |
| `lihatKartu.` | Menampilkan daftar kartu di tangan pemain yang sedang giliran |
| `lihatCommand.` | Menampilkan semua perintah yang tersedia beserta keterangannya |
| `saveGame.` | Menyimpan state permainan saat ini ke file `.txt` |
| `loadGame.` | Memuat state permainan dari file `.txt` yang tersimpan |
| `godsHand.` | Fitur acak: memindahkan satu kartu dari satu pemain ke pemain lain secara acak |
| `endGame.` | Dipanggil otomatis saat pemain menghabiskan kartunya; menampilkan perhitungan poin dan peringkat akhir |

### Kartu Spesial yang Didukung
- **Skip** — pemain berikutnya kehilangan giliran
- **Reverse** — membalik arah giliran
- **Draw Two** — pemain berikutnya mengambil 2 kartu dan kehilangan giliran
- **Wild** — pemain bebas memilih warna aktif baru
- **Wild Draw Four** — pemain berikutnya mengambil 4 kartu; dapat ditantang

---

## 👥 Anggota Kelompok

| Nama | NIM | Kontribusi |
|---|---|---|
| M. Nabil Rabbani | 13525004 | `uni`, `lihatKartu`, `cekInfo` |
| Ahmad Humam Isma | 13525032 | `lihatCommand`, `endGame`, laporan |
| Ghaniyul Amri Caulava | 13525106 | `startGame`, `tangkap`, `tantang`, `godsHand`, laporan |
| I Made Adi Kusuma A. | 13525121 | `ambilKartu`, `mainkanKartu`, laporan |

---

## 📝 Catatan

- Deck tidak disimpan saat `saveGame`; ketika `loadGame` dipanggil, deck baru akan dibuat secara acak.
- `saveGame` tidak dapat dilakukan ketika ada `status_tantang` aktif.
- Jumlah pemain dibatasi antara **2 hingga 4 orang**.
- Nama pemain harus **unik** (tidak boleh duplikat).
