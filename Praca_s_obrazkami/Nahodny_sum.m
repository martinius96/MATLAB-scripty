%%Vyhotovil: Martin Chlebovec
%%Predmet: Multimediálne signály v komunikačných sieťach
%%Zadanie: Náhodný šum a jeho vplyv na kvalitu obrázku
%%Štud. odbor: Počítačové siete
%%Ročník: 2. Bc.
%%Matlab: R2016b

%%Popis funkčnosti:
%%Program pracuje s 8-bit obrázkami v čiernobielej palete z dôvodu ľahšej reprezentácie obrázku v 2D matici 512x512 px
%%Program poukazuje na dôležitosť MSB a LSB bitov 8-bitovej reprezentácie pixelu, na ktoré vplýva náhodne generovaný šum
%%Ak šum ovplyvní MSB bit, dochádza k zníženiu jasu pixelu o 50% (128 bitov), ak ovplyvní LSB bit, dôjde k zníženiu jasu o 2,56% (1 bit)
%%Vizualizácia pôvodných a ovplyvnených obrázkov (so zohľadnením každého pozmeneného bitu šumom samostatne), vizualizácia finálneho šumového obrázka
%%Výpočet MSE (Strednej kvadratickej chyby) a PSNR (Pomer energie pôvodného obrázka a šumu)

%%Vystup programu: https://i.imgur.com/3xoxrcP.png
%%Clanok k projektu: http://deadawp.blog.sector.sk/blogclanok/13161/sum-v-8-bitovych-obrazoch-matlab.htm

%%vymaz figure a premenne
clear all;
close all;
%%nacitaj obrazky
obrazok1 = imread('lena512g.bmp');
obrazok2 = imread('barbara512g.bmp');
obrazok3 = imread('girlface512g.bmp');
%%Vygeeneruj maticu
generuj_maticu = uint8(randi([0 1],512*512,1));
%%konverzia dec to bin
bityo1 = de2bi(obrazok1);
bityo2 = de2bi(obrazok2);
bityo3 = de2bi(obrazok3);
%%rozlozenie prveho obrazku
osmystlpec1 = bityo1(:,8); %%MSB
siedmystlpec1 = bityo1(:,7);
siestystlpec1 = bityo1(:,6);
piatystlpec1 = bityo1(:,5);
stvrtystlpec1 = bityo1(:,4);
tretistlpec1 = bityo1(:,3);
druhystlpec1 = bityo1(:,2);
prvystlpec1 = bityo1(:,1);%%LSB
%%rozlozenie druheho obrazku
osmystlpec2 = bityo2(:,8);%%MSB
siedmystlpec2 = bityo2(:,7);
siestystlpec2 = bityo2(:,6);
piatystlpec2 = bityo2(:,5);
stvrtystlpec2 = bityo2(:,4);
tretistlpec2 = bityo2(:,3);
druhystlpec2 = bityo2(:,2);
prvystlpec2= bityo2(:,1);%%LSB
%%rozlozenie tretieho obrazku
osmystlpec3 = bityo3(:,8);%%MSB
siedmystlpec3 = bityo3(:,7);
siestystlpec3 = bityo3(:,6);
piatystlpec3 = bityo3(:,5);
stvrtystlpec3 = bityo3(:,4);
tretistlpec3 = bityo3(:,3);
druhystlpec3 = bityo3(:,2);
prvystlpec3= bityo3(:,1);%%LSB
%%pridanie sumu prvy obrazok
upravenyosmystlpeco1 = osmystlpec1.*generuj_maticu;
upravenysiedmystlpeco1 = siedmystlpec1.*generuj_maticu;
upravenysiestystlpeco1 = siestystlpec1.*generuj_maticu;
upravenypiatystlpeco1 = piatystlpec1.*generuj_maticu;
upravenystvrtystlpeco1 = stvrtystlpec1.*generuj_maticu;
upravenytretistlpeco1 = tretistlpec1.*generuj_maticu;
upravenydruhystlpeco1 = druhystlpec1.*generuj_maticu;
upravenyprvystlpeco1 = prvystlpec1.*generuj_maticu;
%%pridanie sumu druhy obrazok
upravenyosmystlpeco2 = osmystlpec2.*generuj_maticu;
upravenysiedmystlpeco2 = siedmystlpec2.*generuj_maticu;
upravenysiestystlpeco2 = siestystlpec2.*generuj_maticu;
upravenypiatystlpeco2 = piatystlpec2.*generuj_maticu;
upravenystvrtystlpeco2 = stvrtystlpec2.*generuj_maticu;
upravenytretistlpeco2 = tretistlpec2.*generuj_maticu;
upravenydruhystlpeco2 = druhystlpec2.*generuj_maticu;
upravenyprvystlpeco2 = prvystlpec2.*generuj_maticu;
%%pridanie sumu treti obrazok
upravenyosmystlpeco3 = osmystlpec3.*generuj_maticu;
upravenysiedmystlpeco3 = siedmystlpec3.*generuj_maticu;
upravenysiestystlpeco3 = siestystlpec3.*generuj_maticu;
upravenypiatystlpeco3 = piatystlpec3.*generuj_maticu;
upravenystvrtystlpeco3 = stvrtystlpec3.*generuj_maticu;
upravenytretistlpeco3 = tretistlpec3.*generuj_maticu;
upravenydruhystlpeco3 = druhystlpec3.*generuj_maticu;
upravenyprvystlpeco3 = prvystlpec3.*generuj_maticu;
%%hodnoty obrazkov s pridanym sumom po nasobeni maticou
novyo1=[upravenyprvystlpeco1 upravenydruhystlpeco1 upravenytretistlpeco1 upravenystvrtystlpeco1 upravenypiatystlpeco1 upravenysiestystlpeco1 upravenysiedmystlpeco1 upravenyosmystlpeco1]
novyo2=[upravenyprvystlpeco2 upravenydruhystlpeco2 upravenytretistlpeco2 upravenystvrtystlpeco2 upravenypiatystlpeco2 upravenysiestystlpeco2 upravenysiedmystlpeco2 upravenyosmystlpeco2]
novyo3=[upravenyprvystlpeco3 upravenydruhystlpeco3 upravenytretistlpeco3 upravenystvrtystlpeco3 upravenypiatystlpeco3 upravenysiestystlpeco3 upravenysiedmystlpeco3 upravenyosmystlpeco3]
novyo1msb = [prvystlpec1 druhystlpec1 tretistlpec1 stvrtystlpec1 piatystlpec1 siestystlpec1 siedmystlpec1 upravenyosmystlpeco1]
novyo17b = [prvystlpec1 druhystlpec1 tretistlpec1 stvrtystlpec1 piatystlpec1 siestystlpec1 upravenysiedmystlpeco1 osmystlpec1]
novyo16b = [prvystlpec1 druhystlpec1 tretistlpec1 stvrtystlpec1 piatystlpec1 upravenysiestystlpeco1 siedmystlpec1 osmystlpec1]
novyo15b = [prvystlpec1 druhystlpec1 tretistlpec1 stvrtystlpec1 upravenypiatystlpeco1 siestystlpec1 siedmystlpec1 osmystlpec1]
novyo14b = [prvystlpec1 druhystlpec1 tretistlpec1 upravenystvrtystlpeco1 piatystlpec1 siestystlpec1 siedmystlpec1 osmystlpec1]
novyo13b = [prvystlpec1 druhystlpec1 upravenytretistlpeco1 stvrtystlpec1 piatystlpec1 siestystlpec1 siedmystlpec1 osmystlpec1]
novyo12b = [prvystlpec1 upravenydruhystlpeco1 tretistlpec1 stvrtystlpec1 piatystlpec1 siestystlpec1 siedmystlpec1 osmystlpec1]
novyo1lsb = [upravenyprvystlpeco1 druhystlpec1 tretistlpec1 stvrtystlpec1 piatystlpec1 siestystlpec1 siedmystlpec1 osmystlpec1]

%%%%%
novyo2msb = [prvystlpec2 druhystlpec2 tretistlpec2 stvrtystlpec2 piatystlpec2 siestystlpec2 siedmystlpec2 upravenyosmystlpeco2]
novyo27b = [prvystlpec2 druhystlpec2 tretistlpec2 stvrtystlpec2 piatystlpec2 siestystlpec2 upravenysiedmystlpeco2 osmystlpec2]
novyo26b = [prvystlpec2 druhystlpec2 tretistlpec2 stvrtystlpec2 piatystlpec2 upravenysiestystlpeco2 siedmystlpec2 osmystlpec2]
novyo25b = [prvystlpec2 druhystlpec2 tretistlpec2 stvrtystlpec2 upravenypiatystlpeco2 siestystlpec2 siedmystlpec2 osmystlpec2]
novyo24b = [prvystlpec2 druhystlpec2 tretistlpec2 upravenystvrtystlpeco2 piatystlpec2 siestystlpec2 siedmystlpec2 osmystlpec2]
novyo23b = [prvystlpec2 druhystlpec2 upravenytretistlpeco2 stvrtystlpec2 piatystlpec2 siestystlpec2 siedmystlpec2 osmystlpec2]
novyo22b = [prvystlpec2 upravenydruhystlpeco2 tretistlpec2 stvrtystlpec2 piatystlpec2 siestystlpec2 siedmystlpec2 osmystlpec2]
novyo2lsb = [upravenyprvystlpeco2 druhystlpec2 tretistlpec2 stvrtystlpec2 piatystlpec2 siestystlpec2 siedmystlpec2 osmystlpec2]
%%

novyo3msb = [prvystlpec3 druhystlpec3 tretistlpec3 stvrtystlpec3 piatystlpec3 siestystlpec3 siedmystlpec3 upravenyosmystlpeco3]
novyo37b = [prvystlpec3 druhystlpec3 tretistlpec3 stvrtystlpec3 piatystlpec3 siestystlpec3 upravenysiedmystlpeco3 osmystlpec3]
novyo36b = [prvystlpec3 druhystlpec3 tretistlpec3 stvrtystlpec3 piatystlpec3 upravenysiestystlpeco3 siedmystlpec3 osmystlpec3]
novyo35b = [prvystlpec3 druhystlpec3 tretistlpec3 stvrtystlpec3 upravenypiatystlpeco3 siestystlpec3 siedmystlpec3 osmystlpec3]
novyo34b = [prvystlpec3 druhystlpec3 tretistlpec3 upravenystvrtystlpeco3 piatystlpec3 siestystlpec3 siedmystlpec3 osmystlpec3]
novyo33b = [prvystlpec3 druhystlpec3 upravenytretistlpeco3 stvrtystlpec3 piatystlpec3 siestystlpec3 siedmystlpec3 osmystlpec3]
novyo32b = [prvystlpec3 upravenydruhystlpeco3 tretistlpec3 stvrtystlpec3 piatystlpec3 siestystlpec3 siedmystlpec3 osmystlpec3]
novyo3lsb = [upravenyprvystlpeco3 druhystlpec3 tretistlpec3 stvrtystlpec3 piatystlpec3 siestystlpec3 siedmystlpec3 osmystlpec3]

%%prekodovanie z double na uint, zmena na dec cislo z binarky
novyo1ch = uint8(bi2de(novyo1))
novyo2ch = uint8(bi2de(novyo2))
novyo3ch = uint8(bi2de(novyo3))
novyo1lsbch =  uint8(bi2de(novyo1lsb))
novyo1msbch = uint8(bi2de(novyo1msb))
novyo17bch = uint8(bi2de(novyo17b))
novyo16bch = uint8(bi2de(novyo16b))
novyo15bch = uint8(bi2de(novyo15b))
novyo14bch = uint8(bi2de(novyo14b))
novyo13bch = uint8(bi2de(novyo13b))
novyo12bch = uint8(bi2de(novyo12b))

%%%%%
novyo2lsbch =  uint8(bi2de(novyo2lsb))
novyo2msbch = uint8(bi2de(novyo2msb))
novyo27bch = uint8(bi2de(novyo27b))
novyo26bch = uint8(bi2de(novyo26b))
novyo25bch = uint8(bi2de(novyo25b))
novyo24bch = uint8(bi2de(novyo24b))
novyo23bch = uint8(bi2de(novyo23b))
novyo22bch = uint8(bi2de(novyo22b))
%%%%

novyo3lsbch =  uint8(bi2de(novyo3lsb))
novyo3msbch = uint8(bi2de(novyo3msb))
novyo37bch = uint8(bi2de(novyo37b))
novyo36bch = uint8(bi2de(novyo36b))
novyo35bch = uint8(bi2de(novyo35b))
novyo34bch = uint8(bi2de(novyo34b))
novyo33bch = uint8(bi2de(novyo33b))
novyo32bch = uint8(bi2de(novyo32b))

%%pretvorime matice na 512x512px obrazok
zmeneny1 = reshape(novyo1ch,[512,512])
zmeneny2 = reshape(novyo2ch,[512,512])
zmeneny3 = reshape(novyo3ch,[512,512])
zmeneny1lsb = reshape(novyo1lsbch,[512,512])
zmeneny1msb = reshape(novyo1msbch,[512,512])
zmeneny17b = reshape(novyo17bch,[512,512])
zmeneny16b = reshape(novyo16bch,[512,512])
zmeneny15b = reshape(novyo15bch,[512,512])
zmeneny14b = reshape(novyo14bch,[512,512])
zmeneny13b = reshape(novyo13bch,[512,512])
zmeneny12b = reshape(novyo12bch,[512,512])

%%%%%%%%%
zmeneny2lsb = reshape(novyo2lsbch,[512,512])
zmeneny2msb = reshape(novyo2msbch,[512,512])
zmeneny27b = reshape(novyo27bch,[512,512])
zmeneny26b = reshape(novyo26bch,[512,512])
zmeneny25b = reshape(novyo25bch,[512,512])
zmeneny24b = reshape(novyo24bch,[512,512])
zmeneny23b = reshape(novyo23bch,[512,512])
zmeneny22b = reshape(novyo22bch,[512,512])
%%%%%%
%%%%%%%%%
zmeneny3lsb = reshape(novyo3lsbch,[512,512])
zmeneny3msb = reshape(novyo3msbch,[512,512])
zmeneny37b = reshape(novyo37bch,[512,512])
zmeneny36b = reshape(novyo36bch,[512,512])
zmeneny35b = reshape(novyo35bch,[512,512])
zmeneny34b = reshape(novyo34bch,[512,512])
zmeneny33b = reshape(novyo33bch,[512,512])
zmeneny32b = reshape(novyo32bch,[512,512])
%%%%%%
figure(1);
subplot(3,10,1), imshow(obrazok1), title('Original image 1');
subplot(3,10,11), imshow(obrazok2), title('Original image 2');
subplot(3,10,21), imshow(obrazok3), title('Original image 3');
subplot(3,10,10), imshow(zmeneny1), title('Zmeneny 1');
subplot(3,10,20), imshow(zmeneny2), title('Zmeneny 2');
subplot(3,10,30), imshow(zmeneny3), title('Zmeneny 3');
subplot(3,10,2), imshow(zmeneny1lsb), title('Zmeneny 1 LSB');
subplot(3,10,9), imshow(zmeneny1msb), title('Zmeneny 1 MSB');
subplot(3,10,8), imshow(zmeneny17b), title('Zmeneny 1 7b');
subplot(3,10,7), imshow(zmeneny16b), title('Zmeneny 1 6b');
subplot(3,10,6), imshow(zmeneny15b), title('Zmeneny 1 5b');
subplot(3,10,5), imshow(zmeneny14b), title('Zmeneny 1 4b');
subplot(3,10,4), imshow(zmeneny13b), title('Zmeneny 1 3b');
subplot(3,10,3), imshow(zmeneny12b), title('Zmeneny 1 2b');;





subplot(3,10,12), imshow(zmeneny2lsb), title('Zmeneny 2 LSB');
subplot(3,10,19), imshow(zmeneny2msb), title('Zmeneny 2 MSB');
subplot(3,10,18), imshow(zmeneny27b), title('Zmeneny 2 7b');
subplot(3,10,17), imshow(zmeneny26b), title('Zmeneny 2 6b');
subplot(3,10,16), imshow(zmeneny25b), title('Zmeneny 2 5b');
subplot(3,10,15), imshow(zmeneny24b), title('Zmeneny 2 4b');
subplot(3,10,14), imshow(zmeneny23b), title('Zmeneny 2 3b');
subplot(3,10,13), imshow(zmeneny22b), title('Zmeneny 2 2b');;






subplot(3,10,22), imshow(zmeneny3lsb), title('Zmeneny 3 LSB');
subplot(3,10,29), imshow(zmeneny3msb), title('Zmeneny 3 MSB');
subplot(3,10,28), imshow(zmeneny37b), title('Zmeneny 3 7b');
subplot(3,10,27), imshow(zmeneny36b), title('Zmeneny 3 6b');
subplot(3,10,26), imshow(zmeneny35b), title('Zmeneny 3 5b');
subplot(3,10,25), imshow(zmeneny34b), title('Zmeneny 3 4b');
subplot(3,10,24), imshow(zmeneny33b), title('Zmeneny 3 3b');
subplot(3,10,23), imshow(zmeneny32b), title('Zmeneny 3 2b');;


%%Obrazky 1
obr1 = obrazok1;
zmenenyobr1 = zmeneny1;
[r1, s1] = size(obr1);
N1 = r1*s1;
MSE1 = mean((1/N1)*sum(sum(double(obr1)-double(zmenenyobr1)).^2));
PSNR1 = 10*log10((255^2)/MSE1);
%%Obrazky 2
obr2 = obrazok2;
zmenenyobr2 = zmeneny2;
[r2, s2] = size(obr2);
N2 = r2*s2;
MSE2 = mean((1/N2)*sum(sum(double(obr2)-double(zmenenyobr2)).^2));
PSNR2 = 10*log10((255^2)/MSE2);
%%Obrazky 3
obr3 = obrazok3;
zmenenyobr3 = zmeneny3;
[r3, s3] = size(obr3);
N3 = r3*s3;
MSE3 = mean((1/N3)*sum(sum(double(obr3)-double(zmenenyobr3)).^2));
PSNR3 = 10*log10((255^2)/MSE3);
