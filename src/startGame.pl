/*reset game*/
reset_game :-
    retractall(urutan_pemain(_)),
    retractall(giliran(_)),
    retractall(discard_top(_)),
    retractall(warna_aktif(_)),
    retractall(arah_permainan(_)),
    retractall(kartu_pemain(_, _)),
    retractall(permainan_aktif),
    retractall(deck(_)),
    retractall(discard_pile(_)).

/*penggunaan random*/
acak_list([], []).
acak_list(ListAwal, [ElemenTerpilih | SisaDiacak]) :-
    length(ListAwal, Panjang),
    random(0, Panjang, IndeksAcak),
    ambil_elemen_ke(IndeksAcak, ListAwal, ElemenTerpilih, SisaList),
    acak_list(SisaList, SisaDiacak).

ambil_elemen_ke(0, [H|T], H, T).
ambil_elemen_ke(N, [H|T], Elemen, [H|Sisa]) :-
    N > 0,
    N1 is N - 1,
    ambil_elemen_ke(N1, T, Elemen, Sisa).

/*pembuatan deck*/
buat_deck(ShuffledDeck) :-
    kombinasi_kartu([merah, kuning, hijau, biru], 
                    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], DeckAngka),
    kombinasi_kartu([merah, kuning, hijau, biru], 
                    [skip, reverse, draw_two], DeckAksi),
    kombinasi_kartu_wild([hitam], 
                         [wild, wild_draw_four], DeckWild),
    append(DeckAngka, DeckAksi, TempDeck),
    append(TempDeck, DeckWild, DeckAwal),
    acak_list(DeckAwal, ShuffledDeck).

kombinasi_kartu([], _, []).
kombinasi_kartu([W | Ws], ListJenis, Deck) :-
    pasangkan_satu_warna(W, ListJenis, KartuWarnaIni),
    kombinasi_kartu(Ws, ListJenis, SisaDeck),
    append(KartuWarnaIni, SisaDeck, Deck).

pasangkan_satu_warna(_, [], []).
pasangkan_satu_warna(Warna, [J | Js], [kartu(Warna, J) | SisaKartu]) :-
    pasangkan_satu_warna(Warna, Js, SisaKartu).

kombinasi_kartu_wild([], _, []).
kombinasi_kartu_wild([W | Ws], ListJenis, Deck) :-
    pasangkan_wild_4x(W, ListJenis, KartuWildIni),
    kombinasi_kartu_wild(Ws, ListJenis, SisaDeck),
    append(KartuWildIni, SisaDeck, Deck).

pasangkan_wild_4x(_, [], []).
pasangkan_wild_4x(Warna, [J | Js], [kartu(Warna, J), kartu(Warna, J), kartu(Warna, J), kartu(Warna, J) | SisaKartu]) :-
    pasangkan_wild_4x(Warna, Js, SisaKartu).

/*inisialisasi pemain*/
baca_nama(NamaFinal) :-
    read_term(Input, [variable_names(Vars)]),
    (   Vars = [NamaKapital = _] -> 
        NamaFinal = NamaKapital 
    ;   
        NamaFinal = Input       
    ).

inisialisasi_jumlah_pemain(Jumlah) :-
    write('Masukkan jumlah pemain: '),
    read(Input),
    validasi_jumlah(Input, Jumlah).

validasi_jumlah(Input, Input) :-
    integer(Input), Input >= 2, Input =< 4, !.

validasi_jumlah(_, Jumlah) :-
    write('Mohon masukkan angka antara 2 - 4.'), nl,
    inisialisasi_jumlah_pemain(Jumlah).

inisialisasi_nama_pemain(N, Jumlah, Acc, Acc) :- 
    N > Jumlah, !.

inisialisasi_nama_pemain(N, Jumlah, Acc, ListPemain) :-
    N =< Jumlah,
    format('Masukkan nama pemain ~w: ', [N]),
    baca_nama(Nama), % <--- Menggunakan baca_nama, bukan read lagi
    validasi_nama(Nama, Acc, NamaValid),
    append(Acc, [NamaValid], NewAcc),
    NextN is N + 1,
    inisialisasi_nama_pemain(NextN, Jumlah, NewAcc, ListPemain).

validasi_nama(Nama, Acc, Nama) :-
    \+ member(Nama, Acc), !.

validasi_nama(_, Acc, NamaValid) :-
    write('Nama sudah digunakan. Masukkan nama lain: '),
    baca_nama(NamaBaru), 
    validasi_nama(NamaBaru, Acc, NamaValid).

cetak_urutan([H]) :- 
    write(H), write('.'), nl.
cetak_urutan([H|T]) :- 
    write(H), write(' - '), 
    cetak_urutan(T).

/*distribusi kartu*/
bagi_kartu_pemain([], Deck, Deck).

bagi_kartu_pemain([Pemain | SisaPemain], DeckSekarang, SisaDeck) :-
    length(Tangan, 7), 
    append(Tangan, DeckBaru, DeckSekarang), 
    assertz(kartu_pemain(Pemain, Tangan)),
    bagi_kartu_pemain(SisaPemain, DeckBaru, SisaDeck).

/*validasi kartu awal*/
tentukan_kartu_awal([kartu(W, J) | SisaDeck], SisaDeck, kartu(W, J)) :-
    jenis_angka(J), !. 

tentukan_kartu_awal([kartu(W, J) | SisaDeck], DeckFinal, KartuAwal) :-
    \+ jenis_angka(J), 
    append(SisaDeck, [kartu(W, J)], DeckSementara), 
    tentukan_kartu_awal(DeckSementara, DeckFinal, KartuAwal). 

/*start game*/
startGame :-
    reset_game,
    inisialisasi_jumlah_pemain(Jumlah), nl,
    inisialisasi_nama_pemain(1, Jumlah, [], ListPemain), nl,
    
    acak_list(ListPemain, UrutanPemain),
    write('Urutan pemain: '), cetak_urutan(UrutanPemain), nl,
    
    assertz(urutan_pemain(UrutanPemain)),
    assertz(arah_permainan(kanan)),
    
    buat_deck(DeckAwal),
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl,
    bagi_kartu_pemain(UrutanPemain, DeckAwal, DeckSetelahDibagi), nl,
    
    tentukan_kartu_awal(DeckSetelahDibagi, SisaTumpukanDraw, kartu(WarnaTop, JenisTop)),
    
    assertz(discard_top(kartu(WarnaTop, JenisTop))),
    assertz(warna_aktif(WarnaTop)),
    assertz(discard_pile([kartu(WarnaTop, JenisTop)])),
    assertz(deck(SisaTumpukanDraw)),
    
    format('Kartu discard top: ~w-~w.', [WarnaTop, JenisTop]), nl, nl,
    
    UrutanPemain = [PemainPertama | _],
    assertz(giliran(PemainPertama)),
    assertz(permainan_aktif),
    
    format('Giliran ~w.', [PemainPertama]), nl.
