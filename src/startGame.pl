/* reset game */
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

/* penggunaan random */
acak_list([], []).
acak_list(ListAwal, [ElemenTerpilih | SisaDiacak]) :-
    get_length(ListAwal, Panjang),
    random(0, Panjang, IndeksAcak),
    get_element(IndeksAcak, ListAwal, ElemenTerpilih, SisaList),
    acak_list(SisaList, SisaDiacak).

/* get_element: ambil elemen ke-N dan kembalikan sisa list */
get_element(0, [H|T], H, T).
get_element(N, [H|T], Elemen, [H|Sisa]) :-
    N > 0,
    N1 is N - 1,
    get_element(N1, T, Elemen, Sisa).

/* get_length: hitung panjang list */
get_length([], 0).
get_length([_|T], N) :-
    get_length(T, N1),
    N is N1 + 1.

/* ambil_n_elemen: ambil N elemen pertama dari list */
ambil_n_elemen(0, Sisa, [], Sisa).
ambil_n_elemen(N, [H|T], [H|Hasil], Sisa) :-
    N > 0,
    N1 is N - 1,
    ambil_n_elemen(N1, T, Hasil, Sisa).

/* cek_member: cek apakah elemen ada dalam list */
cek_member(X, [X|_]).
cek_member(X, [_|T]) :-
    cek_member(X, T).

/* tidak_ada_dalam: cek apakah elemen TIDAK ada dalam list */
tidak_ada_dalam(_, []).
tidak_ada_dalam(X, [H|T]) :-
    X \= H,
    tidak_ada_dalam(X, T).

/* gabung_list: gabungkan dua list menjadi satu */
gabung_list([], L, L).
gabung_list([H|T], L, [H|Hasil]) :-
    gabung_list(T, L, Hasil).

/* tambah_akhir: tambahkan elemen ke akhir list */
tambah_akhir([], X, [X]).
tambah_akhir([H|T], X, [H|Hasil]) :-
    tambah_akhir(T, X, Hasil).

/* pembuatan deck */
buat_deck(ShuffledDeck) :-
    kombinasi_kartu([merah, kuning, hijau, biru], 
                    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], DeckAngka),
    kombinasi_kartu([merah, kuning, hijau, biru], 
                    [skip, reverse, draw_two], DeckAksi),
    kombinasi_kartu_wild([hitam], 
                         [wild, wild_draw_four], DeckWild),
    gabung_list(DeckAngka, DeckAksi, TempDeck),
    gabung_list(TempDeck, DeckWild, DeckAwal),
    acak_list(DeckAwal, ShuffledDeck).

kombinasi_kartu([], _, []).
kombinasi_kartu([W | Ws], ListJenis, Deck) :-
    pasangkan_satu_warna(W, ListJenis, KartuWarnaIni),
    kombinasi_kartu(Ws, ListJenis, SisaDeck),
    gabung_list(KartuWarnaIni, SisaDeck, Deck).

pasangkan_satu_warna(_, [], []).
pasangkan_satu_warna(Warna, [J | Js], [kartu(Warna, J) | SisaKartu]) :-
    pasangkan_satu_warna(Warna, Js, SisaKartu).

kombinasi_kartu_wild([], _, []).
kombinasi_kartu_wild([W | Ws], ListJenis, Deck) :-
    pasangkan_wild_4x(W, ListJenis, KartuWildIni),
    kombinasi_kartu_wild(Ws, ListJenis, SisaDeck),
    gabung_list(KartuWildIni, SisaDeck, Deck).

pasangkan_wild_4x(_, [], []).
pasangkan_wild_4x(Warna, [J | Js], [kartu(Warna, J), kartu(Warna, J), kartu(Warna, J), kartu(Warna, J) | SisaKartu]) :-
    pasangkan_wild_4x(Warna, Js, SisaKartu).

/* inisialisasi pemain */

/* baca_nama: baca input nama sebagai atom */
baca_nama(Nama) :-
    read(Nama).

inisialisasi_jumlah_pemain(Jumlah) :-
    write('Masukkan jumlah pemain: '),
    read(Input),
    validasi_jumlah(Input, Jumlah).

/* validasi_jumlah: hanya menerima integer 2-4 */
validasi_jumlah(2, 2).
validasi_jumlah(3, 3).
validasi_jumlah(4, 4).
validasi_jumlah(Input, Jumlah) :-
    Input \= 2, Input \= 3, Input \= 4,
    write('Mohon masukkan angka antara 2 - 4.'), nl,
    inisialisasi_jumlah_pemain(Jumlah).

inisialisasi_nama_pemain(N, Jumlah, Acc, Acc) :- 
    N > Jumlah, !.

inisialisasi_nama_pemain(N, Jumlah, Acc, ListPemain) :-
    N =< Jumlah,
    write('Masukkan nama pemain '), write(N), write(': '),
    baca_nama(Nama),
    validasi_nama(Nama, Acc, NamaValid),
    tambah_akhir(Acc, NamaValid, NewAcc),
    NextN is N + 1,
    inisialisasi_nama_pemain(NextN, Jumlah, NewAcc, ListPemain).

validasi_nama(Nama, Acc, Nama) :-
    tidak_ada_dalam(Nama, Acc), !.

validasi_nama(_, Acc, NamaValid) :-
    write('Nama sudah digunakan. Masukkan nama lain: '),
    baca_nama(NamaBaru), 
    validasi_nama(NamaBaru, Acc, NamaValid).

cetak_urutan([H]) :- 
    write(H), write('.'), nl.
cetak_urutan([H|T]) :- 
    write(H), write(' - '), 
    cetak_urutan(T).

/* distribusi kartu */
bagi_kartu_pemain([], Deck, Deck).

bagi_kartu_pemain([Pemain | SisaPemain], DeckSekarang, SisaDeck) :-
    ambil_n_elemen(7, DeckSekarang, Tangan, DeckBaru),
    assertz(kartu_pemain(Pemain, Tangan)),
    bagi_kartu_pemain(SisaPemain, DeckBaru, SisaDeck).

/* validasi kartu awal */
tentukan_kartu_awal([kartu(W, J) | SisaDeck], SisaDeck, kartu(W, J)) :-
    jenis_angka(J), !. 

tentukan_kartu_awal([kartu(W, J) | SisaDeck], DeckFinal, KartuAwal) :-
    tambah_akhir(SisaDeck, kartu(W, J), DeckSementara),
    tentukan_kartu_awal(DeckSementara, DeckFinal, KartuAwal). 

/* start game */
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
    
    write('Kartu discard top: '), write(WarnaTop), write('-'), write(JenisTop), write('.'), nl, nl,
    
    UrutanPemain = [PemainPertama | _],
    assertz(giliran(PemainPertama)),
    assertz(permainan_aktif),
    
    write('Giliran '), write(PemainPertama), write('.'), nl.
