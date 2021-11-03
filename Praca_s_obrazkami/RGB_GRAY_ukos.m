%%Autor: Martin Chlebovec

%%Funkčnosť scriptu:
%%obrazok 512x512x3 px sa nacita do premennej obrazok, 24-bitova hlbka
%%Vykonajú sa operácie pre GRAYSCALE vstavanou a vlastnou metodou (zoberie sa zložka konkrétnej R, G, alebo B farmy), 
%%alebo sa vykona priemer farieb do 8-bit čiernobielej hodnoty (vyžaduje odkomentovanie fragmentu kodu), zmenšenie obrázku o 50 percent
%%vykona sa transponovanie matice obrazku a nasledne ukos po diagonale, nahradenie bitov za bielu farbu - 255 hodnota kazdeho px

%%Vystup programu: https://i.imgur.com/vtnXRT2.png
%%Clanok k projektu: http://deadawp.blog.sector.sk/blogclanok/13320/praca-s-obrazkami-matlab.htm

close all; %%zatvoriť existujúci figure pri spustení simulácie
clear all; %%vymazať workspace premenné

obrazok = imread('mandrill512c.tiff'); %%načítanie obrázku
polovicny_obrazok = imresize(obrazok, 0.5); % 0.5 násobný resize --> zmensenie o 50%
obrazok_odtiene_sivej = rgb2gray(obrazok)
cervene_spektrum = obrazok(:, :, 1); %%červená zložka obrázku
zelene_spektrum = obrazok(:, :, 2); %%zelená zložka obrázku
modre_spektrum = obrazok(:, :, 3); %%modrá zložka obrázku
grayscale_vystup = (cervene_spektrum + zelene_spektrum + modre_spektrum)/3 %vlastná funkcia pre  RGB to GRAY
%grayscale_vystup = modre_spektrum %8 bitov z danej farebnej urovne
%transponovany_obrazok = permute(obrazok,[2 1 3]) %%transponovany obrazok
%%ekvivalent pre transponovanie
transponovany_obrazok = rot90(obrazok)
[m,n] = size (obrazok) %%načítanie bodov výška x šírka
faktor_skosenia = uint16(m) %%faktor skosenia (viazaný dynamicky na výšku obrázka), pretypovaný na uint16 
obrazok_x = obrazok; %%skopírovanie existujúceho originálneho obrázku do premennej
%%cyklus --> vykreslenie skosenia
for i = 1:faktor_skosenia
   % aplikacia skosenia
   %obrazok_x(i,i:-1:1,1:3)=0; %%čierna farba
   obrazok_x(i,i:-1:1,1:3)=255; %%biela farba
end
imshow(transponovany_obrazok)
a=figure; %% okno - figure pre vykreslenie obrázkov
a.Color='white'; %%Farba - pozadie Figure, vlastnosť pre figure
%sada originálnych obrázkov
subplot(2,5,3), imshow(obrazok), title('Pôvodný obrázok');

%upravené obrázky
subplot(2,5,7), imshow(grayscale_vystup), title('RGB2GRAY - exp.');
subplot(2,5,6), imshow(obrazok_odtiene_sivej), title('RGB2GRAY');
subplot(2,5,8), imshow(polovicny_obrazok), title('Polovičný');
subplot(2,5,10), imshow(obrazok_x), title('Skosený');
subplot(2,5,9), imshow(transponovany_obrazok), title('Transponovaný');

suptitle('Transformácie obrázkov') 
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);  %%fullscreen
