ambilKartu :-
    (   permainan_aktif ->
        giliran(Pemain),
        (   status_tantang(Pemain, _, _, _) ->
            write('Anda memilih untuk tidak menantang.'), nl,
            write(Pemain), write(' mendapatkan 4 kartu acak.'), nl,
            tarik_n_kartu(Pemain, 4),
            retractall(status_tantang(_, _, _, _)),
            ganti_giliran(1)
        ;   kartu_pemain(Pemain, Tangan),
            deck([kartu(Warna, Jenis) | SisaDeck]), 
            write(Pemain), write(' mendapatkan kartu: '), write(Warna), write('-'), write(Jenis), write('.'), nl,
            TanganBaru = [kartu(Warna, Jenis) | Tangan],
            retractall(deck(_)),
            assertz(deck(SisaDeck)),
            retractall(kartu_pemain(Pemain, _)),
            assertz(kartu_pemain(Pemain, TanganBaru)),
            ganti_giliran(1)
        )
    ;   write('Permainan belum dimulai atau sudah selesai. Ketik startGame. untuk memulai.'), nl
    ), !.
