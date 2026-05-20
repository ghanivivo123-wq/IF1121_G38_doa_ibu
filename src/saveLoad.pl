gabung_string(Atom1, Atom2, AtomGabung) :-
    name(Atom1, List1),
    name(Atom2, List2),
    gabung_list(List1, List2, ListGabung),
    name(AtomGabung, ListGabung).

saveGame :-
    (   permainan_aktif ->
        (   status_tantang(_, _, _, _) ->
            write('Command ini tidak dapat digunakan ketika pemain diharuskan memilih command tertentu (misal: tantang/ambilKartu).'), nl
        ;   write('Masukkan nama file penyimpanan: '),
            read(InputNama),
            gabung_string(InputNama, '.txt', FileName),
            tell(FileName),
            tulis_urutan_pemain,
            tulis_giliran,
            tulis_discard_top,
            tulis_warna_aktif,
            tulis_arah_permainan,
            tulis_status_uni,
            tulis_kartu_semua_pemain,
            told,
            write('Status permainan berhasil disimpan ke '), write(FileName), write('.'), nl
        )
    ;   write('Permainan belum dimulai.'), nl
    ).

tulis_urutan_pemain :-
    urutan_pemain(L),
    write('urutan_pemain:'), writeq(L), write('.'), nl.

tulis_giliran :-
    giliran(P),
    write('giliran:'), writeq(P), write('.'), nl.

tulis_discard_top :-
    discard_top(kartu(W, J)),
    write('discard_top:'), write(W), write('-'), writeq(J), write('.'), nl.

tulis_warna_aktif :-
    warna_aktif(W),
    write('warna_aktif:'), write(W), write('.'), nl.

tulis_arah_permainan :-
    arah_permainan(A),
    write('arah_permainan:'), write(A), write('.'), nl.

tulis_status_uni :-
    urutan_pemain(PemainList),
    kumpulkan_uni(PemainList, ListUni),
    write('status_UNI:'), writeq(ListUni), write('.'), nl.

kumpulkan_uni([], []).
kumpulkan_uni([P|T], Res) :-
    (   status_uni(P) ->
        Res = [P|Rest],
        kumpulkan_uni(T, Rest)
    ;   kumpulkan_uni(T, Res)
    ).

tulis_kartu_semua_pemain :-
    urutan_pemain(PemainList),
    loop_tulis_kartu(PemainList).

loop_tulis_kartu([]).
loop_tulis_kartu([P|T]) :-
    kartu_pemain(P, Tangan),
    ubah_format_kartu(Tangan, TanganFormat),
    write('kartu('), writeq(P), write('):'), writeq(TanganFormat), write('.'), nl,
    loop_tulis_kartu(T).

ubah_format_kartu([], []).
ubah_format_kartu([kartu(W, J) | T], [W-J | Rest]) :-
    ubah_format_kartu(T, Rest).

loadGame :-
    write('Masukkan nama file yang akan dimuat: '),
    read(InputNama),
    gabung_string(InputNama, '.txt', FileName),
    (   file_exists(FileName) ->
        see(FileName),
        reset_game_state,
        baca_semua_baris,
        seen,
        assertz(permainan_aktif),
        restore_deck_and_discard,
        write('Status permainan berhasil dimuat dari '), write(FileName), write('.'), nl,
        giliran(P),
        write('Melanjutkan giliran '), write(P), write('.'), nl
    ;   write('File tidak ditemukan.'), nl
    ).

reset_game_state :-
    retractall(urutan_pemain(_)),
    retractall(giliran(_)),
    retractall(discard_top(_)),
    retractall(warna_aktif(_)),
    retractall(arah_permainan(_)),
    retractall(status_uni(_)),
    retractall(kartu_pemain(_, _)),
    retractall(permainan_aktif),
    retractall(status_tantang(_, _, _, _)),
    retractall(deck(_)),
    retractall(discard_pile(_)).

baca_semua_baris :-
    read(Term),
    (   Term == end_of_file ->
        true
    ;   proses_baris(Term),
        baca_semua_baris
    ).

proses_baris(urutan_pemain : L) :- assertz(urutan_pemain(L)).
proses_baris(giliran : P) :- assertz(giliran(P)).
proses_baris(discard_top : (W-J)) :- assertz(discard_top(kartu(W, J))).
proses_baris(warna_aktif : W) :- assertz(warna_aktif(W)).
proses_baris(arah_permainan : A) :- assertz(arah_permainan(A)).
proses_baris(status_UNI : L) :- restore_status_uni(L).
proses_baris(kartu(P) : L) :-
    kembalikan_format_kartu(L, KartuAsli),
    assertz(kartu_pemain(P, KartuAsli)).

restore_status_uni([]).
restore_status_uni([P|T]) :-
    assertz(status_uni(P)),
    restore_status_uni(T).

kembalikan_format_kartu([], []).
kembalikan_format_kartu([W-J | T], [kartu(W, J) | Rest]) :-
    kembalikan_format_kartu(T, Rest).

restore_deck_and_discard :-
    buat_deck(FullDeck),
    assertz(deck(FullDeck)),
    (   discard_top(Top) ->
        assertz(discard_pile([Top]))
    ;   true
    ).