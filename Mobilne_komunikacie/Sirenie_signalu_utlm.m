%%Vyhotovil: Martin Chlebovec

%%Zadanie: Vykreslite závislosť výkonu prijatého signálu od vzdialenosti mobiného terminálu od referenčnej stanice. 
%%1. Uvažujme, že referenčná stanica vysiela s výkonom 100mW. Hraničná vzdialenosť terminálu od referenčnej stanice je 1000m. 
%%2. Na výpočet použite vzťah z prednášok (pre voľný priestor). Graf vykreslite modrou farbou. 
%%3. Na výpočet použite Friisov vzťah (voľný priestor, zisk antén =1, straty L sú nulové, frekvencia 2,4GHz). Graf vykreslite červenou farbou. 
%%4. Oba priebehy vykreslite do jedného obrázku. Výkon vyneste v dB. 
%%5. Ak priebehy budú odlišné, analyzujte príčinu a vyjadrite ju stručne niekoľkými vetami v dokumente s názvom Zdôvodnenie:

%%Zdôvodnenie: Funkcia útlmu pre voľný priestor a Frissov vzťah majú takmer rovnaký priebeh signálu vo vzdialenosti 0-1000 metrov, oba majú logaritmický priebeh. 
%%Pri oboch vzťahoch sa využíva jednocestný model šírenia signálu.
%%Friisov vzťah vykazuje väčší útlm - výkon prijatého signálu je na prijímači nižší ako v prípade vzťahu pre voľný priestor.
%%Hlavnou zložkou Friisovho vzťahu je charakteristika vysielacej a prijímacej antény (apertúra, vzdialenosť antén, vlnová dĺžka - obsiahnuté pre pomer Pr/Pt), 
%%nepoužíva smerovosť vo vzťahu pre výpočet.
%%Vzťah pre voľný priestor kombinuje využitie poznatkov o rozptyle elektromagnetickej energie, ktorá závisí od vzdialenosti a činiteľa útlmu, ktorý je konštantný
%% - pre voľný priestor = 2, t.j. 20dB/dekádu, pre miesta s prekážkami 2.5 - 5.5 (šírenie v zastavanom území, lesoch). 
%%Vzťah pre voľný priestor vychádza zo zjednodušenej formuly jednocestného modelu (Gaussov šum) a je menej presný ako Friisov vzťah, ktorý využíva vlastnosti antén.

clear all;
close all;
figure %%nove okno pre zadanie
PtW = 0.1; %vykon vysielacej anteny vo Wattoch
PtdB = 10*log10(PtW); %vykon vysielacej anteny v dB
vzdialenost = [0:1:1000]; %max vzdialenost
f = 2400000000; %2.4GHz => Hz
c = 300000000; %rychlost svetla 3*10^8 m/s
lambda = c/f; %vlnova dlzka (m)
cinitel_ultmu = 2; %pre volny priestor
PrdB = PtdB-10*cinitel_ultmu*log10(vzdialenost) %%vykon prijateho signalu v dB
plot (vzdialenost, PrdB) %%vykresli graf signalu pre volny priestor
hold on
i=0 %%inkrementacna premenna cyklu - predstavuje vzdialenost
while(i<=1000)
if(i==0)
Pr2 = ((lambda/(4*pi*i))^2)*PtW %%vytvor premennu Pr4
else
Pr2 = [Pr2,((lambda/(4*pi*i))^2)*PtW] %%vytvor dynamicke pole s existujucim polom Pr2
end
i = i+1 %%inkrementuj premennu
end
Pr2dB = 10*log10(Pr2); %%prevod na dB tvar z Wattov
plot ([0:1:1000], [Pr2dB]) %%vykresli graf signalu pre Friisov vztah
text(0, 5,'Priebeh utlmu', 'Fontsize', 15);
legend('Voľný priestor','Friisov vzťah') %%legenda jednotlivych priebehov
xlabel('Vzdialenosť (m)') %%oznacenie x osi
ylabel('Výkon prijatého signálu Pr - (dB)') %%oznacenie y osi
grid on
grid minor
