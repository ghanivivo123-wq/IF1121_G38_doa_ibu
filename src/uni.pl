uni(Nomor) :-
    permainan_aktif,
    giliran(Pemain),
    kartu_pemain(Pemain, Tangan),
    get_length(Tangan, JumlahKartu),
    proses_uni(Pemain, Tangan, JumlahKartu, Nomor), !.

uni(_) :-
    \+ permainan_aktif,
    write('Permainan belum dimulai!'), nl.

proses_uni(Pemain, Tangan, 2, Nomor) :-
    Indeks is Nomor - 1,
    (   Indeks >= 0, get_element(Indeks, Tangan, KartuTerpilih, SisaTangan) ->
        (   validasi_kartu(KartuTerpilih) ->
            write(Pemain), write(' menyerukan UNI!'), nl,
            assertz(status_uni(Pemain)),
            proses_kartu_dimainkan(Pemain, SisaTangan, KartuTerpilih)
        ;   write('Kartu tidak valid! Silakan masukkan pilihan kartu kembali.'), nl
        )
    ;   write('Nomor kartu di luar jangkauan kartu di tangan Anda.'), nl
    ).

proses_uni(Pemain, _, JumlahKartu, _) :-
    JumlahKartu \= 2,
    write('Perintah tidak valid. Kartu Anda tidak akan tersisa satu setelah aksi ini.'), nl,
    write('Anda mendapatkan 1 kartu penalti dan giliran Anda berakhir.'), nl,
    tarik_n_kartu(Pemain, 1),
    ganti_giliran(1).
