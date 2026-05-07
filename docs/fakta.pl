/* FAKTA STATIS */
warna_biasa(merah).
warna_biasa(kuning).
warna_biasa(hijau).
warna_biasa(biru).

warna_pilihan(merah).
warna_pilihan(kuning).
warna_pilihan(hijau).
warna_pilihan(biru).

jenis_angka(0). 
jenis_angka(1).
jenis_angka(2). 
jenis_angka(3). 
jenis_angka(4). 
jenis_angka(5). 
jenis_angka(6). 
jenis_angka(7). 
jenis_angka(8). 
jenis_angka(9).

jenis_aksi(skip).
jenis_aksi(reverse).
jenis_aksi(draw_two).

/* FAKTA DYNAMIC */
:- dynamic urutan_pemain/1.
:- dynamic giliran/1.
:- dynamic discard_top/1.
:- dynamic warna_aktif/1.
:- dynamic arah_permainan/1.
:- dynamic kartu_pemain/2.
:- dynamic permainan_aktif/0.
:- dynamic deck/1.
:- dynamic discard_pile/1.
