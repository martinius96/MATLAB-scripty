%%Zadanie: Porovnanie hashov
%%Vytvorte vlastný profil s 8 položkami
%%Vytvorte ďalších 5 profilov pre iné osoby s pozmenenými údajmi
%%Každý údaj preveďte hashovacou funkciou SHA1 na hexadecimálnu reprezentáciu s identickým počtom znakov
%%Percentuálne porovnajte hashe (SHA1)
%%Výsledky porovnania preveďte do grafu

%%Vytvoril: Martin Chlebovec


close all;  
clear all;
sha1hasher = System.Security.Cryptography.SHA1Managed;
N = [0;1;2;3;4;5;6;7];
Hodnoty = {'Meno';'Práca';'Adresa domov';'Adresa práca';'Obchod 1';'Obchod 2';'Č linky -> práca';'ID zariadenia'};
Vlastny_profil = {'Martin';'Tuke';'SNP';'BN32';'Optima';'Cassovia';'R4';'119'};
Profil1 = {'Marek';'Tuke';'SNP';'BN 8';'Optima';'Billa';'10';'52899'};
Profil2 = {'Alexander';'Optima';'Námestie osloboditeľov';'Timkovičová';'Lidl';'Cassovia';'15';'18989'};
Profil3 = {'Tomáš';'UPJŠ';'Idanská';'Nová Nemocnica 1';'Optima';'Kaufland';'17';'18949'};
Profil4 = {'Kristián';'Tuke';'Zimná';'Letná 9';'1-day';'Fresh';'9';'19987498'};
Profil5 = {'Ján';'USS';'Amfiteáter';'Štúrova 18';'COOP';'Sintra';'6';'61588'};
Vaha = {'000';'001';'010';'011';'100';'101';'110';'111'};
meno1 = char(Vlastny_profil(1));


%ZACIATOK MIEN
profmeno1 = char(Profil1(1));
profmeno2 = char(Profil2(1));
profmeno3 = char(Profil3(1));
profmeno4 = char(Profil4(1));
profmeno5 = char(Profil5(1));

%ZACIATOK PRAC
praca1 = char(Vlastny_profil(2));
profpraca1 = char(Profil1(2));
profpraca2 = char(Profil2(2));
profpraca3 = char(Profil3(2));
profpraca4 = char(Profil4(2));
profpraca5 = char(Profil5(2));

%ZACIATOK ADRIES DOMOVOV
adresadomov1 = char(Vlastny_profil(3));
profadresadomov1 = char(Profil1(3));
profadresadomov2 = char(Profil2(3));
profadresadomov3 = char(Profil3(3));
profadresadomov4 = char(Profil4(3));
profadresadomov5 = char(Profil5(3));

%ZACIATOK ADRIES PRAC
adresapraca1 = char(Vlastny_profil(4));
profadresapraca1 = char(Profil1(4));
profadresapraca2 = char(Profil2(4));
profadresapraca3 = char(Profil3(4));
profadresapraca4 = char(Profil4(4));
profadresapraca5 = char(Profil5(4));

%ZACIATOK MIEN OBCHODOV 1
obchod11 = char(Vlastny_profil(5));
profobchod11 = char(Profil1(5));
profobchod12 = char(Profil2(5));
profobchod13 = char(Profil3(5));
profobchod14 = char(Profil4(5));
profobchod15 = char(Profil5(5));

%ZACIATOK MIEN OBCHODOV 2
obchod21 = char(Vlastny_profil(6));
profobchod21 = char(Profil1(6));
profobchod22 = char(Profil2(6));
profobchod23 = char(Profil3(6));
profobchod24 = char(Profil4(6));
profobchod25 = char(Profil5(6));

%ZACIATOK LINIEK
linka1 = char(Vlastny_profil(7));
proflinka1 = char(Profil1(7));
proflinka2 = char(Profil2(7));
proflinka3 = char(Profil3(7));
proflinka4 = char(Profil4(7));
proflinka5 = char(Profil5(7));

%ZACIATOK ID
id1 = char(Vlastny_profil(8));
profid1 = char(Profil1(8));
profid2 = char(Profil2(8));
profid3 = char(Profil3(8));
profid4 = char(Profil4(8));
profid5 = char(Profil5(8));

%HASH MENO
sha1meno1= uint8(sha1hasher.ComputeHash(uint8(meno1)));
meno1sha1 = reshape(dec2hex(sha1meno1),1,[]);

profsha1meno1= uint8(sha1hasher.ComputeHash(uint8(profmeno1)));
profmeno1sha1 = reshape(dec2hex(profsha1meno1),1,[]);

profsha1meno2= uint8(sha1hasher.ComputeHash(uint8(profmeno2)));
profmeno2sha1 = reshape(dec2hex(profsha1meno2),1,[]);

profsha1meno3= uint8(sha1hasher.ComputeHash(uint8(profmeno3)));
profmeno3sha1 = reshape(dec2hex(profsha1meno3),1,[]);

profsha1meno4= uint8(sha1hasher.ComputeHash(uint8(profmeno4)));
profmeno4sha1 = reshape(dec2hex(profsha1meno4),1,[]);

profsha1meno5= uint8(sha1hasher.ComputeHash(uint8(profmeno5)));
profmeno5sha1 = reshape(dec2hex(profsha1meno5),1,[]);

%HASH PRACA
sha1praca1= uint8(sha1hasher.ComputeHash(uint8(praca1)));
praca1sha1 = reshape(dec2hex(sha1praca1),1,[]);

profsha1praca1= uint8(sha1hasher.ComputeHash(uint8(profpraca1)));
profpraca1sha1 = reshape(dec2hex(profsha1praca1),1,[]);

profsha1praca2= uint8(sha1hasher.ComputeHash(uint8(profpraca2)));
profpraca2sha1 = reshape(dec2hex(profsha1praca2),1,[]);

profsha1praca3= uint8(sha1hasher.ComputeHash(uint8(profpraca3)));
profpraca3sha1 = reshape(dec2hex(profsha1praca3),1,[]);

profsha1praca4= uint8(sha1hasher.ComputeHash(uint8(profpraca4)));
profpraca4sha1 = reshape(dec2hex(profsha1praca4),1,[]);

profsha1praca5= uint8(sha1hasher.ComputeHash(uint8(profpraca5)));
profpraca5sha1 = reshape(dec2hex(profsha1praca5),1,[]);

%HASH ADRESA DOMOV
sha1adresadomov1= uint8(sha1hasher.ComputeHash(uint8(adresadomov1)));
adresadomov1sha1 = reshape(dec2hex(sha1adresadomov1),1,[]);

profsha1adresadomov1= uint8(sha1hasher.ComputeHash(uint8(profadresadomov1)));
profadresadomov1sha1 = reshape(dec2hex(profsha1adresadomov1),1,[]);

profsha1adresadomov2= uint8(sha1hasher.ComputeHash(uint8(profadresadomov2)));
profadresadomov2sha1 = reshape(dec2hex(profsha1adresadomov2),1,[]);

profsha1adresadomov3= uint8(sha1hasher.ComputeHash(uint8(profadresadomov3)));
profadresadomov3sha1 = reshape(dec2hex(profsha1adresadomov3),1,[]);

profsha1adresadomov4= uint8(sha1hasher.ComputeHash(uint8(profadresadomov4)));
profadresadomov4sha1 = reshape(dec2hex(profsha1adresadomov4),1,[]);

profsha1adresadomov5= uint8(sha1hasher.ComputeHash(uint8(profadresadomov5)));
profadresadomov5sha1 = reshape(dec2hex(profsha1adresadomov5),1,[]);

%HASH ADRESA PRACA
sha1adresapraca1= uint8(sha1hasher.ComputeHash(uint8(adresapraca1)));
adresapraca1sha1 = reshape(dec2hex(sha1adresapraca1),1,[]);

profsha1adresapraca1= uint8(sha1hasher.ComputeHash(uint8(profadresapraca1)));
profadresapraca1sha1 = reshape(dec2hex(profsha1adresapraca1),1,[]);

profsha1adresapraca2= uint8(sha1hasher.ComputeHash(uint8(profadresapraca2)));
profadresapraca2sha1 = reshape(dec2hex(profsha1adresapraca2),1,[]);

profsha1adresapraca3= uint8(sha1hasher.ComputeHash(uint8(profadresapraca3)));
profadresapraca3sha1 = reshape(dec2hex(profsha1adresapraca3),1,[]);

profsha1adresapraca4= uint8(sha1hasher.ComputeHash(uint8(profadresapraca4)));
profadresapraca4sha1 = reshape(dec2hex(profsha1adresapraca4),1,[]);

profsha1adresapraca5= uint8(sha1hasher.ComputeHash(uint8(profadresapraca5)));
profadresapraca5sha1 = reshape(dec2hex(profsha1adresapraca5),1,[]);

%HASH OBCHOD 1
sha1obchod11= uint8(sha1hasher.ComputeHash(uint8(obchod11)));
obchod11sha1 = reshape(dec2hex(sha1obchod11),1,[]);

profsha1obchod11= uint8(sha1hasher.ComputeHash(uint8(profobchod11)));
profobchod11sha1 = reshape(dec2hex(profsha1obchod11),1,[]);

profsha1obchod12= uint8(sha1hasher.ComputeHash(uint8(profobchod12)));
profobchod12sha1 = reshape(dec2hex(profsha1obchod12),1,[]);

profsha1obchod13= uint8(sha1hasher.ComputeHash(uint8(profobchod13)));
profobchod13sha1 = reshape(dec2hex(profsha1obchod13),1,[]);

profsha1obchod14= uint8(sha1hasher.ComputeHash(uint8(profobchod14)));
profobchod14sha1 = reshape(dec2hex(profsha1obchod14),1,[]);

profsha1obchod15 = uint8(sha1hasher.ComputeHash(uint8(profobchod15)));
profobchod15sha1 = reshape(dec2hex(profsha1obchod15),1,[]);

%HASH OBCHOD 2
sha1obchod21= uint8(sha1hasher.ComputeHash(uint8(obchod21)));
obchod21sha1 = reshape(dec2hex(sha1obchod21),1,[]);

profsha1obchod21= uint8(sha1hasher.ComputeHash(uint8(profobchod21)));
profobchod21sha1 = reshape(dec2hex(profsha1obchod21),1,[]);

profsha1obchod22= uint8(sha1hasher.ComputeHash(uint8(profobchod22)));
profobchod22sha1 = reshape(dec2hex(profsha1obchod22),1,[]);

profsha1obchod23= uint8(sha1hasher.ComputeHash(uint8(profobchod23)));
profobchod23sha1 = reshape(dec2hex(profsha1obchod23),1,[]);

profsha1obchod24= uint8(sha1hasher.ComputeHash(uint8(profobchod24)));
profobchod24sha1 = reshape(dec2hex(profsha1obchod24),1,[]);

profsha1obchod25= uint8(sha1hasher.ComputeHash(uint8(profobchod25)));
profobchod25sha1 = reshape(dec2hex(profsha1obchod25),1,[]);

%HASH LINKA
sha1linka1= uint8(sha1hasher.ComputeHash(uint8(linka1)));
linka1sha1 = reshape(dec2hex(sha1linka1),1,[]);

profsha1linka1= uint8(sha1hasher.ComputeHash(uint8(proflinka1)));
proflinka1sha1 = reshape(dec2hex(profsha1linka1),1,[]);

profsha1linka2= uint8(sha1hasher.ComputeHash(uint8(proflinka2)));
proflinka2sha1 = reshape(dec2hex(profsha1linka2),1,[]);

profsha1linka3= uint8(sha1hasher.ComputeHash(uint8(proflinka3)));
proflinka3sha1 = reshape(dec2hex(profsha1linka3),1,[]);

profsha1linka4= uint8(sha1hasher.ComputeHash(uint8(proflinka4)));
proflinka4sha1 = reshape(dec2hex(profsha1linka4),1,[]);

profsha1linka5= uint8(sha1hasher.ComputeHash(uint8(proflinka5)));
proflinka5sha1 = reshape(dec2hex(profsha1linka5),1,[]);

%HASH ID
sha1id1= uint8(sha1hasher.ComputeHash(uint8(id1)));
id1sha1 = reshape(dec2hex(sha1id1),1,[]);

profsha1id1= uint8(sha1hasher.ComputeHash(uint8(profid1)));
profid1sha1 = reshape(dec2hex(profsha1id1),1,[]);

profsha1id2= uint8(sha1hasher.ComputeHash(uint8(profid2)));
profid2sha1 = reshape(dec2hex(profsha1id2),1,[]);

profsha1id3= uint8(sha1hasher.ComputeHash(uint8(profid3)));
profid3sha1 = reshape(dec2hex(profsha1id3),1,[]);

profsha1id4= uint8(sha1hasher.ComputeHash(uint8(profid4)));
profid4sha1 = reshape(dec2hex(profsha1id4),1,[]);

profsha1id5= uint8(sha1hasher.ComputeHash(uint8(profid5)));
profid5sha1 = reshape(dec2hex(profsha1id5),1,[]);

% HASH udaje v poli
Hash = {meno1sha1;praca1sha1;adresadomov1sha1;adresapraca1sha1;obchod11sha1;obchod21sha1;linka1sha1;id1sha1};
Hash1 = {profmeno1sha1;profpraca1sha1;profadresadomov1sha1;profadresapraca1sha1;profobchod11sha1;profobchod21sha1;proflinka1sha1;profid1sha1};
Hash2 = {profmeno2sha1;profpraca2sha1;profadresadomov2sha1;profadresapraca2sha1;profobchod12sha1;profobchod22sha1;proflinka2sha1;profid2sha1};
Hash3 = {profmeno3sha1;profpraca3sha1;profadresadomov3sha1;profadresapraca3sha1;profobchod13sha1;profobchod23sha1;proflinka3sha1;profid3sha1};
Hash4 = {profmeno4sha1;profpraca4sha1;profadresadomov4sha1;profadresapraca4sha1;profobchod14sha1;profobchod24sha1;proflinka4sha1;profid4sha1};
Hash5 = {profmeno5sha1;profpraca5sha1;profadresadomov5sha1;profadresapraca5sha1;profobchod15sha1;profobchod25sha1;proflinka5sha1;profid5sha1};

% TABULKY
T = table(N,Hodnoty,Vlastny_profil,Vaha,Hash)
T1 = table(N,Hodnoty,Profil1,Vaha,Hash1)
T2 = table(N,Hodnoty,Profil2,Vaha,Hash2)
T3 = table(N,Hodnoty,Profil3,Vaha,Hash3)
T4 = table(N,Hodnoty,Profil4,Vaha,Hash4)
T5 = table(N,Hodnoty,Profil5,Vaha,Hash5)

%CYKLY PRE ZHODNE BITY ZNAKOV
for mena = 1:20
    mena1(mena) =   strcmp(meno1sha1(mena),profmeno1sha1(mena));
    mena2(mena) =   strcmp(meno1sha1(mena),profmeno2sha1(mena));
    mena3(mena) =   strcmp(meno1sha1(mena),profmeno3sha1(mena));
    mena4(mena) =   strcmp(meno1sha1(mena),profmeno4sha1(mena));
    mena5(mena) =   strcmp(meno1sha1(mena),profmeno5sha1(mena));
    end
for praca = 1:20
    prace1(praca) =   strcmp(praca1sha1(praca),profpraca1sha1(praca));
    prace2(praca) =   strcmp(praca1sha1(praca),profpraca2sha1(praca));
    prace3(praca) =   strcmp(praca1sha1(praca),profpraca3sha1(praca));
    prace4(praca) =   strcmp(praca1sha1(praca),profpraca4sha1(praca));
    prace5(praca) =   strcmp(praca1sha1(praca),profpraca5sha1(praca));
end
for domov = 1:20
    domov1(domov) =   strcmp(adresadomov1sha1(domov),profadresadomov1sha1(domov));
    domov2(domov) =   strcmp(adresadomov1sha1(domov),profadresadomov2sha1(domov));
    domov3(domov) =   strcmp(adresadomov1sha1(domov),profadresadomov3sha1(domov));
    domov4(domov) =   strcmp(adresadomov1sha1(domov),profadresadomov4sha1(domov));
    domov5(domov) =   strcmp(adresadomov1sha1(domov),profadresadomov5sha1(domov));
end
for adresaprace = 1:20
    adresaprace1(adresaprace) =   strcmp(adresapraca1sha1(adresaprace),profadresapraca1sha1(adresaprace));
    adresaprace2(adresaprace) =   strcmp(adresapraca1sha1(adresaprace),profadresapraca2sha1(adresaprace));
    adresaprace3(adresaprace) =   strcmp(adresapraca1sha1(adresaprace),profadresapraca3sha1(adresaprace));
    adresaprace4(adresaprace) =   strcmp(adresapraca1sha1(adresaprace),profadresapraca4sha1(adresaprace));
    adresaprace5(adresaprace) =   strcmp(adresapraca1sha1(adresaprace),profadresapraca5sha1(adresaprace));
end
for obchodik1 = 1:20
    obchodiky11(obchodik1) =   strcmp(obchod11sha1(obchodik1),profobchod11sha1(obchodik1));
    obchodiky12(obchodik1) =   strcmp(obchod11sha1(obchodik1),profobchod12sha1(obchodik1));
    obchodiky13(obchodik1) =   strcmp(obchod11sha1(obchodik1),profobchod13sha1(obchodik1));
    obchodiky14(obchodik1) =   strcmp(obchod11sha1(obchodik1),profobchod14sha1(obchodik1));
    obchodiky15(obchodik1) =   strcmp(obchod11sha1(obchodik1),profobchod15sha1(obchodik1));
end
for obchodik2 = 1:20
    obchodiky21(obchodik2) =   strcmp(obchod21sha1(obchodik2),profobchod11sha1(obchodik2));
    obchodiky22(obchodik2) =   strcmp(obchod21sha1(obchodik2),profobchod22sha1(obchodik2));
    obchodiky23(obchodik2) =   strcmp(obchod21sha1(obchodik2),profobchod23sha1(obchodik2));
    obchodiky24(obchodik2) =   strcmp(obchod21sha1(obchodik2),profobchod24sha1(obchodik2));
    obchodiky25(obchodik2) =   strcmp(obchod21sha1(obchodik2),profobchod25sha1(obchodik2));
end
for linky = 1:20
    linky1(linky) =   strcmp(linka1sha1(linky),proflinka1sha1(linky));
    linky2(linky) =   strcmp(linka1sha1(linky),proflinka2sha1(linky));
    linky3(linky) =   strcmp(linka1sha1(linky),proflinka3sha1(linky));
    linky4(linky) =   strcmp(linka1sha1(linky),proflinka4sha1(linky));
    linky5(linky) =   strcmp(linka1sha1(linky),proflinka5sha1(linky));
end

for idcka = 1:20
    idcka1(idcka) =   strcmp(id1sha1(idcka),profid1sha1(idcka));
    idcka2(idcka) =   strcmp(id1sha1(idcka),profid2sha1(idcka));
    idcka3(idcka) =   strcmp(id1sha1(idcka),profid3sha1(idcka));
    idcka4(idcka) =   strcmp(id1sha1(idcka),profid4sha1(idcka));
    idcka5(idcka) =   strcmp(id1sha1(idcka),profid5sha1(idcka));
end
%zhoda mien
zhodamena1sum = sum(mena1(:) == 1);
zhodamena1 = (zhodamena1sum/20)*100;

zhodamena2sum = sum(mena2(:) == 1);
zhodamena2 = (zhodamena2sum/20)*100;

zhodamena3sum = sum(mena3(:) == 1);
zhodamena3 = (zhodamena3sum/20)*100;

zhodamena4sum = sum(mena4(:) == 1);
zhodamena4 = (zhodamena4sum/20)*100;

zhodamena5sum = sum(mena5(:) == 1);
zhodamena5 = (zhodamena5sum/20)*100;

%zhoda prac
zhodaprace1sum = sum(prace1(:) == 1);
zhodaprace1 = (zhodaprace1sum/20)*100;

zhodaprace2sum = sum(prace2(:) == 1);
zhodaprace2 = (zhodaprace2sum/20)*100;

zhodaprace3sum = sum(prace3(:) == 1);
zhodaprace3 = (zhodaprace3sum/20)*100;

zhodaprace4sum = sum(prace4(:) == 1);
zhodaprace4 = (zhodaprace4sum/20)*100;

zhodaprace5sum = sum(prace5(:) == 1);
zhodaprace5 = (zhodaprace5sum/20)*100;

%zhoda adries domov
zhodadomov1sum = sum(domov1(:) == 1);
zhodadomov1 = (zhodadomov1sum/20)*100;

zhodadomov2sum = sum(domov2(:) == 1);
zhodadomov2 = (zhodadomov2sum/20)*100;

zhodadomov3sum = sum(domov3(:) == 1);
zhodadomov3 = (zhodadomov3sum/20)*100;

zhodadomov4sum = sum(domov4(:) == 1);
zhodadomov4 = (zhodadomov4sum/20)*100;

zhodadomov5sum = sum(domov5(:) == 1);
zhodadomov5 = (zhodadomov5sum/20)*100;

%zhoda adries prac
zhodaadresaprace1sum = sum(adresaprace1(:) == 1);
zhodaadresaprace1 = (zhodaadresaprace1sum/20)*100;

zhodaadresaprace2sum = sum(adresaprace2(:) == 1);
zhodaadresaprace2 = (zhodaadresaprace2sum/20)*100;

zhodaadresaprace3sum = sum(adresaprace3(:) == 1);
zhodaadresaprace3 = (zhodaadresaprace3sum/20)*100;

zhodaadresaprace4sum = sum(adresaprace4(:) == 1);
zhodaadresaprace4 = (zhodaadresaprace4sum/20)*100;

zhodaadresaprace5sum = sum(adresaprace5(:) == 1);
zhodaadresaprace5 = (zhodaadresaprace5sum/20)*100;
%zhoda obchodov 1
zhodaobchodiky11sum = sum(obchodiky11(:) == 1);
zhodaobchodiky11 = (zhodaobchodiky11sum/20)*100;

zhodaobchodiky12sum = sum(obchodiky12(:) == 1);
zhodaobchodiky12 = (zhodaobchodiky12sum/20)*100;

zhodaobchodiky13sum = sum(obchodiky13(:) == 1);
zhodaobchodiky13 = (zhodaobchodiky13sum/20)*100;

zhodaobchodiky14sum = sum(obchodiky14(:) == 1);
zhodaobchodiky14 = (zhodaobchodiky14sum/20)*100;

zhodaobchodiky15sum = sum(obchodiky15(:) == 1);
zhodaobchodiky15 = (zhodaobchodiky15sum/20)*100;

%zhoda obchodov 2
zhodaobchodiky21sum = sum(obchodiky21(:) == 1);
zhodaobchodiky21 = (zhodaobchodiky21sum/20)*100;

zhodaobchodiky22sum = sum(obchodiky22(:) == 1);
zhodaobchodiky22 = (zhodaobchodiky22sum/20)*100;

zhodaobchodiky23sum = sum(obchodiky23(:) == 1);
zhodaobchodiky23 = (zhodaobchodiky23sum/20)*100;

zhodaobchodiky24sum = sum(obchodiky24(:) == 1);
zhodaobchodiky24 = (zhodaobchodiky24sum/20)*100;

zhodaobchodiky25sum = sum(obchodiky25(:) == 1);
zhodaobchodiky25 = (zhodaobchodiky25sum/20)*100;

%zhoda liniek
zhodalinky1sum = sum(linky1(:) == 1);
zhodalinky1 = (zhodalinky1sum/20)*100;

zhodalinky2sum = sum(linky2(:) == 1);
zhodalinky2 = (zhodalinky2sum/20)*100;

zhodalinky3sum = sum(linky3(:) == 1);
zhodalinky3 = (zhodalinky3sum/20)*100;

zhodalinky4sum = sum(linky4(:) == 1);
zhodalinky4 = (zhodalinky4sum/20)*100;

zhodalinky5sum = sum(linky5(:) == 1);
zhodalinky5 = (zhodalinky5sum/20)*100;

%zhoda id
zhodaidcka1sum = sum(idcka1(:) == 1);
zhodaidcka1 = (zhodaidcka1sum/20)*100;

zhodaidcka2sum = sum(idcka2(:) == 1);
zhodaidcka2 = (zhodaidcka2sum/20)*100;

zhodaidcka3sum = sum(idcka3(:) == 1);
zhodaidcka3 = (zhodaidcka3sum/20)*100;

zhodaidcka4sum = sum(idcka4(:) == 1);
zhodaidcka4 = (zhodaidcka4sum/20)*100;

zhodaidcka5sum = sum(idcka5(:) == 1);
zhodaidcka5 = (zhodaidcka5sum/20)*100;

%POLIA DAT PRE GRAFY
zhodnostmien = [zhodamena1 zhodamena2 zhodamena3 zhodamena4 zhodamena5];
zhodnostprac = [zhodaprace1 zhodaprace2 zhodaprace3 zhodaprace4 zhodaprace5];
zhodnostdomov = [zhodadomov1 zhodadomov2 zhodadomov3 zhodadomov4 zhodadomov5];
zhodnostadrprace = [zhodaadresaprace1 zhodaadresaprace2 zhodaadresaprace3 zhodaadresaprace4 zhodaadresaprace5]; 
zhodnostobchody1 = [zhodaobchodiky11 zhodaobchodiky12 zhodaobchodiky13 zhodaobchodiky14 zhodaobchodiky15];
zhodnostobchody2 = [zhodaobchodiky21 zhodaobchodiky22 zhodaobchodiky23 zhodaobchodiky24 zhodaobchodiky25];
zhodnostliniek = [zhodalinky1 zhodalinky2 zhodalinky3 zhodalinky4 zhodalinky5];
zhodnostidciek = [zhodaidcka1 zhodaidcka2 zhodaidcka3 zhodaidcka4 zhodaidcka5];

%GRAFY V 2 STLPCOCH
subplot(4,2,1);
bar(zhodnostmien, 'b')
title('% zhodnosť mien')
xlabel('Poradie 1-5');
ylabel('Percentá');
subplot(4,2,2);
bar(zhodnostprac, 'g')
title('% zhodnosť prác')
xlabel('Poradie 1-5');
ylabel('Percentá');
subplot(4,2,3); 
bar(zhodnostdomov, 'r')
title('% zhodnosť adries domov')
xlabel('Poradie 1-5');
ylabel('Percentá');
subplot(4,2,4); 
bar(zhodnostadrprace, 'b')
title('% zhodnosť adries prace')
xlabel('Poradie 1-5');
ylabel('Percentá');
subplot(4,2,5); 
bar(zhodnostobchody1, 'g')
title('% zhodnosť obchodov 1')
xlabel('Poradie 1-5');
ylabel('Percentá');
subplot(4,2,6); 
bar(zhodnostobchody2, 'r')
title('% zhodnosť obchodov 2')
xlabel('Poradie 1-5');
ylabel('Percentá');
subplot(4,2,7); 
bar(zhodnostliniek, 'b')
title('% zhodnosť liniek')
xlabel('Poradie 1-5');
ylabel('Percentá');
subplot(4,2,8); 
bar(zhodnostidciek, 'g')
title('% zhodnosť ID')
xlabel('Poradie 1-5');
ylabel('Percentá');
