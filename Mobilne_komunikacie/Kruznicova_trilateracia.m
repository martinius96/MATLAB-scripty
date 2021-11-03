%%Vyhotovil: Martin Chlebovec
%%Predmet: Lokalizácia v bezdrôtových a mobilných sieťach
%%Skupina: Pondelok 7:30
%%Zadanie č. 6
%%Matlab: R2016b

%%Vypocet kruznicovej trilateracie s 3 bunkovymi stanicami
%%Mobilny terminal umiestneny v strede trojuholnika - pokryty vsetkymi bunkovymi stanicami (rádiomajákmi)
%%Vypocet trilateracie s pridanim chybovosti 5%, 10%, 20% z dovodu prechodu signalu prostredim bez LoS (Line of Sight)

%%Ocakavany vystup programu: https://i.imgur.com/nX5DbZN.png
%%Clanok k projektu: http://deadawp.blog.sector.sk/blogclanok/13283/kruznicova-trilateracia-matlab.htm

close all; %% zatvor figure, okno
clear all; %% Vymaž premenné a ich hodnoty
rng shuffle %% náhodný generátor čísel, založený na čase
velkost_pola=1000; %%veľkosť poľa, max x a y súradnica
RADIOMAJAK1(1) = randi([0,velkost_pola]) %% x-ová súradnica pre rádiomaják 1
RADIOMAJAK1(2) = randi([0,velkost_pola]) %% y-ová súradnica pre rádiomaják 1
RADIOMAJAK2(1) = randi([0,velkost_pola]) %% x-ová súradnica pre rádiomaják 2
RADIOMAJAK2(2) = randi([0,velkost_pola]) %% y-ová súradnica pre rádiomaják 2
rozdiel12x = abs(RADIOMAJAK1(1)-RADIOMAJAK2(1)) %%rozdiel x-ových súradníc rádiomajákov 1 a 2
rozdiel12y = abs(RADIOMAJAK1(2)-RADIOMAJAK2(2)) %%rozdiel y-ových súradníc rádiomajákov 1 a 2

%%vzdialenosť medzi rádiomajákom 1 a 2 v metroch, vyjadrenie cez Pytagorovu
%%vetu v pravouhlom súradnícovom systéme
vzdialenost12 = round(sqrt((rozdiel12x^2)+(rozdiel12y^2)),2)

%%pokým je vzdialenosť menšia ako 400 metrov, opakuj generovanie súradníc,
%%výpočet vzdialenosti, porovnaj
while (vzdialenost12 < 400 || vzdialenost12 > 1000 )
RADIOMAJAK2(1) = randi([0,velkost_pola])
RADIOMAJAK2(2) = randi([0,velkost_pola])
rozdiel12x = abs(RADIOMAJAK1(1)-RADIOMAJAK2(1))
rozdiel12y = abs(RADIOMAJAK1(2)-RADIOMAJAK2(2))
vzdialenost12 = round(sqrt((rozdiel12x^2)+(rozdiel12y^2)),2)
end
RADIOMAJAK3(1) = randi([0,velkost_pola]) %% x-ová súradnica pre rádiomaják 3
RADIOMAJAK3(2) = randi([0,velkost_pola]) %% y-ová súradnica pre rádiomaják 1

%%rozdiel súradníc rádiomajáku 3 od rádiomajákov 1 a 2
rozdiel13x = abs(RADIOMAJAK1(1)-RADIOMAJAK3(1))
rozdiel13y = abs(RADIOMAJAK1(2)-RADIOMAJAK3(2))
vzdialenost13 = round(sqrt((rozdiel13x^2)+(rozdiel13y^2)),2)
rozdiel23x = abs(RADIOMAJAK2(1)-RADIOMAJAK3(1))
rozdiel23y = abs(RADIOMAJAK2(2)-RADIOMAJAK3(2))
vzdialenost23 = round(sqrt((rozdiel23x^2)+(rozdiel23y^2)),2)
%%obdobný cyklus pre porovnanie vzdialenosti s už existujúcimi rádiomajákmi
%%ak je vzdialenosť k jednému, alebo obom rádiomajákom menej ako 400m,
%%opakuj cyklus, generovanie, prepočet vzdialenosti
while (vzdialenost13 < 400 || vzdialenost23 < 400 || vzdialenost23 > 1000 || vzdialenost13 > 1000)
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
text((RADIOMAJAK1(1)+x_suradnica)/2,(RADIOMAJAK1(2)+y_suradnica)/2,meter1_bod,'Color','red', 'Fontsize', 10);
text((RADIOMAJAK2(1)+x_suradnica)/2,(RADIOMAJAK2(2)+y_suradnica)/2,meter2_bod,'Color','red', 'Fontsize', 10);
text((RADIOMAJAK3(1)+x_suradnica)/2,(RADIOMAJAK3(2)+y_suradnica)/2,meter3_bod,'Color','red', 'Fontsize', 10);

%%vykreslenie ciernych ciarkovanych ciar medzi vrcholmi
plot(usecka12,usecka21,'--k');
plot(usecka13,usecka31,'--k');
plot(usecka23,usecka32,'--k');

%%prevedenie cisla na text a format so zatvorkami pre vypis
meter12 = ['(',num2str(vzdialenost12),')'];
meter13 = ['(',num2str(vzdialenost13),')'];
meter23 = ['(',num2str(vzdialenost23),')'];

%%vykreslenie vzdialenosti jednotlivych vrcholov (zakladnovych stanic)
text((RADIOMAJAK1(1)+RADIOMAJAK2(1))/2,(RADIOMAJAK1(2)+RADIOMAJAK2(2))/2,meter12, 'Fontsize', 10);
text((RADIOMAJAK1(1)+RADIOMAJAK3(1))/2,(RADIOMAJAK1(2)+RADIOMAJAK3(2))/2,meter13, 'Fontsize', 10);
text((RADIOMAJAK2(1)+RADIOMAJAK3(1))/2,(RADIOMAJAK2(2)+RADIOMAJAK3(2))/2,meter23, 'Fontsize', 10);

%% chyba merania 5%
R1 = 1.05*(str2num(meter1_bod))
R2 = 1.05*(str2num(meter2_bod))
R3 = 1.05*(str2num(meter3_bod))
%% chyba merania 10%
R4 = 1.10*(str2num(meter1_bod))
R5 = 1.10*(str2num(meter2_bod))
R6 = 1.10*(str2num(meter3_bod))
%% chyba merania 20%
R7 = 1.20*(str2num(meter1_bod))
R8 = 1.20*(str2num(meter2_bod))
R9 = 1.20*(str2num(meter3_bod))

%% vypocet a vykreslenie kruznice vsetkych radiomajakov pre 5% chybu
priamka1 = 0:0.001:2*pi;
kruh1x = R1 * cos(priamka1) + RADIOMAJAK1(1);
kruh1y = R1 * sin(priamka1) + RADIOMAJAK1(2);
kruh1 = plot(kruh1x, kruh1y,'-r');
priamka2 = 0:0.001:2*pi;
kruh2x = R2 * cos(priamka2) + RADIOMAJAK2(1);
kruh2y = R2 * sin(priamka2) + RADIOMAJAK2(2);
kruh2 = plot(kruh2x, kruh2y,'-r');
priamka3 = 0:0.001:2*pi;
kruh3x = R3 * cos(priamka3) + RADIOMAJAK3(1);
kruh3y = R3 * sin(priamka3) + RADIOMAJAK3(2);
kruh3 = plot(kruh3x, kruh3y,'-r');

%% vypocet a vykreslenie kruznice vsetkych radiomajakov pre 10% chybu
priamka4 = 0:0.001:2*pi;
kruh4x = R4 * cos(priamka4) + RADIOMAJAK1(1);
kruh4y = R4 * sin(priamka4) + RADIOMAJAK1(2);
kruh4 = plot(kruh4x, kruh4y,'-b');
priamka5 = 0:0.001:2*pi;
kruh5x = R5 * cos(priamka5) + RADIOMAJAK2(1);
kruh5y = R5 * sin(priamka5) + RADIOMAJAK2(2);
kruh5 = plot(kruh5x, kruh5y,'-b');
priamka6 = 0:0.001:2*pi;
kruh6x = R6 * cos(priamka6) + RADIOMAJAK3(1);
kruh6y = R6 * sin(priamka6) + RADIOMAJAK3(2);
kruh6 = plot(kruh6x, kruh6y,'-b');

%% vypocet a vykreslenie kruznice vsetkych radiomajakov pre 20% chybu
priamka7 = 0:0.001:2*pi;
kruh7x = R7 * cos(priamka7) + RADIOMAJAK1(1);
kruh7y = R7 * sin(priamka7) + RADIOMAJAK1(2);
kruh7 = plot(kruh7x, kruh7y,'-g');
priamka8 = 0:0.001:2*pi;
kruh8x = R8 * cos(priamka8) + RADIOMAJAK2(1);
kruh8y = R8 * sin(priamka8) + RADIOMAJAK2(2);
kruh8 = plot(kruh8x, kruh8y,'-g');
priamka9 = 0:0.001:2*pi;
kruh9x = R9 * cos(priamka9) + RADIOMAJAK3(1);
kruh9y = R9 * sin(priamka9) + RADIOMAJAK3(2);
kruh9 = plot(kruh9x, kruh9y,'-g');

%%BOD 1 a 2
F=@(BOD1) ([(BOD1(1)-RADIOMAJAK1(1))^2+(BOD1(2)-RADIOMAJAK1(2))^2-R1^2; ...
(BOD1(1)-RADIOMAJAK2(1))^2+(BOD1(2)-RADIOMAJAK2(2))^2-R2^2]);
opt=optimoptions(@fsolve);
opt.Algorithm='levenberg-marquardt';
opt.Display='off';
BOD1=fsolve(F,[RADIOMAJAK1(1),RADIOMAJAK1(1)+R1],opt);
%%scatter(BOD1(1),BOD1(2),'*','m')
BOD2=fsolve(F,[RADIOMAJAK1(1),RADIOMAJAK1(1)-R1],opt);
%%scatter(BOD2(1),BOD2(2),'*','m')
%%BOD 2 a 3
F3=@(BOD3) ([(BOD3(1)-RADIOMAJAK2(1))^2+(BOD3(2)-RADIOMAJAK2(2))^2-R2^2; ...
(BOD3(1)-RADIOMAJAK3(1))^2+(BOD3(2)-RADIOMAJAK3(2))^2-R3^2]);
opt2=optimoptions(@fsolve);
opt2.Algorithm='levenberg-marquardt';
opt2.Display='off';
BOD3=fsolve(F3,[RADIOMAJAK2(1),RADIOMAJAK2(1)+R2],opt2);
%%scatter(BOD3(1),BOD3(2),'*','m')
BOD4=fsolve(F3,[RADIOMAJAK2(1),RADIOMAJAK2(1)-R2],opt2);
%%scatter(BOD4(1),BOD4(2),'*','m')
%%BOD 1 a 3
F5=@(BOD5) ([(BOD5(1)-RADIOMAJAK3(1))^2+(BOD5(2)-RADIOMAJAK3(2))^2-R3^2; ...
(BOD5(1)-RADIOMAJAK1(1))^2+(BOD5(2)-RADIOMAJAK1(2))^2-R1^2]);
opt3=optimoptions(@fsolve);
opt3.Algorithm='levenberg-marquardt';
opt3.Display='off';
BOD5=fsolve(F5,[RADIOMAJAK3(1),RADIOMAJAK3(1)+R3],opt3);
%%scatter(BOD5(1),BOD5(2),'*','m')
BOD6=fsolve(F5,[RADIOMAJAK3(1),RADIOMAJAK3(1)-R3],opt3);
%%scatter(BOD6(1),BOD6(2),'*','m')
%BOD 1 a 2 10%
F10=@(BOD10) ([(BOD10(1)-RADIOMAJAK1(1))^2+(BOD10(2)-RADIOMAJAK1(2))^2-R4^2; ...
(BOD10(1)-RADIOMAJAK2(1))^2+(BOD10(2)-RADIOMAJAK2(2))^2-R5^2]);
opt10=optimoptions(@fsolve);
opt10.Algorithm='levenberg-marquardt';
opt10.Display='off';
BOD10=fsolve(F,[RADIOMAJAK1(1),RADIOMAJAK1(1)+R4],opt10);
%%scatter(BOD10(1),BOD10(2),'*','b')
BOD11=fsolve(F,[RADIOMAJAK1(1),RADIOMAJAK1(1)-R4],opt10);
%%scatter(BOD11(1),BOD11(2),'*','b')
%BOD 2 a 3 10%
F13=@(BOD13) ([(BOD13(1)-RADIOMAJAK2(1))^2+(BOD13(2)-RADIOMAJAK2(2))^2-R5^2; ...
(BOD13(1)-RADIOMAJAK3(1))^2+(BOD13(2)-RADIOMAJAK3(2))^2-R6^2]);
opt13=optimoptions(@fsolve);
opt13.Algorithm='levenberg-marquardt';
opt13.Display='off';
BOD13=fsolve(F13,[RADIOMAJAK2(1),RADIOMAJAK2(1)+R5],opt13);
%%scatter(BOD13(1),BOD13(2),'*','b')
BOD14=fsolve(F13,[RADIOMAJAK2(1),RADIOMAJAK2(1)-R5],opt13);
%%scatter(BOD14(1),BOD14(2),'*','b')
%BOD 3 a 1 10%
F15=@(BOD15) ([(BOD15(1)-RADIOMAJAK3(1))^2+(BOD15(2)-RADIOMAJAK3(2))^2-R6^2; ...
(BOD15(1)-RADIOMAJAK1(1))^2+(BOD15(2)-RADIOMAJAK1(2))^2-R4^2]);
opt15=optimoptions(@fsolve);
opt15.Algorithm='levenberg-marquardt';
opt15.Display='off';
BOD15=fsolve(F15,[RADIOMAJAK3(1),RADIOMAJAK3(1)+R6],opt15);
%%scatter(BOD15(1),BOD15(2),'*','b')
BOD16=fsolve(F15,[RADIOMAJAK3(1),RADIOMAJAK3(1)-R6],opt15);
%%scatter(BOD16(1),BOD16(2),'*','b')
%%%%%%%%
%BOD 1 a 2 20%
F20=@(BOD20) ([(BOD20(1)-RADIOMAJAK1(1))^2+(BOD20(2)-RADIOMAJAK1(2))^2-R7^2; ...
(BOD20(1)-RADIOMAJAK2(1))^2+(BOD20(2)-RADIOMAJAK2(2))^2-R8^2]);
opt20=optimoptions(@fsolve);
opt20.Algorithm='levenberg-marquardt';
opt20.Display='off';
BOD20=fsolve(F,[RADIOMAJAK1(1),RADIOMAJAK1(1)+R7],opt20);
%%scatter(BOD20(1),BOD20(2),'*','g')
BOD21=fsolve(F,[RADIOMAJAK1(1),RADIOMAJAK1(1)-R7],opt20);
%%scatter(BOD21(1),BOD21(2),'*','g')
%BOD 2 a 3 20%
F23=@(BOD23) ([(BOD23(1)-RADIOMAJAK2(1))^2+(BOD23(2)-RADIOMAJAK2(2))^2-R8^2; ...
(BOD23(1)-RADIOMAJAK3(1))^2+(BOD23(2)-RADIOMAJAK3(2))^2-R9^2]);
opt23=optimoptions(@fsolve);
opt23.Algorithm='levenberg-marquardt';
opt23.Display='off';
BOD23=fsolve(F23,[RADIOMAJAK2(1),RADIOMAJAK2(1)+R8],opt23);
%%scatter(BOD23(1),BOD23(2),'*','g')
BOD24=fsolve(F23,[RADIOMAJAK2(1),RADIOMAJAK2(1)-R8],opt23);
%%scatter(BOD24(1),BOD24(2),'*','g')
%BOD 3 a 1 20%
F25=@(BOD15) ([(BOD15(1)-RADIOMAJAK3(1))^2+(BOD15(2)-RADIOMAJAK3(2))^2-R9^2; ...
(BOD15(1)-RADIOMAJAK1(1))^2+(BOD15(2)-RADIOMAJAK1(2))^2-R7^2]);
opt25=optimoptions(@fsolve);
opt25.Algorithm='levenberg-marquardt';
opt25.Display='off';
BOD25=fsolve(F25,[RADIOMAJAK3(1),RADIOMAJAK3(1)+R9],opt25);
%%scatter(BOD25(1),BOD25(2),'*','g')
BOD26=fsolve(F25,[RADIOMAJAK3(1),RADIOMAJAK3(1)-R9],opt25);
%%scatter(BOD26(1),BOD26(2),'*','g')
%%%%%%%%%%%%%%%%%%%%%%%%
rozdielbod1x_20 = abs(BOD20(1)-x_suradnica)
rozdielbod1y_20 = abs(BOD20(2)-y_suradnica)
BOD1_vzdialenost_20 = round(sqrt((rozdielbod1x_20^2)+(rozdielbod1y_20^2)),2)
rozdielbod2x_20 = abs(BOD21(1)-x_suradnica)
rozdielbod2y_20 = abs(BOD21(2)-y_suradnica)
BOD2_vzdialenost_20 = round(sqrt((rozdielbod2x_20^2)+(rozdielbod2y_20^2)),2)
if(BOD1_vzdialenost_20<BOD2_vzdialenost_20)
BOD12_20 = BOD1_vzdialenost_20
BOD1_REAL_20 = BOD20
elseif (BOD2_vzdialenost_20<=BOD1_vzdialenost_20)
BOD12_20 = BOD2_vzdialenost_20
BOD1_REAL_20 = BOD21
end
rozdielbod3x_20 = abs(BOD23(1)-x_suradnica)
rozdielbod3y_20 = abs(BOD23(2)-y_suradnica)
BOD3_vzdialenost_20 = round(sqrt((rozdielbod3x_20^2)+(rozdielbod3y_20^2)),2)
rozdielbod4x_20 = abs(BOD24(1)-x_suradnica)
rozdielbod4y_20 = abs(BOD24(2)-y_suradnica)
BOD4_vzdialenost_20 = round(sqrt((rozdielbod4x_20^2)+(rozdielbod4y_20^2)),2)
if(BOD3_vzdialenost_20<BOD4_vzdialenost_20)
BOD23_20 = BOD3_vzdialenost_20
BOD2_REAL_20 = BOD23
elseif (BOD4_vzdialenost_20<=BOD3_vzdialenost_20)
BOD23_20 = BOD4_vzdialenost_20
BOD2_REAL_20 = BOD24
end
rozdielbod5x_20 = abs(BOD25(1)-x_suradnica)
rozdielbod5y_20 = abs(BOD25(2)-y_suradnica)
BOD5_vzdialenost_20 = round(sqrt((rozdielbod5x_20^2)+(rozdielbod5y_20^2)),2)
rozdielbod6x_20 = abs(BOD26(1)-x_suradnica)
rozdielbod6y_20 = abs(BOD26(2)-y_suradnica)
BOD6_vzdialenost_20 = round(sqrt((rozdielbod6x_20^2)+(rozdielbod6y_20^2)),2)
if(BOD6_vzdialenost_20<BOD5_vzdialenost_20)
BOD31_20 = BOD6_vzdialenost_20
BOD3_REAL_20 = BOD26
elseif (BOD5_vzdialenost_20<=BOD6_vzdialenost_20)
BOD31_20 = BOD5_vzdialenost_20
BOD3_REAL_20 = BOD25
end
taznica_20 = [BOD1_REAL_20(1),(BOD2_REAL_20(1)+BOD3_REAL_20(1))/2]
taznicab_20 = [BOD1_REAL_20(2),(BOD2_REAL_20(2)+BOD3_REAL_20(2))/2]
xobjekt_20 = taznica_20(1)-taznica_20(2); %%rozdiel x suradnic
yobjekt_20 = taznicab_20(1)-taznicab_20(2); %%rozdiel y suradnic
x_suradnica_20 = xobjekt_20/3+taznica_20(2);
y_suradnica_20 = yobjekt_20/3+taznicab_20(2);
%%scatter(x_suradnica_20,y_suradnica_20,'*','k'); %%vykresli bod pre 10% (odh. poloha)
%%%%%%%%%%%%%%%%%%%%%%%
rozdielbod1x_10 = abs(BOD10(1)-x_suradnica)
rozdielbod1y_10 = abs(BOD10(2)-y_suradnica)
BOD1_vzdialenost_10 = round(sqrt((rozdielbod1x_10^2)+(rozdielbod1y_10^2)),2)
rozdielbod2x_10 = abs(BOD11(1)-x_suradnica)
rozdielbod2y_10 = abs(BOD11(2)-y_suradnica)
BOD2_vzdialenost_10 = round(sqrt((rozdielbod2x_10^2)+(rozdielbod2y_10^2)),2)
if(BOD1_vzdialenost_10<BOD2_vzdialenost_10)
BOD12_10 = BOD1_vzdialenost_10
BOD1_REAL_10 = BOD10
elseif (BOD2_vzdialenost_10<=BOD1_vzdialenost_10)
BOD12_10 = BOD2_vzdialenost_10
BOD1_REAL_10 = BOD11
end
rozdielbod3x_10 = abs(BOD13(1)-x_suradnica)
rozdielbod3y_10 = abs(BOD13(2)-y_suradnica)
BOD3_vzdialenost_10 = round(sqrt((rozdielbod3x_10^2)+(rozdielbod3y_10^2)),2)
rozdielbod4x_10 = abs(BOD14(1)-x_suradnica)
rozdielbod4y_10 = abs(BOD14(2)-y_suradnica)
BOD4_vzdialenost_10 = round(sqrt((rozdielbod4x_10^2)+(rozdielbod4y_10^2)),2)
if(BOD3_vzdialenost_10<BOD4_vzdialenost_10)
BOD23_10 = BOD3_vzdialenost_10
BOD2_REAL_10 = BOD13
elseif (BOD4_vzdialenost_10<=BOD3_vzdialenost_10)
BOD23_10 = BOD4_vzdialenost_10
BOD2_REAL_10 = BOD14
end
rozdielbod5x_10 = abs(BOD15(1)-x_suradnica)
rozdielbod5y_10 = abs(BOD15(2)-y_suradnica)
BOD5_vzdialenost_10 = round(sqrt((rozdielbod5x_10^2)+(rozdielbod5y_10^2)),2)
rozdielbod6x_10 = abs(BOD16(1)-x_suradnica)
rozdielbod6y_10 = abs(BOD16(2)-y_suradnica)
BOD6_vzdialenost_10 = round(sqrt((rozdielbod6x_10^2)+(rozdielbod6y_10^2)),2)
if(BOD6_vzdialenost_10<BOD5_vzdialenost_10)
BOD31_10 = BOD6_vzdialenost_10
BOD3_REAL_10 = BOD16
elseif (BOD5_vzdialenost_10<=BOD6_vzdialenost_10)
BOD31_10 = BOD5_vzdialenost_10
BOD3_REAL_10 = BOD15
end
taznica_10 = [BOD1_REAL_10(1),(BOD2_REAL_10(1)+BOD3_REAL_10(1))/2]
taznicab_10 = [BOD1_REAL_10(2),(BOD2_REAL_10(2)+BOD3_REAL_10(2))/2]
xobjekt_10 = taznica_10(1)-taznica_10(2); %%rozdiel x suradnic
yobjekt_10 = taznicab_10(1)-taznicab_10(2); %%rozdiel y suradnic
x_suradnica_10 = xobjekt_10/3+taznica_10(2);
y_suradnica_10 = yobjekt_10/3+taznicab_10(2);
%%scatter(x_suradnica_10,y_suradnica_10,'*','k'); %%vykresli bod pre 10% (odh. poloha)
%%%%%%%%%%%%%%%%%%%%%%%
rozdielbod1x = abs(BOD1(1)-x_suradnica)
rozdielbod1y = abs(BOD1(2)-y_suradnica)
BOD1_vzdialenost = round(sqrt((rozdielbod1x^2)+(rozdielbod1y^2)),2)
rozdielbod2x = abs(BOD2(1)-x_suradnica)
rozdielbod2y = abs(BOD2(2)-y_suradnica)
BOD2_vzdialenost = round(sqrt((rozdielbod2x^2)+(rozdielbod2y^2)),2)
if(BOD1_vzdialenost<BOD2_vzdialenost)
BOD12_5 = BOD1_vzdialenost
BOD1_REAL = BOD1
elseif (BOD2_vzdialenost<=BOD1_vzdialenost)
BOD12_5 = BOD2_vzdialenost
BOD1_REAL = BOD2
end
rozdielbod3x = abs(BOD3(1)-x_suradnica)
rozdielbod3y = abs(BOD3(2)-y_suradnica)
BOD3_vzdialenost = round(sqrt((rozdielbod3x^2)+(rozdielbod3y^2)),2)
rozdielbod4x = abs(BOD4(1)-x_suradnica)
rozdielbod4y = abs(BOD4(2)-y_suradnica)
BOD4_vzdialenost = round(sqrt((rozdielbod4x^2)+(rozdielbod4y^2)),2)
if(BOD3_vzdialenost<BOD4_vzdialenost)
BOD23_5 = BOD3_vzdialenost
BOD2_REAL = BOD3
elseif (BOD4_vzdialenost<=BOD3_vzdialenost)
BOD23_5 = BOD4_vzdialenost
BOD2_REAL = BOD4
end
rozdielbod5x = abs(BOD5(1)-x_suradnica)
rozdielbod5y = abs(BOD5(2)-y_suradnica)
BOD5_vzdialenost = round(sqrt((rozdielbod5x^2)+(rozdielbod5y^2)),2)
rozdielbod6x = abs(BOD6(1)-x_suradnica)
rozdielbod6y = abs(BOD6(2)-y_suradnica)
BOD6_vzdialenost = round(sqrt((rozdielbod6x^2)+(rozdielbod6y^2)),2)
if(BOD6_vzdialenost<BOD5_vzdialenost)
BOD31_5 = BOD6_vzdialenost
BOD3_REAL = BOD6
elseif (BOD5_vzdialenost<=BOD6_vzdialenost)
BOD31_5 = BOD5_vzdialenost
BOD3_REAL = BOD5
end
taznica_5 = [BOD1_REAL(1),(BOD2_REAL(1)+BOD3_REAL(1))/2]
taznicab_5 = [BOD1_REAL(2),(BOD2_REAL(2)+BOD3_REAL(2))/2]
xobjekt_5 = taznica_5(1)-taznica_5(2); %%rozdiel x suradnic
yobjekt_5 = taznicab_5(1)-taznicab_5(2); %%rozdiel y suradnic
x_suradnica_5 = xobjekt_5/3+taznica_5(2);
y_suradnica_5 = yobjekt_5/3+taznicab_5(2);
scatter(x_suradnica_5,y_suradnica_5,'*','r');
scatter(x_suradnica_10,y_suradnica_10,'*','b');
scatter(x_suradnica_20,y_suradnica_20,'*','g');
%%scatter(x_suradnica_5,y_suradnica_5,'*','g'); %%vykresli bod pre 5% (odh. poloha)
title('1000x1000 metrov'); %%Nadpis grafu
xlabel('m'); %Popis osi x
ylabel('m'); %Popis osi y
%dĺžka osí x a y, 0-1000, pravouhlý systém so začiatkom v ľavom dolnom rohu
axis([0 velkost_pola 0 velkost_pola])
%Textový popis autora, skupiny
bod_pre_5 = ['[',num2str(x_suradnica_5),',',num2str(y_suradnica_5),']'];
bod_pre_10 = ['[',num2str(x_suradnica_10),',',num2str(y_suradnica_10),']'];
bod_pre_20 = ['[',num2str(x_suradnica_20),',',num2str(y_suradnica_20),']'];
rozdiel_5x = abs(x_suradnica-x_suradnica_5)
rozdiel_5y = abs(y_suradnica-y_suradnica_5)
rozdiel_10x = abs(x_suradnica-x_suradnica_10)
rozdiel_10y = abs(y_suradnica-y_suradnica_10)
rozdiel_20x = abs(x_suradnica-x_suradnica_20)
rozdiel_20y = abs(y_suradnica-y_suradnica_20)
VZDIALENOST_5 = round(sqrt((rozdiel_5x^2)+(rozdiel_5y^2)),2)
VZDIALENOST_10 = round(sqrt((rozdiel_10x^2)+(rozdiel_10y^2)),2)
VZDIALENOST_20 = round(sqrt((rozdiel_20x^2)+(rozdiel_20y^2)),2)
uit = uitable();
uit.ColumnName = {'Chyba','Nepresnosť (m)'};
d = {'5%',VZDIALENOST_5;'10%',VZDIALENOST_10;'20%',VZDIALENOST_20;};
uit.Data = d;
uit.Position = [20 20 258 78];
%%vykreslenie vzdialenosti jednotlivych vrcholov (zakladnovych stanic)
%%text((RADIOMAJAK1(1)+RADIOMAJAK2(1))/2,(RADIOMAJAK1(2)+RADIOMAJAK2(2))/2,meter12, 'Fontsize', 10);
legend(['5% - ',bod_pre_5],['10% - ',bod_pre_10],['20% - ',bod_pre_20])
text(0, 1030,'Pondelok: 7:30, Martin Chlebovec (LBMS)', 'Fontsize', 15);
grid on %%vykreslenie hlavných súradnícových čiar (hodnota každých 100 metrov)
grid minor %%vykreslenie sekundárnych čiarkovaných súradnícových čiar, každých 20 metrov
