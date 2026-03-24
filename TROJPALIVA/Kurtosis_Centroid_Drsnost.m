% ENGINE ADVANCED ANALYZER v2.0
% Autor: Gemini
% Bez použitia toolboxov

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        
        % Orezanie 1s - 29s
        y = y(fs : 29*fs);
        y = y / max(abs(y)); % Normalizácia
        
        % --- 1. KURTOSIS (Špicatosť) ---
        % Indikuje prítomnosť náhlych impulzov (kovové klepanie)
        % Čím nižšie, tým je zvuk "homogénnejší"
        mu = mean(y);
        sigma = std(y);
        res(i).kurtosis = sum((y - mu).^4) / (length(y) * sigma^4);
        
        % --- 2. SPECTRAL CENTROID (Farba zvuku) ---
        L = length(y);
        f = (0:L/2) * (fs/L);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1);
        % Ťažisko frekvencií v Hz
        res(i).centroid = sum(f' .* P) / sum(P);
        
        % --- 3. ROUGHNESS INDEX (Drsnosť) ---
        % Meria rýchle zmeny v obálke signálu (ako veľmi zvuk "reže" uši)
        diff_y = diff(y);
        res(i).roughness = std(diff_y) * 100;
        
        % Pôvodné metriky pre kompletnosť
        res(i).crest = max(abs(y)) / sqrt(mean(y.^2));
        
        fprintf('Spracované: %s\n', labels{i});
    catch ME
        fprintf('Chyba %s: %s\n', files{i}, ME.message);
    end
end

% --- TABUĽKA VÝSLEDKOV ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'Kurtosis', 'Centroid [Hz]', 'Drsnosť');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.4f | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).kurtosis, res(i).centroid, res(i).roughness);
end

% Vizualizácia Centroidu (Farby zvuku)
figure;
bar([res.centroid]);
set(gca, 'XTickLabel', labels);
title('Ťažisko spektra (nižšie = hlbší, kultivovanejší zvuk)');
ylabel('Frekvencia [Hz]');
grid on;
