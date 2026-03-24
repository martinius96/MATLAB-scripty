% ANALÝZA HLADKOSTI CHODU MOTORA (Benzín vs LPG)
% Autor: Gemini
% Verzia: 1.0 (Basic MATLAB - No Toolboxes)

clear; clc;

% 1. Definícia súborov (Zmeň názvy podľa svojich súborov)
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4',};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};

results = struct();

fprintf('--- Spúšťam analýzu zvuku motora ---\n\n');

for i = 1:length(files)
    try
        % Načítanie audia
        [y, fs] = audioread(files{i});
        
        % Prevod na mono, ak je nahrávka stereo
        if size(y, 2) > 1
            y = mean(y, 2);
        end
        
        % Orezanie (1. až 29. sekunda)
        startSample = 1 * fs;
        endSample = 29 * fs;
        y = y(startSample:endSample);
        
        % Normalizácia amplitúdy (aby hlasitosť nahrávky neovplyvnila stabilitu)
        y = y / max(abs(y));
        
        % --- ŠTATISTICKÉ METÓDY ---
        
        % A. Časová doména: Kolísanie energie (Smoothness)
        % Rozdelíme signál na 100ms okná a počítame RMS každého okna
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
        % Vyššie číslo = ostrejšie rázy/klepot
        crest_factor = max(abs(y)) / sqrt(mean(y.^2));
        
        % C. Frekvenčná doména: Spektrálna Entropia (zjednodušená)
        % Meria "usporiadanosť" spektra. Čím nižšia, tým čistejší tón motora.
        L = length(y);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1).^2; % Výkonové spektrum
        P_norm = P / sum(P);      % Normalizácia na pravdepodobnosť
        spec_entropy = -sum(P_norm .* log2(P_norm + eps));
        
        % Uloženie výsledkov
        results(i).label = labels{i};
        results(i).stability = stability_idx;
        results(i).crest = crest_factor;
        results(i).entropy = spec_entropy;
        
        fprintf('Spracované: %s\n', labels{i});
        
    catch ME
        fprintf('Chyba pri súbore %s: %s\n', files{i}, ME.message);
    end
end

% --- ZOBRAZENIE VÝSLEDKOV ---

fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'Instabilita', 'Crest Factor', 'Entropia');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(results)
    fprintf('%-15s | %-12.4f | %-12.4f | %-12.4f\n', ...
        results(i).label, results(i).stability, results(i).crest, results(i).entropy);
end

fprintf('\nInterpretácia:\n');
fprintf('1. Instabilita (STD of RMS): Čím NIŽŠIE číslo, tým menej motor "pláva".\n');
fprintf('2. Crest Factor: Čím NIŽŠIE číslo, tým je zvuk mäkší (menej kovového klepotu).\n');
fprintf('3. Entropia: Čím NIŽŠIE číslo, tým pravidelnejšie motor spaľuje.\n');

% Jednoduchý graf pre vizuálne porovnanie instability
figure;
bar([results.stability]);
set(gca, 'XTickLabel', labels);
title('Kolísanie energie voľnobehu (menej = lepšie)');
ylabel('Index instability');
grid on;
