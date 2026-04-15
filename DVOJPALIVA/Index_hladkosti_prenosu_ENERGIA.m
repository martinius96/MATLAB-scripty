% FUEL ENERGY EFFICIENCY ESTIMATOR v11.1
% Relatívne porovnanie akustického výkonu: OMV 100 vs TAM 101

clear; clc;
files = {'100_OMV.mp4', '101_TAM.mp4'};
labels = {'Benzín OMV 100', 'Benzín TAM 101'};

% Teoretické hodnoty (výhrevnosť MJ/kg)
% Zdroj: Bežné hodnoty pre prémiové vysokooktánové palivá
theoretical_MJ_kg = [44.2, 44.5]; 

fprintf('--- ANALÝZA RELATÍVNEHO ENERGETICKÉHO VÝKONU (OMV vs TAM) ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        
        % Analýza 4-sekundového stabilného okna
        y = y(fs : 5*fs);
        
        % 1. Akustická energia (Suma štvorcov amplitúdy)
        total_acoustic_energy = sum(y.^2);
        
        % 2. Špecifický výkon na jeden zážih (odhad cez obálku)
        [up, ~] = envelope(y, 100, 'peak');
        avg_peak_energy = mean(up.^2);
        
        % 3. Pomer teoretickej energie k akustickému hluku (Efficiency Proxy)
        % Čím vyššie číslo, tým menej energie sa "stráca" v zbytočnom hluku/vibráciách.
        efficiency_proxy = theoretical_MJ_kg(i) / (total_acoustic_energy / length(y));

        fprintf('>> %s:\n', labels{i});
        fprintf('   Akustický výkon (RMS):    %.4f\n', rms(y));
        fprintf('   Index hladkosti prenosu:  %.2f\n\n', efficiency_proxy);
        
    catch ME
        fprintf('Chyba pri spracovaní %s: %s\n', labels{i}, ME.message);
    end
end

fprintf('Vysvetlenie:\n');
fprintf('Index hladkosti prenosu vyjadruje pomer medzi tabuľkovou energiou paliva\n');
fprintf('a hlukom, ktorý motor produkuje. Vyššie číslo naznačuje, že spaľovanie\n');
fprintf('prebieha kultivovanejšie a energia sa využíva efektívnejšie na prácu,\n');
fprintf('nie na parazitné akustické prejavy.\n');
