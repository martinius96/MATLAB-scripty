% ENGINE CHAOS ANALYZER v8.2 (2-Fuel Edition)
% Optimalizované pre: 100_OMV.mp4 a 101_TAM.mp4

clear; clc; close all;

%% 1. DEFINÍCIA SÚBOROV A PALÍV
files = {'100_OMV.mp4', '101_TAM.mp4'};
labels = {'Benzín OMV 100', 'Benzín TAM 101'};
res = struct();

fprintf('--- SPUŠŤAM ANALÝZU CHAOSU A STABILITY (OMV vs TAM) ---\n\n');

for i = 1:length(files)
    try
        %% 2. NAČÍTANIE A PRÍPRAVA DÁT
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        
        % Výber 4-sekundového stabilného úseku (od 2. sekundy nahrávky)
        y = y(2*fs : 6*fs); 
        y = y / max(abs(y));
        N = length(y);

        %% 3. HURSTOV EXPONENT (Stabilita trendu)
        % Meria "pamäť" signálu (0.5 = biely šum, >0.5 = stabilný trend)
        cum_y = cumsum(y - mean(y));
        res_range = max(cum_y) - min(cum_y);
        res(i).hurst = log10(res_range / (std(y) + eps)) / log10(N);

        %% 4. PERMUTAČNÁ ENTROPIA (Zložitosť vzorcov)
        % Nižšie číslo = strojovo presný, rytmický chod.
        m = 3; % dĺžka vzoru
        num_patterns = N - m + 1;
        patterns = zeros(num_patterns, 1);
        
        % Optimalizovaný výpočet permutácií
        for j = 1:num_patterns
            [~, idx] = sort(y(j:j+m-1));
            % Unikátny kód pre permutáciu
            patterns(j) = sum(idx .* (10.^(0:m-1)'));
        end
        
        [counts, ~] = groupcounts(patterns);
        p = counts / sum(counts);
        res(i).complexity = -sum(p .* log2(p)) / log2(factorial(m));

        %% 5. PHASE SPACE DISPERSION (Rozptyl trajektórie)
        % Čím menší rozptyl, tým menej motor "pláva" v otáčkach.
        delay = 10; 
        y1 = y(1:end-delay);
        y2 = y(delay+1:end);
        res(i).dispersion = std(sqrt(y1.^2 + y2.^2));

        fprintf('Spracované: %s\n', labels{i});
        
    catch ME
        fprintf('Chyba pri spracovaní %s: %s\n', labels{i}, ME.message);
    end
end

%% 6. FINÁLNY REPORT DO KONZOLY
fprintf('\n%-18s | %-13s | %-13s | %-13s\n', 'Palivo', 'Hurst (Stab.)', 'Komplexita', 'Rozptyl');
fprintf('------------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-18s | %-13.4f | %-13.4f | %-13.4f\n', ...
        labels{i}, res(i).hurst, res(i).complexity, res(i).dispersion);
end

fprintf('\nInterpretácia:\n');
fprintf('- Vyšší HURST = stabilnejšie spaľovanie v čase.\n');
fprintf('- Nižšia KOMPLEXITA = pravidelnejší, menej chaotický zvuk motora.\n');
fprintf('- Nižší ROZPTYL = pevnejšie držanie otáčok/rytmu.\n');
