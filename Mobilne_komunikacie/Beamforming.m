%%Riešitelia: Martin Chlebovec, Tomáš Balog, Matej Bajus
%%Predmet: Mobilné komunikácie
%%Cvičiaci: doc. Ing. Ján Papaj, PhD.
%%Skupina: Utorok 11:00
%%Zadanie č. 7: mmWaves, typy antén, typy komunikácie
%%Matlab: R2016b

%%Výstup programu: https://i.imgur.com/ODuE6AT.png
%%Clanok k projektu: http://deadawp.blog.sector.sk/blogclanok/13309/beamforming-vizualizacia-matlab.htm

%%Simulácia: 
%%Variabilné nastavenie lalokov (Beamov) vysielacou stanicou - Beamforming
%%Prispôsobenie laloku (zúženie lúča) v závislosti od vzdialenosti MT (mob. terminálu) od VS (vysielacej stanice), 
%%predchadzanie interferencii s inymi mobilnymi terminalmi / interferencii sposobenej prechodom signalu prostredim

close all; %%Zatvorenie okien pri každom spustení programu
clear all; %%Vymazanie premenných pri každom spustení programu
rng shuffle %%random generator cisel

pocet_bodov = 60; %%pocet mobilnych terminalov
dosah_vysielacej_stanice = 250 %%dosah vysielacej stanice v metroch
suradnice_vysielacia_stanica = [500 500] %%suradnice vysielacej stanice
randomx = randperm(1000,pocet_bodov) %%nahodne permutacie cisel pre x suradnice MT
randomy = randperm(1000,pocet_bodov) %%nahodne permutacie cisel pre y suradnice MT

plot(suradnice_vysielacia_stanica(1),suradnice_vysielacia_stanica(2),'rO') %%vykresli vysielaciu stanicu
hold on %%pockaj s vykreslenim
priamka1 = 0:0.001:2*pi; %% kružnica
kruh1x = dosah_vysielacej_stanice * cos(priamka1) + suradnice_vysielacia_stanica(1); %%x suradnice kruznice s dosahom m
kruh1y = dosah_vysielacej_stanice * sin(priamka1) + suradnice_vysielacia_stanica(2); %%y suradnice kruznice s dosahom m
kruh1 = plot(kruh1x, kruh1y,'-r'); %%vykreslenie kružnice do pravouhleho suradnicoveho systemu
hold on
h = plot(randomx,randomy,'g*') %%vykreslenie mobilných terminálov (MT) do súradnicového systému
a = get(h,'XData') %%prevzatie x suradnic vsetkych MT z pravouhleho systemu
b = get(h,'YData') %%prevzatie y suradnic vsetkych MT z pravouhleho systemu
hold on
for c = 1:pocet_bodov %%cyklus s inkrementaciou pre pocet vsetkych MT
    rozdielx = abs(a( c)-suradnice_vysielacia_stanica(1)) %%absolutny rozdiel x suradnic MT a vysielacej stanice
    rozdiely = abs(b( c)-suradnice_vysielacia_stanica(2)) %%absolutny rozdiel y suradnic MT a vysielacej stanice
    vzdialenost = round(sqrt((rozdielx^2)+(rozdiely^2)),2) %%vzdialenost MT v metroch od vysielacej stanice (vyuzitie pravouhleho suradnicoveho systemu pre vypocet)
   %%ak je vzdialenost MT menšia / rovná ako dosah vysielacej stanice / 3,
   %%sformuj najväčší beam
     if vzdialenost <= dosah_vysielacej_stanice/3
        plot([suradnice_vysielacia_stanica(1), a( c)],[suradnice_vysielacia_stanica(2), b( c)],'LineWidth', 9);  
    %%ak je vzdialenost MT väčšia ako dosah vysielacej stanice / 3 a zároveň menšia / rovná,
    %%ako dosah vysielacej stanice / 2, sformuj stredný beam
     elseif vzdialenost > dosah_vysielacej_stanice/3 && vzdialenost <= dosah_vysielacej_stanice/2
        plot([suradnice_vysielacia_stanica(1), a( c)],[suradnice_vysielacia_stanica(2), b( c)],'LineWidth', 5);
    %%ak je vzdialenost MT väčšia ako dosah vysielacej stanice / 2 a zároveň menšia / rovná,
    %%ako dosah vysielacej stanice, sformuj úzky beam
     elseif vzdialenost > dosah_vysielacej_stanice/2 && vzdialenost <= dosah_vysielacej_stanice
        plot([suradnice_vysielacia_stanica(1), a( c)],[suradnice_vysielacia_stanica(2), b( c)],'LineWidth', 2);
    end
end
hold on
%%vykreslenie osi pravouhleho suradnicoveho systemu --> 1:1
axis equal
%%os x a y tvorena hodnotami 0 až 1000
axis([0 1000 0 1000])
%%Legenda s označením entít v grafe (pravuholom súradnicovom systéme)
legend('Vysielacia stanica (OMNI)','Dosah vysielacej stanice','Mobilný terminál','Beam (lúč)')
title('1000x1000 metrov - pravouhlý súradnicový systém'); %%Nadpis grafu
xlabel('m'); %Popis osi x
ylabel('m'); %Popis osi y
