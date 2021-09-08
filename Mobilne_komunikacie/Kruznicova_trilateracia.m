%%Vyhotovil: Martin Chlebovec
%%Predmet: Lokalizácia v bezdrôtových a mobilných sieťach
%%Skupina: Pondelok 7:30
%%Zadanie č. 7
%%Matlab: R2016b
%%Popis úlohy:
%%Pre hodnoty zo zadania "Mapa_terminalov" vypočítajte čas šírenia signálu od referenčných bodov k mobilnému terminálu pre frekvencie 900MHz a 2.4GHz

close all; %% zatvor figure, okno
clear all; %% Vymaž premenné a ich hodnoty
rng shuffle %% náhodný generátor čísel, založený na čase
velkost_pola=1000; %%veľkosť poľa, max x a y súradnica
RADIOMAJAK1(1) = randi([0,velkost_pola]) %% x-ová súradnica pre rádiomaják 1
RADIOMAJAK1(2) = randi([0,velkost_pola]) %% y-ová súradnica pre rádiomaják 1
RADIOMAJAK2(1) = randi([0,velkost_pola]) %% x-ová súradnica pre rádiomaják 2
RADIOMAJAK2(2) = randi([0,velkost_pola]) %% y-ová súradnica pre rádiomaják 2
rozdiel12x = abs(RADIOMAJAK1(1)-RADIOMAJAK2(1)) %%rozdiel x-ových súradníc
%%rádiomajákov 1 a 2
rozdiel12y = abs(RADIOMAJAK1(2)-RADIOMAJAK2(2)) %%rozdiel y-ových súradníc
%%rádiomajákov 1 a 2
%%vzdialenosť medzi rádiomajákom 1 a 2 v metroch, vyjadrenie cez Pytagorovu
%%vetu v pravouhlom súradnícovom systéme
vzdialenost12 = round(sqrt((rozdiel12x^2)+(rozdiel12y^2)),2)
%%pokým je vzdialenosť menšia ako 400 metrov, opakuj generovanie súradníc,
%%výpočet vzdialenosti, porovnaj
while (vzdialenost12 < 400 || vzdialenost12 > 800 )
RADIOMAJAK2(1) = randi([0,velkost_pola])
RADIOMAJAK2(2) = randi([0,velkost_pola])
rozdiel12x = abs(RADIOMAJAK1(1)-RADIOMAJAK2(1))
rozdiel12y = abs(RADIOMAJAK1(2)-RADIOMAJAK2(2))
vzdialenost12 = round(sqrt((rozdiel12x^2)+(rozdiel12y^2)),2)
end
RADIOMAJAK3(1) = randi([0,velkost_pola]) %% x-ová súradnica pre rádiomaják 3
RADIOMAJAK3(2) = randi([0,velkost_pola]) %% y-ová súradnica pre rádiomaják 1
rozdiel13x = abs(RADIOMAJAK1(1)-RADIOMAJAK3(1))
rozdiel13y = abs(RADIOMAJAK1(2)-RADIOMAJAK3(2))
vzdialenost13 = round(sqrt((rozdiel13x^2)+(rozdiel13y^2)),2)
rozdiel23x = abs(RADIOMAJAK2(1)-RADIOMAJAK3(1))
rozdiel23y = abs(RADIOMAJAK2(2)-RADIOMAJAK3(2))
vzdialenost23 = round(sqrt((rozdiel23x^2)+(rozdiel23y^2)),2)
%%obdobný cyklus pre porovnanie vzdialenosti s už existujúcimi rádiomajákmi
%%ak je vzdialenosť k jednému, alebo obom rádiomajákom menej ako 400m,
%%opakuj cyklus, generovanie, prepočet vzdialenosti
while (vzdialenost13 < 400 || vzdialenost23 < 400 || vzdialenost23 > 800 || vzdialenost13 > 800)
RADIOMAJAK3(1) = randi([0,velkost_pola])
RADIOMAJAK3(2) = randi([0,velkost_pola])
rozdiel13x = abs(RADIOMAJAK1(1)-RADIOMAJAK3(1))
rozdiel13y = abs(RADIOMAJAK1(2)-RADIOMAJAK3(2))
vzdialenost13 = round(sqrt((rozdiel13x^2)+(rozdiel13y^2)),2)
rozdiel23x = abs(RADIOMAJAK2(1)-RADIOMAJAK3(1))
rozdiel23y = abs(RADIOMAJAK2(2)-RADIOMAJAK3(2))
vzdialenost23 = round(sqrt((rozdiel23x^2)+(rozdiel23y^2)),2)
end
%%vykreslenie rádiomajáku č. 1 na os x a y, znázornenie krúžkom červenej
%%farby
scatter(RADIOMAJAK1(1),RADIOMAJAK1(2),'x','r')
SURADNICE_MAJAK1x = num2str(RADIOMAJAK1(1));
SURADNICE_MAJAK1y = num2str(RADIOMAJAK1(2));
%%vypis textu so suradnicami na x+10 a y+15 poziciu, velkosť písma 10
text(RADIOMAJAK1(1)+10, RADIOMAJAK1(2)+15,['[',SURADNICE_MAJAK1x,' ; ',SURADNICE_MAJAK1y,']'], 'Fontsize', 10);
hold on %%počkaj
%%obdobne pre rádiomaják č.2
scatter(RADIOMAJAK2(1),RADIOMAJAK2(2),'x','b')
SURADNICE_MAJAK2x = num2str(RADIOMAJAK2(1));
SURADNICE_MAJAK2y = num2str(RADIOMAJAK2(2));
text(RADIOMAJAK2(1)+10, RADIOMAJAK2(2)+15,['[',SURADNICE_MAJAK2x,' ; ',SURADNICE_MAJAK2y,']'], 'Fontsize', 10);
hold on
%%obdobne pre rádiomaják č.3
scatter(RADIOMAJAK3(1),RADIOMAJAK3(2),'x','g')
SURADNICE_MAJAK3x = num2str(RADIOMAJAK3(1));
SURADNICE_MAJAK3y = num2str(RADIOMAJAK3(2));
text(RADIOMAJAK3(1)+10, RADIOMAJAK3(2)+15,['[',SURADNICE_MAJAK3x,' ; ',SURADNICE_MAJAK3y,']'], 'Fontsize', 10);
usecka12 = [RADIOMAJAK1(1),RADIOMAJAK2(1)] %%x suradnice priamky
usecka21 = [RADIOMAJAK1(2),RADIOMAJAK2(2)] %%y suradnice priamky
usecka13 = [RADIOMAJAK1(1),RADIOMAJAK3(1)]
usecka31 = [RADIOMAJAK1(2),RADIOMAJAK3(2)]
usecka23 = [RADIOMAJAK2(1),RADIOMAJAK3(1)]
usecka32 = [RADIOMAJAK2(2),RADIOMAJAK3(2)]
%%taznica na stred protilahlej usecky, sluzi na vykreslenie 4. bodu
taznica = [RADIOMAJAK1(1),(RADIOMAJAK2(1)+RADIOMAJAK3(1))/2]
taznicab = [RADIOMAJAK1(2),(RADIOMAJAK2(2)+RADIOMAJAK3(2))/2]
%%PYTAGOROVA VETA --> vzdialenost
xobjekt = taznica(1)-taznica(2); %%rozdiel x suradnic
yobjekt = taznicab(1)-taznicab(2); %%rozdiel y suradnic
x_suradnica = xobjekt/3+taznica(2);
y_suradnica = yobjekt/3+taznicab(2);
scatter(x_suradnica,y_suradnica,'*','m'); %%vykresli bod
%%vykreslenie useciek cervenej ciarkovanej farby, od bodu k vrcholom
plot([RADIOMAJAK1(1), x_suradnica],[RADIOMAJAK1(2),y_suradnica],'--r');
plot([RADIOMAJAK2(1), x_suradnica],[RADIOMAJAK2(2),y_suradnica],'--r');
plot([RADIOMAJAK3(1), x_suradnica],[RADIOMAJAK3(2),y_suradnica],'--r');
%%vypocet vzdialenosti medzi 4. bodom a 1. vrcholom
rozdiel1_bod_x = abs(RADIOMAJAK1(1)-x_suradnica)
rozdiel1_bod_y = abs(RADIOMAJAK1(2)-y_suradnica)
vzdialenost1_bod = round(sqrt((rozdiel1_bod_x^2)+(rozdiel1_bod_y^2)),2)
meter1_bod = ['(',num2str(vzdialenost1_bod),')'];
%%vypocet vzdialenosti medzi 4. bodom a 2. vrcholom
rozdiel2_bod_x = abs(RADIOMAJAK2(1)-x_suradnica)
rozdiel2_bod_y = abs(RADIOMAJAK2(2)-y_suradnica)
vzdialenost2_bod = round(sqrt((rozdiel2_bod_x^2)+(rozdiel2_bod_y^2)),2)
meter2_bod = ['(',num2str(vzdialenost2_bod),')'];
%%vypocet vzdialenosti medzi 4. bodom a 3. vrcholom
rozdiel3_bod_x = abs(RADIOMAJAK3(1)-x_suradnica)
rozdiel3_bod_y = abs(RADIOMAJAK3(2)-y_suradnica)
vzdialenost3_bod = round(sqrt((rozdiel3_bod_x^2)+(rozdiel3_bod_y^2)),2)
meter3_bod = ['(',num2str(vzdialenost3_bod),')'];
%%vypis vzdialenosti medzi 4. bodom a vrcholmi trojuholnika
text((RADIOMAJAK1(1)+x_suradnica)/2, (RADIOMAJAK1(2)+y_suradnica)/2,meter1_bod,'Color','red', 'Fontsize', 10);
text((RADIOMAJAK2(1)+x_suradnica)/2, (RADIOMAJAK2(2)+y_suradnica)/2,meter2_bod,'Color','red', 'Fontsize', 10);
text((RADIOMAJAK3(1)+x_suradnica)/2, (RADIOMAJAK3(2)+y_suradnica)/2,meter3_bod,'Color','red', 'Fontsize', 10);
%%vykreslenie ciernych ciarkovanych ciar medzi vrcholmi
plot(usecka12,usecka21,'--k');
plot(usecka13,usecka31,'--k');
plot(usecka23,usecka32,'--k');
%%prevedenie cisla na text a format so zatvorkami pre vypis
meter12 = ['(',num2str(vzdialenost12),')'];
meter13 = ['(',num2str(vzdialenost13),')'];
meter23 = ['(',num2str(vzdialenost23),')'];
%%vykreslenie vzdialenosti jednotlivych vrcholov (zakladnovych stanic)
text((RADIOMAJAK1(1)+RADIOMAJAK2(1))/2, (RADIOMAJAK1(2)+RADIOMAJAK2(2))/2,meter12, 'Fontsize', 10);
text((RADIOMAJAK1(1)+RADIOMAJAK3(1))/2, (RADIOMAJAK1(2)+RADIOMAJAK3(2))/2,meter13, 'Fontsize', 10);
text((RADIOMAJAK2(1)+RADIOMAJAK3(1))/2, (RADIOMAJAK2(2)+RADIOMAJAK3(2))/2,meter23, 'Fontsize', 10);
%%ToA metoda
f_WiFi = 2400000000; %2.4GHz => Hz
f_GSM = 900000000; %900MHz => Hz
rychlost_svetla = 300000000; %rychlost svetla 3*10^8 m/s
lambda_WiFi = rychlost_svetla/f_WiFi; %vlnova dlzka (m)
lambda_GSM = rychlost_svetla/f_GSM; %vlnova dlzka (m)
fazova_rychlost_WiFi = lambda_WiFi*f_WiFi
fazova_rychlost_GSM = lambda_GSM*f_GSM
%%cas vlny medzi referencnou stanicou a terminalom (WiFi frekvencia)
cas1_WiFi = vzdialenost1_bod/fazova_rychlost_WiFi %%sekund
cas2_WiFi = vzdialenost2_bod/fazova_rychlost_WiFi %%sekund
cas3_WiFi = vzdialenost3_bod/fazova_rychlost_WiFi %%sekund
%%cas vlny medzi referencnou stanicou a terminalom (GSM frekvencia)
cas1_GSM = vzdialenost1_bod/fazova_rychlost_GSM %%sekund
cas2_GSM = vzdialenost2_bod/fazova_rychlost_GSM %%sekund
cas3_GSM = vzdialenost3_bod/fazova_rychlost_GSM %%sekund
uit = uitable();
uit.ColumnName = {'REF-->TERMINAL','900MHz','2.4GHz'};
d = {'1. bod-->TER',cas1_GSM, cas1_WiFi;'2. bod-->TER',cas2_GSM, cas2_WiFi;'3. bod-->TER',cas3_GSM, cas3_WiFi;};
uit.Data = d;
uit.Position = [20 20 300 100];
hold on
%%SÚČASTI GRAFU
title('1000x1000 metrov'); %%Nadpis grafu
xlabel('m'); %Popis osi x
ylabel('m'); %Popis osi y
%dĺžka osí x a y, 0-1000, pravouhlý systém so začiatkom v ľavom dolnom rohu
axis([0 velkost_pola 0 velkost_pola])
%Textový popis autora, skupiny
text(0, 1030,'Pondelok: 7:30, Martin Chlebovec (LBMS)', 'Fontsize', 15);
grid on %%vykreslenie hlavných súradnícových čiar (hodnota každých 100 metrov)
grid minor %%vykreslenie sekundárnych čiarkovaných súradnícových čiar, každých 20 metrov
