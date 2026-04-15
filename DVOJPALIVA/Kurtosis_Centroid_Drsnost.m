% ENGINE ROUGHNESS & SPECTRAL ANALYZER v2.0
% Optimalizované pre: 100_OMV.mp4 a 101_TAM.mp4

clear; clc; close all;

%% 1. DEFINÍCIA SÚBOROV A PARAMETROV
files = {'100_OMV.mp4', '101_TAM.mp4'};
labels = {'Benzín OMV 100', 'Benzín TAM 101'};
colors = {[0.85 0.33 0.1], [0 0.45 0.74]}; % OMV Oranžová, TAM Modrá
res = struct();

% Parametre pre časovú analýzu drsnosti
windowLength = 0.5; % Dĺžka okna v sekundách
hopSize = 0.1;      % Posun okna v sekundách (prekryv)

figure('Name', 'Porovnanie drsnosti v čase', 'Color', 'w', 'Position', [100, 100, 900, 700]);

for i = 1:length(files)
    try
        %% 2. NAČÍTANIE A ÚPRAVA
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        
        % Orezanie 1s - 29s
        idx_start = round(1 * fs) + 1;
        idx_end = min(round(29 * fs), length(y));
        y = y(idx_start:idx_end);
        y = y / max(abs(y)); % Normalizácia
        
        %% 3. STATICKÉ METRIKY (Globálne)
        mu = mean(y);
        sigma = std(y);
        % Kurtosis (Špicatosť) - meria výskyt extrémnych akustických javov
        res(i).kurtosis = sum((y - mu).^4) / (length(y) * sigma^4);
        
        % Spektrálne ťažisko (Centroid) - "farba" zvuku
        L = length(y);
        f = (0:floor(L/2)) * (fs/L);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1);
        res(i).centroid = sum(f' .* P) / (sum(P) + eps);
        
        % Globálna drsnosť (zmeny amplitúdy medzi vzorkami)
        res(i).roughness = std(diff(y)) * 100;
        
        %% 4. VÝPOČET DRSNOSTI V ČASE
        winSamples = floor(windowLength * fs);
        hopSamples = floor(hopSize * fs);
        numWindows = floor((length(y) - winSamples) / hopSamples);
        
        roughnessTime = zeros(numWindows, 1);
        timeAxis = (0:numWindows-1) * hopSize;

        for w = 1:numWindows
            idx = (w-1)*hopSamples + 1 : (w-1)*hopSamples + winSamples;
            segment = y(idx);
            roughnessTime(w) = std(diff(segment)) * 100;
        end
        
        %% 5. VYKRESLENIE ČASOVÉHO GRAFU
        subplot(2, 1, i);
        plot(timeAxis, roughnessTime, 'Color', colors{i}, 'LineWidth', 1.5);
        title(['Priebeh drsnosti: ', labels{i}], 'FontWeight', 'bold');
        ylabel('Drsnosť [-]');
        xlabel('Čas [s]');
        grid on;
        ylim([0 15]); % Pevná os pre férové porovnanie
        
        fprintf('Spracované: %s\n', labels{i});
        
    catch ME
        fprintf('Chyba pri súbore %s: %s\n', labels{i}, ME.message);
    end
end

% --- TABUĽKA VÝSLEDKOV DO KONZOLY ---
fprintf('\n%-18s | %-12s | %-12s | %-12s\n', 'Palivo', 'Kurtosis', 'Centroid [Hz]', 'Drsnosť');
fprintf('------------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-18s | %-12.4f | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).kurtosis, res(i).centroid, res(i).roughness);
end

% --- DOPLNKOVÝ GRAF: BAR CENTROID ---
figure('Name', 'Analýza farby zvuku', 'Color', 'w');
b = bar([res.centroid], 'FaceColor', 'flat');
b.CData(1,:) = colors{1};
b.CData(2,:) = colors{2};
set(gca, 'XTickLabel', labels);
title('Spektrálne ťažisko (nižšie Hz = hlbší, kultivovanejší zvuk)');
ylabel('Frekvencia [Hz]');
grid on;
