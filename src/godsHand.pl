get_element(0, [H|_], H).
get_element(N, [_|T], Elem) :-
    N > 0,
    N1 is N - 1,
    get_element(N1, T, Elem).

delete_element(0, [_|T], T).
delete_element(N, [H|T], [H|Rest]) :-
    N > 0,
    N1 is N - 1,
    delete_element(N1, T, Rest).

cek_semua_satu_kartu([]).
cek_semua_satu_kartu([P|T]) :-
    kartu_pemain(P, Tangan),
    get_length(Tangan, Jumlah),
    Jumlah == 1,
    cek_semua_satu_kartu(T).

godsHand :-
    (   permainan_aktif ->
        urutan_pemain(PemainList),
        (   cek_semua_satu_kartu(PemainList) ->
            write('Keseimbangan terjaga. Semua pemain memiliki 1 kartu. God''s Hand tidak aktif.'), nl
        ;   jalankan_gods_hand
        )
    ;   write('Permainan belum dimulai.'), nl
    ).

jalankan_gods_hand :-
    urutan_pemain(PemainList),
    get_length(PemainList, JmlPemain),
    random(0, JmlPemain, IdxDonor),
    get_element(IdxDonor, PemainList, Donor),
    kartu_pemain(Donor, TanganDonor),
    get_length(TanganDonor, JmlKartuDonor),
    (   JmlKartuDonor > 0 ->
        random(0, JmlKartuDonor, IdxKartu),
        get_element(IdxKartu, TanganDonor, KartuPindah),
        delete_element(IdxKartu, TanganDonor, TanganDonorBaru),
        pilih_penerima(JmlPemain, PemainList, Donor, Penerima),
        kartu_pemain(Penerima, TanganPenerima),
        TanganPenerimaBaru = [KartuPindah | TanganPenerima],
        retractall(kartu_pemain(Donor, _)),
        assertz(kartu_pemain(Donor, TanganDonorBaru)),
        retractall(kartu_pemain(Penerima, _)),
        assertz(kartu_pemain(Penerima, TanganPenerimaBaru)),
        KartuPindah = kartu(Warna, Jenis),
        write('Tuhan telah berkehendak.'), nl,
        write('Kartu '), write(Warna), write('-'), write(Jenis),
        write(' milik '), write(Donor), write(' berpindah ke tangan '), write(Penerima), write('!'), nl,
        giliran(PemainSekarang),
        write('Giliran '), write(PemainSekarang), write('.'), nl
    ;   jalankan_gods_hand
    ).

pilih_penerima(JmlPemain, PemainList, Donor, Penerima) :-
    random(0, JmlPemain, IdxPenerima),
    get_element(IdxPenerima, PemainList, Kandidat),
    (   Kandidat == Donor ->
        pilih_penerima(JmlPemain, PemainList, Donor, Penerima)
    ;   Penerima = Kandidat
    ).