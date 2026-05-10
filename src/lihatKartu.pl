lihatKartu :-
    permainan_aktif,
    giliran(P),
    kartu_pemain(P, K),
    write('Kartu di tangan '), write(P), write(':'), nl,
    tulis_kartu_tangan(1, K), !.
lihatKartu :-
    \+ permainan_aktif,
    write('Permainan belum dimulai!'), nl.

tulis_kartu_tangan(_, []).
tulis_kartu_tangan(N, [kartu(W, J) | T]) :-
    write(N), write('. '), write(W), write('-'), write(J), nl,
    N1 is N + 1,
    tulis_kartu_tangan(N1, T).