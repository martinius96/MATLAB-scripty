clear; clc; close all;

%% 1. DEFINÍCIA SÚBOROV A INTERVALU
% Upravené na 2 vstupy podľa zadania
files = {'100_OMV.mp4', '101_TAM.mp4'};
labels = {'Benzín OMV 100', 'Benzín TAM 101'};
colors = {[0.85 0.33 0.1], [0 0.45 0.74]}; % Červená pre OMV, Modrá pre TAM

start_time = 1; 
end_time = 29;  

% Maximálny časový posun (lag) v sekundách pre autokoreláciu
max_lag_sec = 0.2; 

figure('Name', 'Autokorelácia signálov motorov', 'Color', 'w', 'Position', [100, 100, 1000, 600]);

fprintf('--- ANALÝZA PERIODICITY POMOCOU AUTOKORELÁCIE (Interval: %d - %d s) ---\n\n', start_time, end_time);

for i = 1:length(files)
    try
        %% 2. NAČÍTANIE A OREZANIE SIGNÁLU
        % Poznámka: audioread funguje aj pre .mp4 súbory (načíta zvukovú stopu)
        [audio, fs] = audioread(files{i});
        
        if size(audio, 2) > 1
            audio = mean(audio, 2); % Prevod na mono
        end
        
        idx_start = round(start_time * fs) + 1;
        idx_end = round(end_time * fs);
        
        if idx_end > length(audio)
            idx_end = length(audio);
        end
        
        sig = audio(idx_start:idx_end);
        sig = sig - mean(sig); % Odstránenie DC zložky
        
        %% 3. VÝPOČET AUTOKORELÁCIE
        max_lag_samples = round(max_lag_sec * fs);
        
        % Výpočet autokorelácie s normalizáciou na 'coeff'
        [acf, lags] = xcorr(sig, max_lag_samples, 'coeff');
        
        % Prevod lagov zo vzoriek na čas (sekundy)
        time_lags = lags / fs;
        
        %% 4. VYKRESLENIE
        % Zmenené na 2 riadky, 1 stĺpec
        subplot(2, 1, i);
        plot(time_lags, acf, 'Color', colors{i}, 'LineWidth', 1.5);
        
        grid on;
        title(['Autokorelácia: ', labels{i}], 'FontSize', 11, 'FontWeight', 'bold');
        xlabel('Časový posun (Lag) [s]', 'FontSize', 10);
        ylabel('Korelačný koeficient [-]', 'FontSize', 10);
        
        % Nastavenie osí
        xlim([-max_lag_sec max_lag_sec]);
        ylim([-0.5 1.1]); 
        
        fprintf('Spracované: %s\n', labels{i});
        
    catch ME
        fprintf('Chyba pri spracovaní súboru %s: %s\n', files{i}, ME.message);
    end
end

sgtitle('Porovnanie periodicity spaľovania (OMV 100 vs TAM 101)', 'FontSize', 14, 'FontWeight', 'bold');
