clear; clc; close all;

%% 1. DEFINÍCIA SÚBOROV A INTERVALU
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
colors = {[0 0.45 0.74], [0.85 0.33 0.1], [0.47 0.67 0.19]}; % Modrá, Červená, Zelená

start_time = 1; 
end_time = 29;  

res = struct();

figure('Name', 'Vyhladené porovnanie PSD palív', 'Color', 'w', 'Position', [100, 100, 1000, 600]);
hold on;

fprintf('--- ANALÝZA A POROVNANIE PALÍV (Interval: %d - %d s) ---\n\n', start_time, end_time);

for i = 1:length(files)
    try
        %% 2. NAČÍTANIE A OREZANIE SIGNÁLU
        [audio, fs] = audioread(files{i});
        
        if size(audio, 2) > 1
            audio = mean(audio, 2);
        end
        
        idx_start = round(start_time * fs) + 1;
        idx_end = round(end_time * fs);
        
        if idx_end > length(audio)
            idx_end = length(audio);
        end
        
        sig = audio(idx_start:idx_end);
        sig = sig - mean(sig); % Odstránenie DC
        
        %% 3. VÝPOČET TVOJICH METRÍK PRE TABUĽKU
        res(i).rms = rms(sig);
        res(i).kurt = kurtosis(sig);
        try
            res(i).ent = pentropy(sig, fs);
        catch
            psd_fallback = abs(fft(sig)).^2;
            psd_fallback = psd_fallback / sum(psd_fallback);
            res(i).ent = -sum(psd_fallback .* log2(psd_fallback + eps));
        end
        res(i).crest = max(abs(sig)) / res(i).rms;
        
        %% 4. VYHLADENÝ VÝPOČET PSD (WELCH) 🔥
        % Okno s dĺžkou 0.25 sekundy pre pekné vyhladenie šumu
        window_len = floor(fs / 4); 
        overlap = floor(window_len / 2);
        
        % pwelch namiesto periodogramu signál krásne vyhladí
        [pxx, f] = pwelch(sig, hamming(window_len), overlap, window_len, fs);
        pxx_db = 10 * log10(pxx);
        
        % Vykreslenie vyhladenej krivky
        plot(f, pxx_db, 'Color', colors{i}, 'LineWidth', 1.8);
        
        fprintf('Spracované: %s\n', labels{i});
        
    catch ME
        fprintf('Chyba pri spracovaní súboru %s: %s\n', files{i}, ME.message);
    end
end

%% 5. ÚPRAVA GRAFU DO PREHĽADNÉHO STAVU
grid on;
title('Vyhladená výkonová spektrálna hustota (PSD) - Porovnanie palív', 'FontSize', 13);
xlabel('Frekvencia [Hz]', 'FontSize', 11);
ylabel('Výkon/Frekvencia [dB/Hz]', 'FontSize', 11);

% Nastavenie osí podľa tvojho pôvodného obrázka
xlim([0 5000]); 
ylim([-95 -55]);

legend(labels, 'Location', 'northeast', 'FontSize', 11);

%% 6. VÝPIS POROVNÁVACEJ TABUĽKY
fprintf('\n==========================================================================\n');
fprintf('VÝSLEDNÉ POROVNANIE METRÍK (INTERVAL: %d - %d s)\n', start_time, end_time);
fprintf('==========================================================================\n');
fprintf('%-20s | %-12s | %-12s | %-12s | %-12s\n', 'Palivo', 'Kurtosis', 'Entropia', 'RMS', 'Crest Factor');
fprintf('--------------------------------------------------------------------------\n');

for i = 1:length(files)
    if isfield(res(i), 'rms')
        fprintf('%-20s | %12.4f | %12.4f | %12.4f | %12.4f\n', ...
            labels{i}, res(i).kurt, res(i).ent, res(i).rms, res(i).crest);
    end
end
fprintf('==========================================================================\n');
