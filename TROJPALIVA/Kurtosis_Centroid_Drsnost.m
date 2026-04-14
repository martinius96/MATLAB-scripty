clear; clc; close all;

files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
colors = {'r', 'b', 'g'}; % Červená, Modrá, Zelená pre grafy
res = struct();

% Parametre pre časovú analýzu drsnosti
windowLength = 0.5; % Dĺžka okna v sekundách
hopSize = 0.1;      % Posun okna v sekundách

figure('Name', 'Porovnanie drsnosti v čase', 'Position', [100, 100, 800, 600]);

for i = 1:length(files)
    try
        % --- NAČÍTANIE A ÚPRAVA ---
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        
        % Orezanie 1s - 29s
        y = y(fs : 29*fs);
        y = y / max(abs(y)); % Normalizácia na 1.0
        
        % --- 1. STATICKÉ METRIKY (Globálne) ---
        mu = mean(y);
        sigma = std(y);
        res(i).kurtosis = sum((y - mu).^4) / (length(y) * sigma^4);
        
        L = length(y);
        f = (0:L/2) * (fs/L);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1);
        res(i).centroid = sum(f' .* P) / sum(P);
        
        % Globálna drsnosť
        res(i).roughness = std(diff(y)) * 100;
        
        % --- 2. VÝPOČET DRSNOSTI V ČASE ---
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
        
        % --- 3. VYKRESLENIE ČASOVÉHO GRAFU ---
        subplot(3, 1, i);
        plot(timeAxis, roughnessTime, colors{i}, 'LineWidth', 1.2);
        title(['Časový priebeh drsnosti: ', labels{i}]);
        ylabel('Drsnosť');
        xlabel('Čas [s]');
        grid on;
        ylim([0 15]); % Pevná os Y pre lepšie vizuálne porovnanie (uprav podľa potreby)
        
        fprintf('Spracované: %s\n', labels{i});
        
    catch ME
        fprintf('Chyba pri súbore %s: %s\n', files{i}, ME.message);
    end
end

% --- TABUĽKA VÝSLEDKOV DO KONZOLY ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'Kurtosis', 'Centroid [Hz]', 'Drsnosť');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.4f | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).kurtosis, res(i).centroid, res(i).roughness);
end

% --- DOPLNKOVÝ GRAF: BAR CENTROID (Farba zvuku) ---
figure('Name', 'Spektrálne ťažisko');
bar([res.centroid]);
set(gca, 'XTickLabel', labels);
title('Spektrálne ťažisko (nižšie Hz = kultivovanejší zvuk)');
ylabel('Frekvencia [Hz]');
grid on;
