% ULTIMATE ENGINE CONSISTENCY ANALYZER v7.1
% Optimalizované pre: 100_OMV.mp4 a 101_TAM.mp4

clear; clc; close all;

%% 1. DEFINÍCIA SÚBOROV A PALÍV
files = {'100_OMV.mp4', '101_TAM.mp4'};
labels = {'Benzín OMV 100', 'Benzín TAM 101'};
res = struct();

fprintf('--- ANALÝZA CYKLICKEJ KONZISTENCIE (OMV vs TAM) ---\n\n');

for i = 1:length(files)
    try
        %% 2. NAČÍTANIE A PRÍPRAVA
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        
        % Analýza od 1. po 29. sekundu
        idx_start = round(1 * fs) + 1;
        idx_end = min(round(29 * fs), length(y));
        y = y(idx_start:idx_end);
        y = y / max(abs(y));

        %% 3. CONSISTENCY SCORE (Cyklická podobnosť)
        % Porovnávame signál so sebou samým (autokorelácia na krátkom úseku)
        % Hľadáme peak v oblasti voľnobehu (cca 10-15 Hz základná frekv.)
        [r, ~] = xcorr(y(1:fs*2), 'coeff');
        half = floor(length(r)/2);
        [max_r, ~] = max(r(half + round(fs/20) : half + round(fs/5)));
        res(i).consistency = max_r;

        %% 4. SPECTRAL CENTROID STABILITY (Color Jitter)
        % Ako sa mení "ťažisko" frekvencií v čase (nižšie STD = lepšie)
        win = round(0.5 * fs); % 0.5s okná
        numW = floor(length(y)/win);
        centroids = zeros(numW, 1);
        for w = 1:numW
            seg = y((w-1)*win+1 : w*win);
            L = length(seg);
            Y = abs(fft(seg)/L);
            P = Y(1:floor(L/2)+1);
            f = (0:floor(L/2))' * (fs/L);
            centroids(w) = sum(f .* P) / (sum(P) + eps);
        end
        res(i).color_jitter = std(centroids);

        %% 5. ENERGY REPEATABILITY (Peak Stability)
        % Stabilita špičiek (ako rovnomerne expandujú valce)
        res(i).peak_std = std(abs(y(abs(y) > 0.5))) * 100;

        fprintf('Analyzované: %s\n', labels{i});
        
    catch ME
        fprintf('Chyba pri %s: %s\n', labels{i}, ME.message);
    end
end

%% 6. FINÁLNA VEDECKÁ TABUĽKA
fprintf('\n%-18s | %-14s | %-14s | %-14s\n', 'Palivo', 'Konzistencia', 'Color Jitter', 'Peak Stability');
fprintf('----------------------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-18s | %-14.4f | %-14.4f | %-14.4f\n', ...
        labels{i}, res(i).consistency, res(i).color_jitter, res(i).peak_std);
end

fprintf('\nSmerodajné vysvetlenie výsledkov:\n');
fprintf('1. Konzistencia (0-1): Vyšie číslo = spaľovacie cykly sú takmer identické.\n');
fprintf('2. Color Jitter: Nižšie číslo = zvuk motora je frekvenčne stabilný (nelieta).\n');
fprintf('3. Peak Stability: Nižšie číslo = sila jednotlivých expanzií je vyrovnaná.\n');

% --- VIZUÁLNE POROVNANIE KONZISTENCIE ---
figure('Name', 'Analýza konzistencie horenia', 'Color', 'w');
bar([res.consistency]);
set(gca, 'XTickLabel', labels);
title('Cyklická konzistencia (Viac = Lepšie)');
ylabel('Koeficient zhody');
ylim([min([res.consistency])*0.9, 1]); % Zoom na hornú oblasť pre lepšiu viditeľnosť rozdielov
grid on;
