%% Vyhotovil: Martin Chlebovec (martinius96@gmail.com)
%% Vizualizácia detekčnej charakteristiky pre ultrazvukový senzor HC-SR04
%% Detekčná charakteristika: 15°

close all;
clear all;
clc;


half_angle = 7.5; %% 15° detection angle / 2
rad_pos = deg2rad(half_angle);
rad_neg = -rad_pos;
farby = ['b', 'r', 'g', 'c', 'm', 'k', 'b', 'r', 'g'];

figure;
hold on;

for i = 1:9
    start_hlbka = (i - 1) * 0.5;
    koniec_hlbka = i * 0.5;
    
    hlbka = start_hlbka:0.01:koniec_hlbka;
    
    priemer_pos = hlbka * tan(rad_pos);
    priemer_neg = hlbka * tan(rad_neg);
    
    c = farby(i);
    
    plot(hlbka, priemer_pos, ['-', c]);
    plot(hlbka, priemer_neg, ['-', c]);
    
    patch([hlbka, fliplr(hlbka)], [priemer_pos, fliplr(priemer_neg)], c);
end

plot([0, 4.5], [0, 0], '-k', 'LineWidth', 3);

title('Detekčná charakteristika senzora HC-SR04');
grid minor;
xlabel('Hĺbka studne (m)'); 
ylabel('Priemer detekovanej plochy (m)');
axis tight;
