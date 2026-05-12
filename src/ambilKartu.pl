ambilKartu :-
    permainan_aktif,
    giliran(Pemain),
    kartu_pemain(Pemain, Tangan),
    deck([kartu(Warna, Jenis) | SisaDeck]), 
    format('~w mendapatkan kartu: ~w-~w.', [Pemain, Warna, Jenis]), nl,
    TanganBaru = [kartu(Warna, Jenis) | Tangan],
    retract(deck(_)),
    assertz(deck(SisaDeck)),
    retract(kartu_pemain(Pemain, _)),
    assertz(kartu_pemain(Pemain, TanganBaru)),
    ganti_giliran(1), !.
ambilKartu :-
    \+ permainan_aktif,
    write('Permainan belum dimulai atau sudah selesai. Ketik startGame. untuk memulai.'), nl.