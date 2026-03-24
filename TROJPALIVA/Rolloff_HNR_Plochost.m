% ADVANCED ENGINE DIAGNOSTICS v5.0 (Scientific Grade)
% Bez toolboxov, čisto cez FFT a štatistiku

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- SPUŠŤAM POKROČILÚ SPEKTRÁLNU ANALÝZU ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        y = y(fs : 29*fs); 
        y = y / max(abs(y));
        L = length(y);

        % --- 1. SPECTRAL ROLLOFF (85% hranica energie) ---
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1).^2;
        f = (0:floor(L/2))' * (fs/L);
        cum_p = cumsum(P);
        rolloff_idx = find(cum_p >= 0.85 * cum_p(end), 1);
        res(i).rolloff = f(rolloff_idx);

        % --- 2. HNR (Harmonic-to-Noise Ratio) ---
        % Zjednodušený odhad cez autokoreláciu
        [r, lags] = xcorr(y(1:fs), 'coeff');
        r_center = r(fs:end);
        [max_r, ~] = max(r_center(round(fs/100):round(fs/10))); % Hľadáme periodicitu
        res(i).hnr = 10 * log10(max_r / (1 - max_r + eps));

        % --- 3. SPEKTRÁLNA PLOCHOST (Spectral Flatness) ---
        % Meria, či je zvuk tónový (blízko 0) alebo šumový (blízko 1)
        geom_mean = exp(mean(log(P + eps)));
        arith_mean = mean(P);
        res(i).flatness = geom_mean / arith_mean;

        fprintf('Spracované: %s\n', labels{i});
    catch ME
        fprintf('Chyba: %s\n', ME.message);
    end
end

% --- TABUĽKA VÝSLEDKOV ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'Rolloff [Hz]', 'HNR [dB]', 'Plochosť');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.2f | %-12.4f | %-12.6f\n', ...
        labels{i}, res(i).rolloff, res(i).hnr, res(i).flatness);
end

fprintf('\nInterpretácia:\n');
fprintf('1. Rolloff: Nižšia frekvencia = motor "nepíska", má zdravý basový základ.\n');
fprintf('2. HNR: Vyššie dB = motor má jasný rytmus a málo parazitného šumu.\n');
fprintf('3. Plochosť: Nižšie číslo = zvuk je viac "hudobný" (pravidelné spaľovanie).\n');
