% ENGINE CHAOS ANALYZER v8.1 (High-Performance Edition)
% Optimalizované pre MATLAB Online - bez zamŕzania

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- SPUŠŤAM OPTIMALIZOVANÚ ANALÝZU CHAOSU ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        y = y(fs : 5*fs); % 4 sekundy stačia
        y = y / max(abs(y));
        N = length(y);

        % --- 1. HURSTOV EXPONENT (Rýchly odhad) ---
        % Meria "pamať" signálu (0.5 = náhoda, >0.5 = stabilný trend)
        cum_y = cumsum(y - mean(y));
        res_range = max(cum_y) - min(cum_y);
        res(i).hurst = log10(res_range / (std(y) + eps)) / log10(N);

        % --- 2. PERMUTAČNÁ ENTROPIA (Náhrada za LZC) ---
        % Meria zložitosť vzorcov. Nižšie číslo = strojovo presný chod.
        m = 3; % dĺžka vzoru
        num_patterns = N - m + 1;
        patterns = zeros(num_patterns, 1);
        for j = 1:num_patterns
            [~, idx] = sort(y(j:j+m-1));
            % Unikátny kód pre každú permutáciu (napr. [1 2 3] vs [3 2 1])
            patterns(j) = sum(idx .* (10.^(0:m-1)'));
        end
        [counts, ~] = groupcounts(patterns);
        p = counts / sum(counts);
        res(i).complexity = -sum(p .* log2(p)) / log2(factorial(m));

        % --- 3. PHASE SPACE DISPERSION ---
        % Rozptyl trajektórie (menší = motor "nepláva")
        delay = 10; 
        y1 = y(1:end-delay);
        y2 = y(delay+1:end);
        res(i).dispersion = std(sqrt(y1.^2 + y2.^2));

        fprintf('Spracované: %s\n', labels{i});
    catch ME
        fprintf('Chyba pri %s: %s\n', labels{i}, ME.message);
    end
end

% --- ZOBRAZENIE ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'Hurst (Stab.)', 'Komplexita', 'Rozptyl');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.4f | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).hurst, res(i).complexity, res(i).dispersion);
end
