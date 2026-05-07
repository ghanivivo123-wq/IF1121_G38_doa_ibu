pria(loid).
usia(loid, 135).
wanita(yor).
usia(yor, 132).
menikah(loid, yor).
pria(karma).
usia(karma, 79).
anak(karma, loid).
anak(karma, yor).
wanita(adinda).
usia(adinda, 67).
anak(adinda, loid).
anak(adinda, yor).
menikah(todoroki, adinda).
pria(todoroki).
usia(todoroki, 72).
anak(wiliam, todoroki).
anak(wiliam, adinda).
pria(wiliam).
usia(wiliam, 45).
menikah(wiliam, kawakaze).
wanita(kawakaze).
usia(kawakaze, 37).
anak(umaru, kawakaze).
anak(umaru, wiliam).
usia(umaru, 16).
wanita(umaru).
pria(levi).
usia(levi, 69).
anak(razi, levi).
anak(razi, adinda).
usia(razi, 42).
pria(razi).
menikah(razi, reze).
wanita(reze).
usia(reze, 35).
anak(chopper, reze).
anak(chopper, razi).
usia(chopper, 8).
pria(chopper).
pria(faqih).
usia(faqih, 109).
wanita(karina).
usia(karina, 97).
menikah(faqih, karina).
anak(owen, faqih).
anak(owen, karina).
usia(owen, 64).
pria(owen).
menikah(owen, tsunade).
wanita(tsunade).
usia(tsunade, 46).
anak(fathur, tsunade).
anak(fathur, owen).
usia(fathur, 3).
pria(fathur).
anak(nezuko, tsunade).
anak(nezuko, owen).
usia(nezuko, 11).
wanita(nezuko).
anak(ariana, faqih).
anak(ariana, karina).
usia(ariana, 52).
wanita(ariana).
menikah(zoro, ariana).
pria(zoro).
usia(zoro, 57).
anak(anya, zoro).
anak(anya, ariana).
umur(anya, 7).
wanita(anya).
saudara(X, Y) :- (anak(X, Z), anak(Y, Z), anak(X, A), anak(Y, A), menikah(Z, A), menikah(A, Z), X \= Y, A \= Z);       
                 (anak(X, Z), anak(Y, Z), anak(X, A), anak(Y, B), menikah(Z, A), menikah(A, Z), menikah(Z, B), menikah(B, Z), X \= Y, A \= Z, A \= B, B \= Z).
saudaratiri(X, Y) :- anak(X, Z), anak(Y, Z), anak(X, A), anak(Y, B), A \= B, Z \= A, Z \= B, X \= Y.
sepupu(X, Y) :- anak(X, P1), anak(Y, P2), saudara_kandung(P1, P2), X \= Y.
saudara_kandung(X, Y) :- anak(X, Ayah), anak(Y, Ayah), anak(X, Ibu), anak(Y, Ibu), Ayah \= Ibu, X \= Y.
kakak(X, Y) :- (saudara_kandung(X, Y) ; saudaratiri(X, Y)), usia(X, UX), usia(Y, UY), UX > UY.
keponakan(X, Y) :- anak(X, Z), (saudara_kandung(Z, Y) ; saudaratiri(Z, Y)).
nenek(X, Y) :- wanita(X), anak(Y, P), anak(P, X).
keturunan(X, Y) :- anak(X, Y). 
keturunan(X, Y) :- anak(X, Z), keturunan(Z, Y).
mertua(X, Y) :- menikah(Y, Z), anak(Z, X).
lajang(X) :- \+ menikah(X, _), \+ menikah(_, X).
anaksulung(X) :- anak(X, Y), \+ (anak(Z, Y), usia(Z, UZ), usia(X, UX), Z \= X, UZ > UX).
anakbungsu(X) :- anak(X, Y), \+ (anak(Z, Y), usia(Z, UZ), usia(X, UX), Z \= X, UZ < UX).
anaktunggal(X) :- anak(X, Y), \+ (anak(Z, Y), X \= Z).
yatimpiatu(X) :- \+ anak(X, _).
