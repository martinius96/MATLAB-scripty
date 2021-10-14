%%Zadanie:
%%Vygenerujte náhodnú postupnosť bitov
%%Uvažujte 3 prípady a vložte do postupnosti
%%A: zabezpecovaci bit za kazde 4 bity
%%B: zabezpecovaci bit pred a po 4-bitovej postupnosti
%%C: zabezpecovaci bit za kazdy bit postupnosti
%%Vyjadrite sirku pasma potrebnu na prenos dat za jednotku casu


%%pred spustenim skriptu zavri okna a vymaž premenne
close all;
clear all;

%%Vstupne premenne
interval = 1000; %%interval
delitelnost = 0; %%boolean premenna

%%Pociatocna hodnota Signal/noise ratio - pomer
SNR_dB = 10; % hodnota pre dB
SNR_Watt = 10^(SNR_dB/10); %Hodnota pre WATT

%%cyklus, boolean premennu nastav na 1
while (delitelnost ~= 1)
    generovane_cislo = randi(interval);
    modulo = @(interval) rem(interval, [4]) == 0;
    delitelnost = modulo(generovane_cislo);
end

pole_znakov_random = randi([0 1],1,generovane_cislo);
zabezpecovacibit_matica = 1*ones(1,generovane_cislo/4);
povodne_bity_postupnosti = reshape(pole_znakov_random,4,generovane_cislo/4);

%%MATICA SO ZABEZPECOVACIM BITOM ZA 4 BITMI
A = reshape([povodne_bity_postupnosti; zabezpecovacibit_matica],1,(4+1)*generovane_cislo/4);
%%MATICA SO ZABEZPECOVACIM BITOM NA ZACIATKU A KONCI 4-BITOVEJ POSTUPNOSTI
B = reshape([zabezpecovacibit_matica; povodne_bity_postupnosti; zabezpecovacibit_matica],1,(4+2)*generovane_cislo/4);
%%MATICA SO ZABEZPECOVACIM BITOM ZA KAZDYM BITOM POSTUPNOSTI
C = reshape([zabezpecovacibit_matica; povodne_bity_postupnosti(1:2,:); zabezpecovacibit_matica; povodne_bity_postupnosti(3:end,:); zabezpecovacibit_matica],1,(4+3)*generovane_cislo/4);

%%KAPACITA KANALA = POCET BITOV V MATICIACH
pocetbitovA = numel(A);
pocetbitovB = numel(B);
pocetbitovC = numel(C);

%%SIRKA PASMA, VZOREC ZO VZTAHU SO KAPACITY KANALA + SNR A LOGARITMICKYM VYJADRENIM 
B1 = pocetbitovA/log2(1+SNR_Watt);
B2 = pocetbitovB/log2(1+SNR_Watt);
B3 = pocetbitovC/log2(1+SNR_Watt); 

%%GRAF, ZAVISLOST KAPACITY A SIRKY PASMA
figure('Name','Závislosť šírky pásma od kapacity kanála');
bar(B1, pocetbitovA, 'm')
hold on
bar(B2, pocetbitovB, 'c')
hold on
bar(B3, pocetbitovC ,'y')
hold on
title('Závislosť šírky pásma od kapacity kanála')
ylabel('Kapacita kanála (počet bitov)');
xlabel('Šírka pásma (Hz)');
legend('Prípad 1','Prípad 2','Prípad 3','location','north')

