% ANALÝZA HLADKOSTI CHODU MOTORA (OMV 100 vs TAM 101)
% Verzia: 1.1 (Upravené pre 2 vstupy)

clear; clc; close all;

% 1. Definícia súborov
files = {'100_OMV.mp4', '101_TAM.mp4'};
labels = {'Benzín OMV 100', 'Benzín TAM 101'};

results = struct();

fprintf('--- SPUŠŤAM ANALÝZU HLADKOSTI A KULTIVOVANOSTI ---\n\n');

for i = 1:length(files)
    try
        % Načítanie audia
        [y, fs] = audioread(files{i});
        
        % Prevod na mono
        if size(y, 2) > 1
            y = mean(y, 2);
        end
        
        % Orezanie (1. až 29. sekunda)
        startSample = round(1 * fs) + 1;
        endSample = min(round(29 * fs), length(y));
        y = y(startSample:endSample);
        
        % Normalizácia amplitúdy
        y = y / max(abs(y));
        
        % --- ŠTATISTICKÉ METÓDY ---
        
        % A. Časová doména: Kolísanie energie (Instabilita)
        windowLen = round(0.1 * fs); 
        numWindows = floor(length(y) / windowLen);
        rms_env = zeros(numWindows, 1);
        for w = 1:numWindows
            idx = (w-1)*windowLen + 1 : w*windowLen;
            rms_env(w) = sqrt(mean(y(idx).^2));
        end
        % Smerodajná odchýlka RMS (čím nižšia, tým stabilnejší voľnobeh)
        stability_idx = std(rms_env) * 1000; 
        
        % B. Crest Factor (Pomer Peak/RMS)
        % Vyššie číslo = ostrejšie rázy/kovovejší zvuk
        crest_factor = max(abs(y)) / sqrt(mean(y.^2));
        
        % C. Frekvenčná doména: Spektrálna Entropia
        L = length(y);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1).^2; 
        P_norm = P / sum(P);      
        spec_entropy = -sum(P_norm .* log2(P_norm + eps));
        
        % Uloženie výsledkov
        results(i).label = labels{i};
        results(i).stability = stability_idx;
        results(i).crest = crest_factor;
        results(i).entropy = spec_entropy;
        
        fprintf('Spracované: %s\n', labels{i});
        
    catch ME
        fprintf('Chyba pri súbore %s: %s\n', labels{i}, ME.message);
    end
end

% --- ZOBRAZENIE VÝSLEDKOV V KONZOLE ---
fprintf('\n%-18s | %-12s | %-12s | %-12s\n', 'Palivo', 'Instabilita', 'Crest Factor', 'Entropia');
fprintf('------------------------------------------------------------------------\n');
for i = 1:length(results)
    fprintf('%-18s | %-12.4f | %-12.4f | %-12.4f\n', ...
        results(i).label, results(i).stability, results(i).crest, results(i).entropy);
end

% --- VIZUALIZÁCIA ---
figure('Name', 'Porovnanie hladkosti chodu', 'Color', 'w');

% Graf stability
subplot(1, 2, 1);
b = bar([results.stability], 'FaceColor', 'flat');
b.CData(1,:) = [0.85 0.33 0.1]; % OMV 
b.CData(2,:) = [0 0.45 0.74]; % TAM
set(gca, 'XTickLabel', labels);
title('Instabilita (Menej = Lepšie)');
ylabel('Index instability');
grid on;

% Graf entropie
subplot(1, 2, 2);
b2 = bar([results.entropy], 'FaceColor', 'flat');
b2.CData(1,:) = [0.85 0.33 0.1];
b2.CData(2,:) = [0 0.45 0.74];
set(gca, 'XTickLabel', labels);
title('Entropia (Menej = Pravidelnejšie)');
ylabel('Spektrálna entropia');
grid on;

sgtitle('Fyzikálne vlastnosti voľnobehu: OMV 100 vs TAM 101');
