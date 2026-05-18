mainkanKartu(NomorUrutKartu) :-
    permainan_aktif,
    giliran(Pemain),
    kartu_pemain(Pemain, Tangan),
    Indeks is NomorUrutKartu - 1,
    (   Indeks >= 0, ambil_elemen_ke(Indeks, Tangan, KartuTerpilih, SisaTangan) ->
        (   validasi_kartu(KartuTerpilih) ->
            proses_kartu_dimainkan(Pemain, SisaTangan, KartuTerpilih)
        ;   write('Kartu tidak valid! Silakan masukkan pilihan kartu kembali.'), nl
        )
    ;   write('Nomor kartu di luar jangkauan kartu di tangan Anda.'), nl
    ).

mainkanKartu(_) :-
    \+ permainan_aktif,
    write('Permainan belum dimulai atau sudah selesai. Ketik startGame. untuk memulai.'), nl.

/* validasi kartu */
validasi_kartu(kartu(Warna, _)) :- 
    warna_aktif(Warna).

validasi_kartu(kartu(_, Jenis)) :- 
    discard_top(kartu(_, JenisTop)), 
    Jenis == JenisTop.

validasi_kartu(kartu(hitam, _)). 

/*efek*/
proses_kartu_dimainkan(Pemain, SisaTangan, KartuTerpilih) :-
    KartuTerpilih = kartu(Warna, Jenis),
    format('~w memainkan kartu: ~w-~w.', [Pemain, Warna, Jenis]), nl,
    retract(kartu_pemain(Pemain, _)),
    assertz(kartu_pemain(Pemain, SisaTangan)),
    retract(discard_top(_)),
    assertz(discard_top(KartuTerpilih)),
    discard_pile(DP),
    retract(discard_pile(DP)),
    assertz(discard_pile([KartuTerpilih | DP])),
    (   Warna \= hitam ->
        retract(warna_aktif(_)),
        assertz(warna_aktif(Warna))
    ;   true
    ),
    (   SisaTangan == [] ->
        format('Selamat, ~w memenangkan permainan!', [Pemain]), nl,
        retract(permainan_aktif)
    ;   terapkan_efek(KartuTerpilih)
    ).

terapkan_efek(kartu(_, Jenis)) :-
    jenis_angka(Jenis),
    ganti_giliran(1).

terapkan_efek(kartu(_, skip)) :-
    write('Pemain berikutnya kehilangan giliran.'), nl,
    ganti_giliran(2).

terapkan_efek(kartu(_, reverse)) :-
    write('Arah permainan berputar.'), nl,
    ubah_arah,
    ganti_giliran(1).

terapkan_efek(kartu(_, draw_two)) :-
    write('Pemain berikutnya mengambil 2 kartu dan kehilangan giliran.'), nl,
    hukum_tarik_kartu(2),
    ganti_giliran(2).

terapkan_efek(kartu(hitam, wild)) :-
    ganti_warna_wild,
    ganti_giliran(1).

terapkan_efek(kartu(hitam, wild_draw_four)) :-
    warna_aktif(WarnaLama),
    discard_pile([_ | TumpukanSisa]), 
    (   TumpukanSisa = [kartu(_, JenisLama) | _] -> true
    ;   JenisLama = kosong 
    ),
    ganti_warna_wild,
    giliran(PemainSekarang),
    urutan_pemain(ListPemain),
    arah_permainan(Arah),
    cari_indeks_pemain(PemainSekarang, ListPemain, IndeksSekarang),
    get_length(ListPemain, JumlahPemain),
    (   Arah == kanan ->
        IndeksBaru is (IndeksSekarang + 1) mod JumlahPemain
    ;   IndeksBaru is (IndeksSekarang - 1) mod JumlahPemain
    ),
    ambil_elemen_ke(IndeksBaru, ListPemain, Penantang, _),
    assertz(status_tantang(Penantang, PemainSekarang, WarnaLama, JenisLama)),
    write('Pemain berikutnya dapat melakukan perintah tantang. atau ambilKartu.'), nl,
    ganti_giliran(1).

/*input pergantian kartu*/
ganti_warna_wild :-
    write('Pilih warna baru (merah/kuning/hijau/biru) diakhiri dengan titik: '),
    read(WarnaBaru),
    (   warna_biasa(WarnaBaru) ->
        retract(warna_aktif(_)),
        assertz(warna_aktif(WarnaBaru)),
        format('Warna aktif permainan diubah menjadi ~w.', [WarnaBaru]), nl
    ;   write('Warna tidak valid! Harap masukkan warna biasa.'), nl,
        ganti_warna_wild
    ).

ubah_arah :-
    arah_permainan(kanan),
    retract(arah_permainan(kanan)),
    assertz(arah_permainan(kiri)), !.
ubah_arah :-
    arah_permainan(kiri),
    retract(arah_permainan(kiri)),
    assertz(arah_permainan(kanan)).

cari_indeks_pemain(Pemain, [Pemain|_], 0) :- !.
cari_indeks_pemain(Pemain, [_|T], Indeks) :-
    cari_indeks_pemain(Pemain, T, IndeksSisa),
    Indeks is IndeksSisa + 1.

ganti_giliran(Langkah) :-
    urutan_pemain(ListPemain),
    giliran(PemainSekarang),
    arah_permainan(Arah),
    cari_indeks_pemain(PemainSekarang, ListPemain, IndeksSekarang),
    length(ListPemain, JumlahPemain),
    (   Arah == kanan ->
        IndeksBaru is (IndeksSekarang + Langkah) mod JumlahPemain
    ;   IndeksBaru is (IndeksSekarang - Langkah) mod JumlahPemain
    ),
    ambil_elemen_ke(IndeksBaru, ListPemain, PemainBerikutnya, _),
    retract(giliran(PemainSekarang)),
    assertz(giliran(PemainBerikutnya)),
    format('Giliran ~w.', [PemainBerikutnya]), nl.

hukum_tarik_kartu(Jumlah) :-
    urutan_pemain(ListPemain),
    giliran(PemainSekarang),
    arah_permainan(Arah),
    cari_indeks_pemain(PemainSekarang, ListPemain, IndeksSekarang),
    length(ListPemain, JumlahPemain),
    (   Arah == kanan ->
        IndeksKorban is (IndeksSekarang + 1) mod JumlahPemain
    ;   IndeksKorban is (IndeksSekarang - 1) mod JumlahPemain
    ),
    ambil_elemen_ke(IndeksKorban, ListPemain, Korban, _),
    tarik_n_kartu(Korban, Jumlah).

tarik_n_kartu(_, 0) :- !.
tarik_n_kartu(Pemain, N) :-
    N > 0,
    deck([KartuTarik | SisaDeck]),
    kartu_pemain(Pemain, Tangan),
    retract(deck(_)),
    assertz(deck(SisaDeck)),
    append(Tangan, [KartuTarik], TanganBaru),
    retract(kartu_pemain(Pemain, Tangan)),
    assertz(kartu_pemain(Pemain, TanganBaru)),
    N1 is N - 1,
    tarik_n_kartu(Pemain, N1).
