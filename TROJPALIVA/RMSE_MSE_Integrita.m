% ULTIMATE ENGINE DIAGNOSTICER v9.0
% Metódy informačnej teórie a reziduálnej analýzy

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- SPUŠŤAM FINÁLNU EXPERTÍZU KONDÍCIE ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        y = y(fs : 5*fs); 
        y = y / max(abs(y));
        N = length(y);

        % --- 1. RMSE RESIDUAL ANALYSIS (Čistota voči modelu) ---
        % Vytvoríme vyhladený model (MA filter) a meriame chybu
        windowSize = 50;
        y_smooth = movmean(y, windowSize);
        res(i).rmse = sqrt(mean((y - y_smooth).^2));

        % --- 2. MULTISCALE COMPLEXITY (Zjednodušená MSE) ---
        % Sleduje stabilitu vzoru pri rôznom rozlíšení
        y_ds = resample(y, 1, 4); % Downsample pre druhú mierku
        res(i).mse = std(y) / std(y_ds);

        % --- 3. TEUBEROV KOEFICIENT (Štruktúrna integrita) ---
        % Pomer autokorelácie a rozptylu
        autoc = xcorr(y, 1, 'coeff');
        res(i).teuber = autoc(3) / autoc(2); % Susedná korelácia

        fprintf('Spracované: %s\n', labels{i});
    catch ME
        fprintf('Chyba: %s\n', ME.message);
    end
end

% --- FINÁLNY VERDIKT ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'RMSE (Chyba)', 'MSE Index', 'Integrita');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.4f | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).rmse, res(i).mse, res(i).teuber);
end

fprintf('\nKedy je motor "Najlepšie na tom"?\n');
fprintf('1. RMSE: Čím NIŽŠIE, tým menej mechanického nepokoja a "bordelu" v signáli.\n');
fprintf('2. MSE Index: Čím bližšie k 1.0, tým je chod motora konzistentnejší naprieč frekvenciami.\n');
fprintf('3. Integrita: Čím bližšie k 1.0, tým pevnejšia je väzba medzi jednotlivými otáčkami.\n');
