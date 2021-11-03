%%Vyhotovil: Martin Chlebovec, Tomáš Balog
%%Predmet: Číslicové spracovanie signálov
%%Skupina: Utorok: 9:10
%%Zadanie: Frekvenčné spektrum a vzorkovanie signálu
%%Štud. odbor: Počítačové siete
%%Ročník: 1. Ing.
%%Matlab: R2016b
%%Popis:
%%Program pre vzorkovanie signálu obsahuje generovanie náhodnej časovej oblasti, náhodnej max. frekvencie signálu a následne aj výsledného analógového (spojitého) signálu. 
%%V programe je možné definovať vzorkovaciu frekvenciu (nastavená 2*fmax a 3*fmax). 
%%Program je ďalej zapísaný funkcionálne, t.j. na základe definovanej vzorkovacej frekvencie sa vykoná proces vzorkovania.
%%Pôvodný signál, hodnoty signálu vo vzorkovacej perióde a následne aj spojitý vzorkovaný signál je vykreslený do pravouhlého súradnicového systému. 
%%Celý program je navrhnutý v diskrétnej oblasti pre čas (t) - (x-os) začína v bode 0. 
%%V grafe je vyznačená aj vzorkovacia perióda (resp. funkčná vzorkovaná hodnota pôvodného signálu).

%%Vystup programu: https://i.imgur.com/iMuAkMc.png
%%Clanok k projektu: http://deadawp.blog.sector.sk/blogclanok/13178/vzorkovanie-signalu-matlab.htm

close all; %% zatvor figure, okno
clear all; %% Vymaž premenné a ich hodnoty
rng shuffle %% náhodný generátor čísel, časový - true random generator


tmax = randi([1 10]) %%generuj max. časovu oblasť od do
t = 0:0.1:tmax; %%vytvor maticove pole
f_max = randi([1 5]) %%generuj max frekvenciu (amplitúdu)

figure(1) %%vytvor jedno okno pre grafy
%%generuj nahodnu maticu spojitych signalov (analógový signál)
signal = (f_max)*rand(1,length(t));

%%podgraf
subplot(7,1,1)
%%vykreslenie spojitej krivky zelenej farby (generovaný signál)
plot(t,signal,'-g');
title('Náhodne generovaný analógový singál'); %%Nadpis grafu
xlabel('Čas (s)'); %Popis osi x
ylabel('Frekv. (Hz)'); %Popis osi y
hold on
grid %%hodnoty x a y osí
f_vzorkovacia = 2*f_max %%vzorkovacia frekvencia 2*fmax
f_vzorkovacia3 = 3*f_max %%vzorkovacia frekvencia 3*fmax
f_vzorkovacia10 = 10*f_max %%vzorkovacia frekvencia 10*fmax

T_vzorkovacia = 1/f_vzorkovacia %vzorkovacia perioda pre 2*fmax
T_vzorkovacia3 = 1/f_vzorkovacia3 %vzorkovacia perioda pre 3*fmax
T_vzorkovacia10 = 1/f_vzorkovacia10 %vzorkovacia perioda pre 10*fmax

%%vzorkovacie kroky z diskretnej hodnoty 0 - max. casova hodnota signalu
kroky = 0:T_vzorkovacia:max(t)
kroky3 = 0:T_vzorkovacia3:max(t)
kroky10 = 0:T_vzorkovacia10:max(t)
%%interpolacia - prienik funkcnych hodnot signalu v casovych bodoch periody
vzorkovanie_body = interp1(t,signal,kroky);
vzorkovanie_body3 = interp1(t,signal,kroky3);
vzorkovanie_body10 = interp1(t,signal,kroky10);
hold on

subplot(7,1,2) %%podgraf
%%čiarové reprezentácie funkčných hodnôt s bodmi amplitúdy vzorkovania
stem(kroky,vzorkovanie_body,'Color','b');
hold on
%%úsečka opisujúca periódu vzorkovania medzi 2 vzorkovaniami
plot([kroky(2) kroky(3)],[0 0],'-k','LineWidth',3);
%%ukončovacie body úsečky so znakmi < --- > pre interval
scatter(kroky(2),0,'<','k')
scatter(kroky(3),0,'>','k')
%%popis úsečky s textom Tvz
text((kroky(2)/2+kroky(3))/2,-0.3,'Tvz','Color','black', 'Fontsize', 12);
title('Vzorkovaný signál --> fvz = 2*fmax'); %%nadpis podgrafu
xlabel('Čas (s)'); %Popis osi x
ylabel('Frekv. (Hz)'); %Popis osi y
hold on

subplot(7,1,3) %%podgraf
plot(kroky,vzorkovanie_body,'-b');
title('Priebeh vzorkovaného signálu --> fvz = 2*fmax'); %%nadpis podgrafu
xlabel('Čas (s)'); %Popis osi x
ylabel('Frekv. (Hz)'); %Popis osi y

subplot(7,1,4) %%podgraf
stem(kroky3,vzorkovanie_body3,'Color','r');
hold on
plot([kroky3(2) kroky3(3)],[0 0],'-k','LineWidth',3);
scatter(kroky3(2),0,'<','k')
scatter(kroky3(3),0,'>','k')
text((kroky3(2)/2+kroky3(3))/2,-0.3,'Tvz','Color','black', 'Fontsize', 12);
title('Vzorkovaný signál --> fvz = 3*fmax');
xlabel('Čas (s)'); %Popis osi x
ylabel('Frekv. (Hz)'); %Popis osi y
hold on

subplot(7,1,5) %%podgraf
plot(kroky3,vzorkovanie_body3,'-r'); %vykreslenie spojitej funkcie - krivky
title('Priebeh vzorkovaného signálu --> fvz = 3*fmax');
xlabel('Čas (s)'); %Popis osi x
ylabel('Frekv. (Hz)'); %Popis osi y



subplot(7,1,6) %%podgraf
stem(kroky10,vzorkovanie_body10,'Color','k');
hold on
plot([kroky10(2) kroky10(3)],[0 0],'-k','LineWidth',3);
scatter(kroky10(2),0,'<','k')
scatter(kroky10(3),0,'>','k')
text((kroky10(2)/2+kroky10(3))/2,-0.3,'Tvz','Color','black', 'Fontsize', 12);
title('Vzorkovaný signál --> fvz = 10*fmax');
xlabel('Čas (s)'); %Popis osi x
ylabel('Frekv. (Hz)'); %Popis osi y
hold on

subplot(7,1,7) %%podgraf
plot(kroky10,vzorkovanie_body10,'-k'); %vykreslenie spojitej funkcie - krivky
title('Priebeh vzorkovaného signálu --> fvz = 10*fmax');
xlabel('Čas (s)'); %Popis osi x
ylabel('Frekv. (Hz)'); %Popis osi y
