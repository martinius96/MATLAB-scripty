% ENGINE SOUND ANALYZER v2.0 + PSD
% Pokročilá analýza zvuku motora (stabilita + determinism + spektrum)
clear; clc; close all;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
colors = {'b', 'r', 'g'}; % Modrá, Červená, Zelená pre grafy
res = struct();
fprintf('--- ANALÝZA ZVUKU MOTORA (v2.0 + PSD) ---\n\n');
% Príprava okna pre grafy (vykreslíme to na záver)
figure('Name', 'Porovnanie PSD palív', 'NumberTitle', 'off', 'Position', [100, 100, 1000, 600]);
hold on;
for i = 1:length(files)
    try
        % --- NAČÍTANIE ---
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1
            y = mean(y, 2);
        end
        % 2 sekundy signálu (od 1. do 3. sekundy)
        y = y(fs : 3*fs);
        % normalizácia
        y = (y - mean(y)) / std(y);
        N = length(y);
        %% --- 1. RECURRENCE RATE (RR) ---
        delay = 15;
        y1 = y(1:end-delay);
        y2 = y(delay+1:end);
        dist = sqrt((y1(1:end-1) - y1(2:end)).^2 + ...
                    (y2(1:end-1) - y2(2:end)).^2);
        res(i).RR = 1 / (std(dist) + eps);
        %% --- 2. DETERMINISM ---
        diffs = abs(diff(y));
        threshold = 0.3 * std(diffs);   
        res(i).DET = sum(diffs < threshold) / length(diffs);
        %% --- 3. DIVERGENCIA ---
        d0 = abs(y(1:100) - y(2:101));
        d1 = abs(y(101:200) - y(102:201));
        res(i).DIV = mean(log(d1 ./ (d0 + eps)));
        %% --- 4. SPECTRAL FLATNESS (šum vs tón) ---
        Y = abs(fft(y));
        Y = Y(1:floor(end/2));
        res(i).flatness = exp(mean(log(Y + eps))) / (mean(Y + eps));
        %% --- 5. VARIABILITA AMPLITÚDY ---
        res(i).var_amp = std(abs(y));
        %% --- 6. VÝPOČET PSD (Power Spectral Density) ---
        % Použijeme Welchovu metódu pre hladšie a presnejšie spektrum
        window_len = floor(fs/2); % 0.5 sekundové okno
        overlap = floor(window_len/2);
        
        [pxx, f] = pwelch(y, hamming(window_len), overlap, window_len, fs);
        
        % Prevod na decibely pre lepšiu viditeľnosť rozdielov
        pxx_db = 10 * log10(pxx);
        
        % Vykreslenie krivky do spoločného grafu
        plot(f, pxx_db, colors{i}, 'LineWidth', 1.5);
        fprintf('Spracované: %s\n', labels{i});
    catch ME
        fprintf('Chyba pri spracovaní súboru %s: %s\n', files{i}, ME.message);
    end
end
%% --- ÚPRAVA A DOKONČENIE GRAFU ---
grid on;
xlabel('Frekvencia (Hz)', 'FontSize', 12);
ylabel('Výkonová hustota (dB/Hz)', 'FontSize', 12);
title('Spektrálna hustota výkonu (PSD) - Porovnanie motora', 'FontSize', 14);
legend(labels, 'FontSize', 11, 'Location', 'northeast');

% --- ZMENA TU: Nastavenie osi X na rozsah 0 až 5000 Hz ---
xlim([0, 5000]); 
set(gca, 'XScale', 'linear'); % Prepnuté na lineárnu mierku pre správne zobrazenie nuly

%% --- VÝSLEDKY V KONZOLE ---
fprintf('\n%-15s | %-10s | %-10s | %-10s | %-10s | %-10s\n', ...
    'Palivo', 'RR', 'DET', 'DIV', 'Flatness', 'VarAmp');
fprintf('--------------------------------------------------------------------------\n');
for i = 1:length(res)
    if isfield(res(i), 'RR')
        fprintf('%-15s | %-10.4f | %-10.4f | %-10.4f | %-10.4f | %-10.4f\n', ...
            labels{i}, res(i).RR, res(i).DET, res(i).DIV, ...
            res(i).flatness, res(i).var_amp);
    end
end
%% --- INTERPRETÁCIA ---
fprintf('\nINTERPRETÁCIA:\n');
fprintf('RR        ↑ = stabilnejší chod motora\n');
fprintf('DET       ↑ = viac plynulých zmien (menej náhodnosti)\n');
fprintf('DIV       ↓ = vyššia predvídateľnosť\n');
fprintf('Flatness  ↓ = menej šumu, viac "čistý tón"\n');
fprintf('VarAmp    ↓ = rovnomernejší zvuk\n\n');
fprintf('AKO ČÍTAŤ PSD GRAF:\n');
fprintf('- Krivka, ktorá je položená NAJNIŽŠIE, predstavuje NAJTICHŠIE palivo.\n');
fprintf('- Ak má krivka v oblasti nízkych frekvencií (pod 200 Hz) stabilné a čisté špičky, motor drží rytmus.\n');
fprintf('- Výrazné "kopce" vo vysokých frekvenciách (nad 2000 Hz) indikujú cvakanie vstrekovačov alebo kovový šum.\n');
