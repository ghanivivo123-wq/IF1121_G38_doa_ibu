cek_kartu_cocok([], _, _) :- fail.
cek_kartu_cocok([kartu(Warna, Jenis) | T], WarnaLama, JenisLama) :-
    (   Warna == WarnaLama -> true
    ;   Jenis == JenisLama -> true
    ;   cek_kartu_cocok(T, WarnaLama, JenisLama)
    ).

tantang :-
    permainan_aktif,
    giliran(Penantang),
    (   status_tantang(Penantang, Tertantang, WarnaLama, JenisLama) ->
        write('Tantangan dilakukan!'), nl,
        write('Memeriksa kartu '), write(Tertantang), write('...'), nl,
        kartu_pemain(Tertantang, TanganTertantang),
        (   cek_kartu_cocok(TanganTertantang, WarnaLama, JenisLama) ->
            write('Tantangan berhasil!'), nl,
            write(Tertantang), write(' mendapatkan 4 kartu acak.'), nl,
            tarik_n_kartu(Tertantang, 4),
            retractall(status_tantang(_, _, _, _)),
            write('Silakan mainkan kartu Anda atau ketik ambilKartu.'), nl
        ;   write('Tantangan gagal. '), write(Penantang), write(' mendapatkan 6 kartu acak.'), nl,
            tarik_n_kartu(Penantang, 6),
            retractall(status_tantang(_, _, _, _)),
            ganti_giliran(1)
        )
    ;   write('Tidak ada kartu wild_draw_four yang bisa ditantang saat ini.'), nl
    ).
