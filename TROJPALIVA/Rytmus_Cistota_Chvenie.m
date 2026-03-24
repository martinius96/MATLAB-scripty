% ENGINE MEGA-ANALYZER v4.0 (Final Boss Edition)
% Zamerané na rytmickú presnosť a harmonickú čistotu

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- SPUŠŤAM MEGA-ANALÝZU (PHASE & COHERENCE) ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        y = y(fs : 29*fs);
        y = y - mean(y);
        y = y / max(abs(y));

        % --- 1. RYTMICKÝ JITTER (cez Autokoreláciu) ---
        % Hľadáme hlavný vrchol zodpovedajúci otáčkam
        [autocorr, lags] = xcorr(y(1:fs*2), 'coeff'); % 2s okno
        half = floor(length(autocorr)/2);
        search_zone = autocorr(half + round(fs/20) : half + round(fs/5)); 
        [pk, loc] = max(search_zone);
        % Periodicita (ako silno sa signál opakuje)
        res(i).periodicity = pk; 

        % --- 2. HARMONICKÁ ČISTOTA (THD-like) ---
        L = length(y);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1);
        [max_p, max_idx] = max(P(10:500)); % hľadáme dominantnú frekvenciu spaľovania
        fundamental_energy = max_p;
        total_energy = sum(P);
        res(i).purity = (fundamental_energy / total_energy) * 1000;

        % --- 3. MODULAČNÝ INDEX (Chvenie amplitúdy) ---
        env = abs(hilbert(y)); % Obálka signálu bez toolboxu cez hilbert
        res(i).modulation = std(env) / mean(env);

        fprintf('Hotovo: %s\n', labels{i});
    catch ME
        fprintf('Chyba: %s\n', ME.message);
    end
end

% --- VÝSLEDKY ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'Rytmus (0-1)', 'Čistota', 'Chvenie');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.4f | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).periodicity, res(i).purity, res(i).modulation);
end

fprintf('\nInterpretácia MEGA-výsledkov:\n');
fprintf('1. Rytmus: Čím bližšie k 1.0, tým dokonalejšie časovanie zážihov (RPM stabilita).\n');
fprintf('2. Čistota: Vyššie číslo = motor znie ako ladička, nie ako kopa šrotu.\n');
fprintf('3. Chvenie: NIŽŠIE číslo znamená, že sila každého výbuchu je identická.\n');
