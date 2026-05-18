get_length([], 0).
get_length([_ | T], N) :-
    get_length(T, N1),
    N is N1 + 1.

uni(Nomor) :-
    permainan_aktif,
    giliran(Pemain),
    assertz(status_uni(Pemain)),
    mainkanKartu(Nomor).

tangkap(Target) :-
    permainan_aktif,
    kartu_pemain(Target, Tangan),
    get_length(Tangan, Jumlah),
    (   Jumlah == 1 ->
        (   status_uni(Target) ->
            hukum_penuduh
        ;   write(Target), write(' tertangkap tidak menyerukan UNI.'), nl,
            write(Target), write(' mendapatkan 2 kartu penalti.'), nl,
            tarik_n_kartu(Target, 2),
            giliran(PemainSekarang), 
            write('Giliran '), write(PemainSekarang), write('.'), nl
        )
    ;   hukum_penuduh
    ).

hukum_penuduh :-
    giliran(Caller),
    write('Tuduhan tidak valid! Target memiliki lebih dari 1 kartu atau sudah menyerukan UNI.'), nl,
    write(Caller), write(' mendapatkan 1 kartu penalti secara acak.'), nl,
    tarik_n_kartu(Caller, 1),
    giliran(PemainSekarang), 
    write('Giliran '), write(PemainSekarang), write('.'), nl.
