%%Vyhotovil: Martin Chlebovec, Tomáš Balog
%%Predmet: Číslicové spracovanie signálov
%%Skupina: Utorok: 9:10
%%Zadanie: Frekvenčné spektrum
%%Štud. odbor: Počítačové siete
%%Ročník: 1. Ing.
%%Matlab: R2016b

%%Popis: zakreslite spektrum signalu pre menovitú frekvenciu 1 Hz v pravouhlom súradnicovom systéme
%%Vytvorte vizualizáciu funkčných hodnôt spektra pričom počítajte s interpoláciou pre L=2 a L=3
%%Vložte do výsledného spektra L-1 kópii tak, aby nedochádzalo k aliasingu (prekrývaniu spektier)
%%Vystup programu: https://i.imgur.com/ebakxge.png

close all; %% zatvor figure, okno
clear all; %% Vymaž premenné a ich hodnoty
f = 1 %%frekvencia (Hz)
omega_max = 2*pi*f %%uhlova frekvencia
omega_vz = 2*omega_max %%vzorkovacia frekvencia 2*max uhlova frekvencia
omega_vz_2 =  2*omega_vz
omega_vz_3 =  3*omega_vz

%%inverzne hodnoty pre - x os
minus_omega_max = (-1*omega_max)
minus_omega_vz = (-1*omega_vz)
minus_omega_vz_2 =  (-1*omega_vz_2);
minus_omega_vz_3 =  (-1*omega_vz_3);
%%funkcne hodnoty spektra
x = [[(minus_omega_vz_2+minus_omega_vz_3)/2],minus_omega_vz_2,[(minus_omega_vz+minus_omega_vz_2)/2],minus_omega_vz,minus_omega_max,0,omega_max,omega_vz,[(omega_vz+omega_vz_2)/2],omega_vz_2,[(omega_vz_2+omega_vz_3)/2]]
y = [0,f,0,f,0,f,0,f,0,f,0]

ax1 = subplot(5,1,1) %%podgraf
plot(x,y); %%vykreslenie spojitej funkcie z funkcnych hodnot do grafu
%%množina hodnôt x osi, označenie
xticks([ minus_omega_vz_2 minus_omega_vz minus_omega_max 0 omega_max omega_vz omega_vz_2])
xticklabels({'-2*Ovz','-Ovz','-Omax','0','Omax','Ovz','2*Ovz'})
%%množina hodnôt y osi, označenie
yticks([ 0 1])
yticklabels({'0','1'})
title('Spektrum signálu omega-vz = 2*omega-max'); %%Nadpis grafu
xlabel('Uhlová frekvencia (1/s)'); %Popis osi x
ylabel('Amplitúda'); %Popis osi y
hold on %%pockaj (podrz okno grafov pre vykreslenie dalsich)

%%Definicia interpolatoru L =2 a funkcnych hodnot spektra
L_2 = 2
x_2 = [minus_omega_vz_2+minus_omega_max/L_2,minus_omega_vz_2,minus_omega_vz_2-minus_omega_max/L_2,minus_omega_vz+minus_omega_max/L_2,minus_omega_vz,minus_omega_vz-minus_omega_max/L_2,minus_omega_max/L_2,0,omega_max/L_2,omega_vz-omega_max/L_2,omega_vz,omega_vz+omega_max/L_2,omega_vz_2-omega_max/L_2,omega_vz_2,omega_vz_2+omega_max/L_2]
y_2 = [0,f,0,0,f,0,0,f,0,0,f,0,0,f,0]
ax2 = subplot(5,1,2) %%podgraf
%%vykreslenie spektra z funkcnych hodnot pre x a y os
plot(x_2,y_2);
hold on

%%Vykreslenie kópii pre interpolator L = 2 do spektra
plot([(minus_omega_vz_2+minus_omega_vz_3/2)/L_2,(minus_omega_vz_2+minus_omega_vz_3/2)/L_2-minus_omega_max/L_2,(minus_omega_vz_2+minus_omega_vz_3/2)/L_2-minus_omega_max ],[0,1,0],'--r');
plot([(minus_omega_vz+minus_omega_vz_2/2)/L_2-minus_omega_max/L_2,(minus_omega_vz+minus_omega_vz_2/2)/L_2-minus_omega_max,(minus_omega_vz-minus_omega_vz_2/2)/L_2+minus_omega_max/L_2],[0,1,0],'--r');
plot([(omega_vz-omega_vz_2/2)/2+omega_max/L_2,(omega_vz+omega_vz_2/2)/L_2-omega_max,(omega_vz+omega_vz_2/2)/L_2-omega_max/L_2],[0,1,0],'--r');
plot([(omega_vz_2+omega_vz_3/2)/L_2,(omega_vz_2+omega_vz_3/2)/L_2-omega_max/L_2,(omega_vz_2+omega_vz_3/2)/L_2-omega_max ],[0,1,0],'--r');

%%Označenie kópie pre interpolator L = 2 + text
plot([(minus_omega_vz_2+minus_omega_vz_3/2)/L_2 (minus_omega_vz_2+minus_omega_vz_3/2)/L_2-minus_omega_max],[0 0],'-k','LineWidth',3);
scatter((minus_omega_vz_2+minus_omega_vz_3/2)/L_2,0,'<','k')
scatter((minus_omega_vz_2+minus_omega_vz_3/2)/L_2-minus_omega_max,0,'>','k')
plot([(minus_omega_vz_2+minus_omega_vz_3/2)/L_2, (minus_omega_vz_2+minus_omega_vz_3/2)/L_2],[0,1],'--k')
plot([(minus_omega_vz_2+minus_omega_vz_3/2)/L_2-minus_omega_max, (minus_omega_vz_2+minus_omega_vz_3/2)/L_2-minus_omega_max],[0,1],'--k')
text((minus_omega_vz_2+minus_omega_vz_3/2)/L_2,-0.15,' Kópia','Color','black', 'Fontsize', 12);
hold on
%%množina hodnôt x osi, označenie
xticks([ minus_omega_vz_2 minus_omega_vz minus_omega_max 0 omega_max omega_vz omega_vz_2])
xticklabels({'-2*Ovz','-Ovz','-Omax','0','Omax','Ovz','2*Ovz'})
%%množina hodnôt y osi, označenie
yticks([ 0 1])
yticklabels({'0','1'})
title('Interpolácia pre faktor L = 2 --> stlačenie pôvodného spektra na polovicu'); %%Nadpis grafu
xlabel('Uhlová frekvencia (1/s)'); %Popis osi x
ylabel('Amplitúda'); %Popis osi y


%%Definicia interpolatoru L = 3 a funkcnych hodnot spektra
L_3 = 3
x_3 = [minus_omega_vz_2+minus_omega_max/L_3,minus_omega_vz_2,minus_omega_vz_2-minus_omega_max/L_3,minus_omega_vz+minus_omega_max/L_3,minus_omega_vz,minus_omega_vz-minus_omega_max/L_3,minus_omega_max/L_3,0,omega_max/L_3,omega_vz-omega_max/L_3,omega_vz,omega_vz+omega_max/L_3,omega_vz_2-omega_max/L_3,omega_vz_2,omega_vz_2+omega_max/L_3]
y_3 = [0,f,0,0,f,0,0,f,0,0,f,0,0,f,0]
ax3 = subplot(5,1,3) %%podgraf
%%vykreslenie spektra z funkcnych hodnot pre x a y os
plot(x_3,y_3);
hold on
%%Vykreslenie kópii pre interpolator L = 3 do spektra
plot([minus_omega_vz_2-minus_omega_max/L_3,minus_omega_vz_2-minus_omega_max/L_3+omega_max/3,(minus_omega_vz_2-minus_omega_max/L_3)-(minus_omega_max/L_3)*2],[0,1,0],'--r');
plot([(minus_omega_vz_2-minus_omega_max/L_3)-(minus_omega_max/L_3)*2,(minus_omega_vz_2-minus_omega_max/L_3)-(minus_omega_max/L_3)*3,minus_omega_vz+minus_omega_max/L_3],[0,1,0],'--r');
plot([(((minus_omega_vz-minus_omega_max/L_3)-(minus_omega_max/L_3)*2)+(minus_omega_max/L_3)*2),(((minus_omega_vz-minus_omega_max/L_3)-(minus_omega_max/L_3)*2)+(minus_omega_max/L_3)*2/2),((minus_omega_vz-minus_omega_max/L_3)-(minus_omega_max/L_3)*2)],[0,1,0],'--r');
plot([((minus_omega_vz-minus_omega_max/L_3)-(minus_omega_max/L_3)*2),(((minus_omega_vz-minus_omega_max/L_3)-(minus_omega_vz/L_3)*2))+(minus_omega_max/L_3), ((minus_omega_vz-minus_omega_max/L_3)-(minus_omega_vz/L_3)*2)],[0,1,0],'--r');
plot([(((omega_vz-omega_max/L_3)-(omega_max/L_3)*2)+(omega_max/L_3)*2),(((omega_vz-omega_max/L_3)-(omega_max/L_3)*2)+(omega_max/L_3)*2/2),((omega_vz-omega_max/L_3)-(omega_max/L_3)*2)],[0,1,0],'--r');
plot([((omega_vz-omega_max/L_3)-(omega_max/L_3)*2),(((omega_vz-omega_max/L_3)-(omega_vz/L_3)*2))+(omega_max/L_3), ((omega_vz-omega_max/L_3)-(omega_vz/L_3)*2)],[0,1,0],'--r');
plot([omega_vz_2-omega_max/L_3,omega_vz_2-omega_max/L_3+minus_omega_max/3,(omega_vz_2-omega_max/L_3)-(omega_max/L_3)*2],[0,1,0],'--r');
plot([(omega_vz_2-omega_max/L_3)-(omega_max/L_3)*2,(omega_vz_2-omega_max/L_3)-(omega_max/L_3)*3,omega_vz+omega_max/L_3],[0,1,0],'--r');

%%Označenie kópie pre interpolator L = 3 + text
plot([minus_omega_vz_2-minus_omega_max/L_3 minus_omega_vz+minus_omega_max/L_3],[0 0],'-k','LineWidth',3);
scatter(minus_omega_vz_2-minus_omega_max/L_3,0,'<','k')
scatter(minus_omega_vz+minus_omega_max/L_3,0,'>','k')
plot([minus_omega_vz_2-minus_omega_max/L_3, minus_omega_vz_2-minus_omega_max/L_3],[0,1],'--k')
plot([minus_omega_vz+minus_omega_max/L_3, minus_omega_vz+minus_omega_max/L_3],[0,1],'--k')
text((minus_omega_vz_2+minus_omega_vz_3/2)/L_2,-0.15,'Dvojica kópii','Color','black', 'Fontsize', 12);
hold on

%%množina hodnôt x osi, označenie
xticks([ minus_omega_vz_2 minus_omega_vz minus_omega_max 0 omega_max omega_vz omega_vz_2])
xticklabels({'-2*Ovz','-Ovz','-Omax','0','Omax','Ovz','2*Ovz'})
%%množina hodnôt y osi, označenie
yticks([ 0 1])
yticklabels({'0','1'})
title('Interpolácia pre faktor L = 3 --> stlačenie pôvodného spektra na tretinu'); %%Nadpis grafu
xlabel('Uhlová frekvencia (1/s)'); %Popis osi x
ylabel('Amplitúda'); %Popis osi y
linkaxes([ax1,ax2,ax3],'xy'); %%synchronizuj osi x pre kazdy graf
