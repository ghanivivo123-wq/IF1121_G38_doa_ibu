/* Aksi UNI */
uni(NomorUrut) :-
    permainan_aktif,
    giliran(Pemain),
    kartu_pemain(Pemain, Tangan),
    length(Tangan, JumlahKartu),
    (   JumlahKartu == 2 ->
        Indeks is NomorUrut - 1,
        (   Indeks >= 0, ambil_elemen_ke(Indeks, Tangan, KartuTerpilih, SisaTangan) ->
            (   validasi_kartu(KartuTerpilih) ->
                KartuTerpilih = kartu(Warna, Jenis),
                format('~w memainkan kartu: ~w-~w.', [Pemain, Warna, Jenis]), nl,
                write(Pemain), write(' menyerukan UNI!'), nl,
                assertz(status_uni(Pemain)),
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
                terapkan_efek(KartuTerpilih)
            ;   write('Kartu tidak valid! Silakan masukkan pilihan kartu kembali.'), nl
            )
        ;   write('Nomor kartu di luar jangkauan kartu di tangan Anda.'), nl
        )
    ;   
        write('Perintah tidak valid. Kartu Anda tidak akan tersisa satu setelah aksi ini.'), nl,
        write('Anda mendapatkan 1 kartu penalti dan giliran Anda berakhir.'), nl,
        tarik_n_kartu(Pemain, 1),
        ganti_giliran(1)
    ), !.

uni(_) :-
    \+ permainan_aktif,
    write('Permainan belum dimulai!'), nl.

/* Aksi Tangkap */
tangkap(NamaPemain) :-
    permainan_aktif,
    giliran(PemainSekarang),
    urutan_pemain(ListPemain),
    (   member(NamaPemain, ListPemain) ->
        kartu_pemain(NamaPemain, TanganTarget),
        length(TanganTarget, JumlahTarget),
        (   JumlahTarget == 1, \+ status_uni(NamaPemain) ->
            write(NamaPemain), write(' tertangkap tidak menyerukan UNI.'), nl,
            write(NamaPemain), write(' mendapatkan 2 kartu penalti.'), nl,
            tarik_n_kartu(NamaPemain, 2),
            format('Giliran ~w.', [PemainSekarang]), nl
        ;   
            format('Perintah tangkap tidak valid. ~w mendapatkan 1 kartu penalti.', [PemainSekarang]), nl,
            tarik_n_kartu(PemainSekarang, 1),
            ganti_giliran(1)
        )
    ;   write('Pemain tidak ditemukan.'), nl
    ), !.

tangkap(_) :-
    \+ permainan_aktif,
    write('Permainan belum dimulai!'), nl.
