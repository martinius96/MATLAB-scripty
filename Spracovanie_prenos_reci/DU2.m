%%Vyhotovil: Martin Chlebovec
%%Predmet: Spracovanie a prenos rečových a audio signálov
%%Skupina: Štvrtok: 10:50
%%Zadanie: Domáca úloha 2
%%Štud. odbor: Počítačové siete
%%Ročník: 1. Ing.
%%Matlab: R2016b

close all; %%zatvorenie figure, okien
clear all; %%premazanie programovych premennych
[y,Fs] = audioread('we were away a year ago_lrr.wav') %%nacitanie audio signalu
predictor = [0 0.1]; % y(k)=x(k-1)
maximum = max(y) %%maximalna vychylka audio signalu
minimum = min(y) %%minimalna vychylka audio signalu
time=(1:length(y))/Fs; %%casova oblast s rovnakym poctom hodnot ako audio signal
time = reshape(time,[30473,1]) %%pretvorenie matice na riadkovu zo stlpcovej
krok = 0.01 %%krok medzi kvantizačnými úrovňami
partition = minimum:krok:maximum;
codebook = minimum:krok:maximum+krok;
time=(1:length(y))/Fs; %%casova oblast s rovnakym poctom hodnot ako audio signal
time = reshape(time,[30473,1]) %%pretvorenie matice na riadkovu zo stlpcovej
x = sawtooth(3*y); % Original signal
[indx,quants] = dpcmenco(y,codebook,partition,predictor)
% Quantize x using DPCM.
encodedx = dpcmenco(y,codebook,partition,predictor);
encodedx = reshape(encodedx,[30473,1])
% Try to recover x from the modulated signal.
decodedx = dpcmdeco(encodedx,codebook,predictor);
decodedx = reshape(decodedx,[30473,1])
figure %%okno pre ploty, grafy
ax1 = subplot(4,1,1); %%subplot pre prvy graf
plot(time,y,'r'); %%vykreslenie čiarového grafu červenou farbou
legend('Originálny signál');
ax2 = subplot(4,1,2); %%subplot pre druhy graf
plot(time,encodedx,'b'); %%vykreslenie čiarového grafu červenou farbou
legend('Kvantovaný signál');
ax3 = subplot(4,1,3); %%subplot pre treti graf
plot(time,decodedx,'g'); %%vykreslenie čiarového grafu červenou farbou
legend('Dekódovaný signál');
ax4 = subplot(4,1,4); %%subplot pre stvrty graf
rozdiel = y-decodedx
plot(time,rozdiel,'m'); %%vykreslenie čiarového grafu červenou farbou
legend('Rozdielový signál');
linkaxes([ax1,ax3,ax4],'xy') %%synchronizacia osi x a y pre vsetky podgrafy
distor = sum((x-decodedx).^2)/length(x) % Mean square error
