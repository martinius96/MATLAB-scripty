% ULTIMATE ENGINE CONSISTENCY ANALYZER v7.0
% Zamerané na stabilitu cyklov a spektrálnu čistotu

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- ANALÝZA CYKLICKEJ KONZISTENCIE ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        y = y(fs : 29*fs); 
        y = y / max(abs(y));

        % --- 1. CONSISTENCY SCORE (Cyklická podobnosť) ---
        % Porovnávame signál so sebou samým s posunom o jeden cyklus
        [r, lags] = xcorr(y(1:fs*2), 'coeff');
        half = floor(length(r)/2);
        % Hľadáme peak v oblasti voľnobehu (cca 10-15 Hz základná frekv.)
        [max_r, ~] = max(r(half + round(fs/20) : half + round(fs/5)));
        res(i).consistency = max_r;

        % --- 2. SPECTRAL CENTROID STABILITY ---
        % Ako sa mení farba zvuku v čase (nižšie STD = lepšie)
        win = round(0.5 * fs); % 0.5s okná
        numW = floor(length(y)/win);
        centroids = zeros(numW, 1);
        for w = 1:numW
            seg = y((w-1)*win+1 : w*win);
            L = length(seg);
            Y = abs(fft(seg)/L);
            P = Y(1:floor(L/2)+1);
            f = (0:floor(L/2))' * (fs/L);
            centroids(w) = sum(f .* P) / sum(P);
        end
        res(i).color_jitter = std(centroids);

        % --- 3. ENERGY REPEATABILITY ---
        % Smerodajná odchýlka špičiek (ako stabilne "búchajú" valce)
        res(i).peak_std = std(abs(y(abs(y) > 0.5))) * 100;

        fprintf('Analyzované: %s\n', labels{i});
    catch ME
        fprintf('Chyba: %s\n', ME.message);
    end
end

% --- FINÁLNA VEDECKÁ TABUĽKA ---
fprintf('\n%-15s | %-15s | %-15s | %-15s\n', 'Palivo', 'Konzistencia', 'Color Jitter', 'Peak Stability');
fprintf('--------------------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-15.4f | %-15.4f | %-15.4f\n', ...
        labels{i}, res(i).consistency, res(i).color_jitter, res(i).peak_std);
end

fprintf('\nSmerodajné vysvetlenie:\n');
fprintf('1. Konzistencia: (0 až 1) Čím vyššie, tým viac sa opakovania spaľovania zhodujú.\n');
fprintf('2. Color Jitter: Nižšie číslo = motor nemení farbu zvuku (beží pokojne).\n');
fprintf('3. Peak Stability: Nižšie číslo = sila jednotlivých expanzií je takmer rovnaká.\n');
