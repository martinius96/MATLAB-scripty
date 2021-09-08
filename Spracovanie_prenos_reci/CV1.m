%%Vyhotovil: Martin Chlebovec
%%Predmet: Spracovanie a prenos rečových a audio signálov
%%Skupina: Štvrtok: 10:50
%%Zadanie: Samostatná úloha na cvičení
%%Štud. odbor: Počítačové siete
%%Ročník: 1. Ing.
%%Matlab: R2016b

close all; %%zatvorenie figure, okien
clear all; %%premazanie programovych premennych
[y,Fs] = audioread('we were away a year ago_lrr.wav') %%nacitanie audio signalu
Mu = 255;
krok = 0.001 %%krok medzi kvantizačnými úrovňami
time=(1:length(y))/Fs; %%casova oblast s rovnakym poctom hodnot ako audio signal
time = reshape(time,[30473,1]) %%pretvorenie matice na riadkovu zo stlpcovej
figure %%okno pre ploty, grafy
ax1 = subplot(3,1,1); %%subplot pre prvy graf
plot(time,y,'r'); %%vykreslenie čiarového grafu červenou farbou
grid on; %%zapnute mriezkovanie
title('Pôvodný signál') %%popis grafu
xlabel('Čas (s)'); %%popis osi x
ylabel('Výchylka'); %%popis osi y
maximum = max(y) %%maximalna vychylka audio signalu
minimum = min(y) %%minimalna vychylka audio signalu

%%kvantizacne urovne, kvantizacne (funkcne) hodnoty, funkcia quantiz s
%%parametrami existujuceho signalu s menitelnym krokom kvantizacnych urovni
%%platí --> codebook = partition + krok
compsig = compand(y,Mu,maximum,'mu/compressor');
[index,quants] = quantiz(compsig,minimum:krok:maximum,minimum:krok:maximum+krok);
newsig = compand(quants,Mu,max(quants),'mu/expander');
newsig = reshape(newsig,[30473,1])
distor2 = sum((newsig-y).^2)/length(y);

%[index,quants] = quantiz(y,minimum:krok:maximum,minimum:krok:maximum+krok)
quants = reshape(quants,[30473,1]) %%pretvorenie matice na riadkovu zo stlpcovej
hold on %%funkcia pre pockanie s vypisom grafov
ax2 = subplot(3,1,2); %%druhy podgraf
plot(time,quants,'b'); %%vykreslenie čiarového grafu modrou farbou
grid on; %%zapnute mriezkovanie
title('Kompresovaný signál') %%popis grafu
xlabel('Čas (s)'); %%popis osi x
ylabel('Výchylka'); %%popis osi y
ax3 = subplot(3,1,3); %%treti podgraf
plot(time,newsig,'g'); %%vykreslenie čiarového grafu zelenou farbou
grid on; %%zapnute mriezkovanie
title('Rekonštruovaný (expandovaný) signál') %%popis grafu
xlabel('Čas (s)'); %%popis osi x
ylabel('Výchylka'); %%popis osi y
linkaxes([ax1,ax2,ax3],'xy') %%synchronizacia osi x a y pre vsetky podgrafy
sound(y,Fs); %%prehraj audio signal
pause(1.9) %%pockaj 1.9 sekundy
sound(quants,Fs); %%prehraj audio signal
pause(1.9) %%pockaj 1.9 sekundy
sound(newsig,Fs); %%prehraj audio signal
urovne_povodny_signal = unique(y); %%pocet kvantizacnych urovni (funkcnych hodnot) povodneho signalu
urovne_kompresovany_signal = unique(quants); %%pocet kvantizacnych urovni (funkcnych hodnot) kompresovaneho signalu
urovne_rekonstruovany_signal = unique(newsig); %%pocet kvantizacnych urovni (funkcnych hodnot) rekonstruovaneho signalu
