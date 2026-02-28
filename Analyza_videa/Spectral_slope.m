%% KOMPLEXNÁ ANALÝZA CHARAKTERU HORENIA (SPECTRAL SLOPE)
% Imunita voči vzdialenosti mikrofónu a dĺžke príchodu k autu.

clc; clear; close all;

%% 1. Načítanie audia
videoFile = 'TAM_paliva.mp4';
if exist(videoFile,'file') ~= 2
    error('Súbor %s nebol nájdený!', videoFile);
end

[audio, Fs] = audioread(videoFile);
if size(audio,2) == 2, audio = mean(audio,2); end
t = (0:length(audio)-1)/Fs;

%% 2. Definícia sekcií
idx_101 = t >= 5 & t < 29;   
idx_95  = t >= 29;           

segments = {'101 oktan', '95 oktan'};
indices = {idx_101, idx_95};

fprintf('--- ANALÝZA SPEKTRÁLNEHO SKLONU (KVALITA SPAĽOVANIA) ---\n');

results = struct();

for i = 1:2
    seg_name = segments{i};
    raw_signal = audio(indices{i});
    raw_signal = raw_signal - mean(raw_signal); % Odstránenie DC zložky
    
    % --- VÝBER TOP 10% ENERGIE (Filtrácia ticha pri príchode) ---
    abs_audio = abs(raw_signal);
    sorted_vals = sort(abs_audio, 'descend');
    threshold = sorted_vals(round(length(sorted_vals)*0.10));
    top_samples = raw_signal(abs_audio >= threshold);
    
    % Výpočet výkonového spektra (PSD)
    nfft = 4096;
    [pxx, f] = periodogram(top_samples, rectwin(length(top_samples)), nfft, Fs);
    
    % --- SPECTRAL SLOPE (Sklon spektra) ---
    % Sledujeme pásmo 500 Hz až 8000 Hz (kde sa láme "mäkký" a "ostrý" zvuk)
    freq_range = f >= 500 & f <= 8000;
    log_f = log10(f(freq_range));
    log_pxx = 10*log10(pxx(freq_range));
    
    % Lineárna regresia (fitovanie priamky cez spektrum)
    p = polyfit(log_f, log_pxx, 1); 
    spec_slope = p(1); % Smernica (Slope) v dB/dekádu
    
    % --- DOPLNKOVÉ ŠTATISTIKY ---
    kurt_val = kurtosis(raw_signal);
    crest_val = 20 * log10(max(abs_audio) / rms(raw_signal));

    % --- VÝPIS VÝSLEDKOV ---
    fprintf('\n========== %s ==========\n', seg_name);
    fprintf('Spectral Slope:      %.2f dB/dec (Nižšie/Strmšie = kultivovanejšie)\n', spec_slope);
    fprintf('Kurtosis:            %.2f\n', kurt_val);
    fprintf('Crest Factor:        %.2f dB\n', crest_val);
    
    % Uloženie pre graf
    results(i).f = f;
    results(i).pxx = 10*log10(pxx);
    results(i).slope_p = p;
    results(i).log_f = log_f;
end

%% 3. Vizualizácia Sklonu Spektra
figure('Color','w','Position',[100 100 900 450]);
colors = {'r', 'g'};

for i = 1:2
    subplot(1,2,i);
    plot(log10(results(i).f), results(i).pxx, 'Color', [0.7 0.7 0.7]); hold on;
    
    % Vykreslenie regresnej čiary (Sklonu)
    fit_line = polyval(results(i).slope_p, results(i).log_f);
    plot(results(i).log_f, fit_line, colors{i}, 'LineWidth', 2.5);
    
    title([segments{i} ' (Slope: ' num2str(results(i).slope_p(1), '%.2f') ')']);
    xlabel('Log10 Frekvencia (Hz)');
    ylabel('Výkon (dB/Hz)');
    grid on;
    xlim([log10(100) log10(10000)]);
    ylim([min(results(i).pxx) max(results(i).pxx)+5]);
end

sgtitle('Porovnanie strmosti poklesu energie (Väčší sklon = tichšie vysoké tóny)');
