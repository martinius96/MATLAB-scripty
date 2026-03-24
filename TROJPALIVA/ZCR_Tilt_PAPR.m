% ENGINE ACOUSTIC FINGERPRINT v3.0
% Analýza textúry a farby zvuku (Bez toolboxov)

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- Spúšťam finálnu akustickú expertízu ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        y = y(fs : 29*fs); 
        y = y - mean(y); % Odstránenie DC zložky
        y = y / max(abs(y));

        % --- 1. ZERO CROSSING RATE (Mechanický šum) ---
        % Počet zmien znamienka v signáli
        res(i).zcr = sum(abs(diff(y > 0))) / length(y);

        % --- 2. SPECTRAL TILT (Náklon spektra) ---
        L = length(y);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1);
        f = (0:floor(L/2))' * (fs/L);
        
        % Log-log lineárna regresia pre náklon (iba do 10kHz, kde je gro zvuku)
        idx = f > 20 & f < 10000;
        logF = log10(f(idx) + eps);
        logP = log10(P(idx) + eps);
        coeffs = polyfit(logF, logP, 1);
        res(i).tilt = coeffs(1); % Smernica priamky

        % --- 3. PAPR (Dynamika zážihu) ---
        peak_pow = max(y.^2);
        avg_pow = mean(y.^2);
        res(i).papr = 10 * log10(peak_pow / avg_pow);

        fprintf('Analyzované: %s\n', labels{i});
    catch ME
        fprintf('Chyba pri %s: %s\n', files{i}, ME.message);
    end
end

% --- FINÁLNA TABUĽKA ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'ZCR (Šum)', 'Tilt (Náklon)', 'PAPR [dB]');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.4f | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).zcr, res(i).tilt, res(i).papr);
end

fprintf('\nInterpretácia:\n');
fprintf('1. ZCR: Nižšie číslo = menej mechanického šelestu/trenia (čistejší motor).\n');
fprintf('2. Tilt: Čím viac NEGATÍVNE (napr -2.5), tým je zvuk hlbší a "prémiovejší".\n');
fprintf('3. PAPR: Nižšie číslo = motor beží hladko ako turbína, vyššie = výrazné zážihy.\n');
