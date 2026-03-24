% FUEL ENERGY EFFICIENCY ESTIMATOR v11.0
% Relatívne porovnanie akustického výkonu

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};

% Teoretické hodnoty (výhrevnosť) pre kontext (nie z audia!)
% Benzín: cca 42-44 MJ/kg | LPG: cca 46 MJ/kg
theoretical_MJ_kg = [43, 44, 46]; 

fprintf('--- ANALÝZA RELATÍVNEHO ENERGETICKÉHO VÝKONU ---\n\n');

for i = 1:length(files)
    [y, fs] = audioread(files{i});
    if size(y, 2) > 1, y = mean(y, 2); end
    y = y(fs : 5*fs);
    
    % 1. Akustická energia (Suma štvorcov amplitúdy)
    total_acoustic_energy = sum(y.^2);
    
    % 2. Špecifický výkon na jeden zážih (odhad cez obálku)
    [up, ~] = envelope(y, 100, 'peak');
    avg_peak_energy = mean(up.^2);
    
    % 3. Pomer teoretickej energie k akustickému hluku (Efficiency Proxy)
    % Čím menej hluku na jednotku teoretickej energie, tým "hladší" prenos
    efficiency_proxy = theoretical_MJ_kg(i) / (total_acoustic_energy / length(y));

    fprintf('%s:\n', labels{i});
    fprintf('   Akustický výkon (RMS): %.4f\n', rms(y));
    fprintf('   Index hladkosti prenosu: %.2f\n\n', efficiency_proxy);
end

fprintf('Vysvetlenie:\n');
fprintf('MJ/kg sú tabuľkové hodnoty. Audio nám však hovorí, \n');
fprintf('ako efektívne sa táto energia mení na pohyb (a nie na hluk).\n');
