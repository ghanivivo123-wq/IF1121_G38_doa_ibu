cekInfo :-
    permainan_aktif,
    giliran(P),
    discard_top(kartu(WT, JT)),
    warna_aktif(WA),
    write('Giliran saat ini: '), write(P), nl,
    write('Kartu teratas: '), write(WT), write('-'), write(JT), nl,
    write('Warna aktif: '), write(WA), nl,
    write('Jumlah kartu pemain:'), nl,
    urutan_pemain(L),
    tulis_jumlah_kartu(L), !.
cekInfo :-
    \+ permainan_aktif,
    write('Permainan belum dimulai!'), nl.

tulis_jumlah_kartu([]).
tulis_jumlah_kartu([P | T]) :-
    kartu_pemain(P, K),
    length(K, J),
    write('- '), write(P), write(': '), write(J), write(' kartu'), nl,
    tulis_jumlah_kartu(T).