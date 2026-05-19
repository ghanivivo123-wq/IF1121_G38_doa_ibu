nilai_kartu(kartu(_, Jenis), Poin) :-
    jenis_angka(Jenis), !,
    Poin is Jenis.
nilai_kartu(kartu(_, Jenis), 10) :-
    jenis_aksi(Jenis), !.
nilai_kartu(kartu(hitam, _), 20).

hitung_poin_tangan([], 0).
hitung_poin_tangan([K | Sisa], Total) :-
    nilai_kartu(K, P),
    hitung_poin_tangan(Sisa, SisaTotal),
    Total is P + SisaTotal.

cetak_nama_kartu_list([kartu(W, J)]) :-
    write(W), write('-'), write(J).
cetak_nama_kartu_list([kartu(W, J) | T]) :-
    T \= [],
    write(W), write('-'), write(J), write(' + '),
    cetak_nama_kartu_list(T).

cetak_nilai_kartu_list([K]) :-
    nilai_kartu(K, P),
    write(P).
cetak_nilai_kartu_list([K | T]) :-
    T \= [],
    nilai_kartu(K, P),
    write(P), write(' + '),
    cetak_nilai_kartu_list(T).

/* cetak rincian poin satu pemain */
cetak_detail_kartu(Pemain, []) :-
    write(Pemain), write(': kartu habis = 0 poin'), nl, !.
cetak_detail_kartu(Pemain, Tangan) :-
    write(Pemain), write(': '),
    cetak_nama_kartu_list(Tangan),
    write(' = '),
    cetak_nilai_kartu_list(Tangan),
    write(' = '),
    hitung_poin_tangan(Tangan, Total),
    write(Total), write(' poin'), nl.

hitung_semua_poin([], []).
hitung_semua_poin([P | Sisa], [(P, Poin, JumlahKartu) | Hasil]) :-
    kartu_pemain(P, Tangan),
    hitung_poin_tangan(Tangan, Poin),
    get_length(Tangan, JumlahKartu),
    hitung_semua_poin(Sisa, Hasil).

cetak_poin_semua([]).
cetak_poin_semua([(Pemain, _, _) | T]) :-
    kartu_pemain(Pemain, Tangan),
    cetak_detail_kartu(Pemain, Tangan),
    cetak_poin_semua(T).

/* komparator ranking: A lebih baik dari B jika:
   poin A < poin B, atau
   poin sama dan kartu A < kartu B, atau
   keduanya sama dan A lebih awal dalam urutan_pemain */
urutan_lebih_baik((NamaA, PoinA, KartuA), (NamaB, PoinB, KartuB)) :-
    (   PoinA < PoinB -> true
    ;   PoinA =:= PoinB, KartuA < KartuB -> true
    ;   PoinA =:= PoinB, KartuA =:= KartuB,
        urutan_pemain(ListPemain),
        cari_indeks_pemain(NamaA, ListPemain, IA),
        cari_indeks_pemain(NamaB, ListPemain, IB),
        IA < IB
    ).

/* cari elemen terbaik dari list berdasarkan komparator */
cari_terbaik([X], X) :- !.
cari_terbaik([H | T], Terbaik) :-
    cari_terbaik(T, TerbaikSisa),
    (   urutan_lebih_baik(H, TerbaikSisa) ->
        Terbaik = H
    ;   Terbaik = TerbaikSisa
    ).

/* hapus satu kemunculan elemen dari list */
hapus_elemen(X, [X | T], T) :- !.
hapus_elemen(X, [H | T], [H | Sisa]) :-
    hapus_elemen(X, T, Sisa).

/* selection sort: pilih terbaik, hapus, rekursi */
sort_pemain([], []).
sort_pemain(List, [Terbaik | Sisa]) :-
    cari_terbaik(List, Terbaik),
    hapus_elemen(Terbaik, List, Sisanya),
    sort_pemain(Sisanya, Sisa).


cetak_urutan_pemenang(_, []).
cetak_urutan_pemenang(N, [(Pemain, Poin, _) | T]) :-
    write(N), write('. '), write(Pemain), write(' ('), write(Poin), write(' poin)'), nl,
    N1 is N + 1,
    cetak_urutan_pemenang(N1, T).

endGame :-
    retract(permainan_aktif),
    giliran(Pemenang),
    write('Permainan selesai! '), write(Pemenang), write(' menghabiskan semua kartunya!'), nl,
    write('Berikut perhitungan poin sisa kartu.'), nl,
    urutan_pemain(ListPemain),
    hitung_semua_poin(ListPemain, HasilPoin),
    cetak_poin_semua(HasilPoin),
    nl,
    sort_pemain(HasilPoin, Terurut),
    write('Urutan pemenang:'), nl,
    cetak_urutan_pemenang(1, Terurut),
    nl,
    Terurut = [(Juara, _, _) | _],
    write('Selamat, '), write(Juara), write(' menjadi pemenang!'), nl.
