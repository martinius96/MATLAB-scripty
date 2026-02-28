%% ANALYZA KULTIVOVANOSTI MOTORA - PEAKY A EXTRÉMY
% Tento kód je imúnny voči dĺžke príchodu k autu.

clc; clear; close all;

%% 1. Načítanie audia
videoFile = 'TAM_paliva.mp4';
if exist(videoFile,'file') ~= 2
    error('Súbor %s nebol nájdený!', videoFile);
end

[audio, Fs] = audioread(videoFile);
if size(audio,2) == 2, audio = mean(audio,2); end
t = (0:length(audio)-1)/Fs;

%% 2. Definícia sekcií (podľa tvojho zadania)
idx_101 = t >= 5 & t < 29;   
idx_95  = t >= 29;           

segments = {'101 oktan', '95 oktan'};
indices = {idx_101, idx_95};

fprintf('--- KOMPLEXNÁ ANALÝZA EXTRÉMOV ---\n');

for i = 1:2
    seg_name = segments{i};
    raw_signal = audio(indices{i});
    raw_signal = raw_signal - mean(raw_signal); % Odstránenie DC zložky
    
    % --- A. KURTOSIS (Index rázovitosti) ---
    % Sleduje "špicatosť" zvuku. Čím vyššie nad 3, tým viac kovových rán/klopotu.
    kurt_val = kurtosis(raw_signal);
    
    % --- B. ANALÝZA TOP 10% ENERGIE (Imunita voči príchodu k autu) ---
    % Vyberieme len vzorky, kde je mikrofón reálne pri motore
    abs_audio = abs(raw_signal);
    sorted_vals = sort(abs_audio, 'descend');
    threshold = sorted_vals(round(length(sorted_vals)*0.10));
    top_samples = raw_signal(abs_audio >= threshold);
    
    % Spektrálny centroid len pre tieto špičky (Farba "výbuchu")
    [pxx, f] = periodogram(top_samples, rectwin(length(top_samples)), 2048, Fs);
    top_centroid = sum(f .* pxx) / sum(pxx);
    
    % --- C. CREST FACTOR (Ostrosť impulzu) ---
    peak_val = max(abs_audio);
    rms_val = sqrt(mean(raw_signal.^2));
    crest_factor_dB = 20 * log10(peak_val / rms_val);
    
    % --- D. POMER VYSOKÝCH A NÍZKYCH FREKVENCIÍ (Mäkkosť chodu) ---
    low_idx = f > 20 & f < 500;
    high_idx = f > 2000 & f < 10000;
    softness_ratio = mean(pxx(high_idx)) / mean(pxx(low_idx));
    
    % --- VÝPIS VÝSLEDKOV ---
    fprintf('\n========== %s ==========\n', seg_name);
    fprintf('Kurtosis (Rázovitosť):      %.2f (nižšie = hladší chod)\n', kurt_val);
    fprintf('Centroid špičiek:           %.2f Hz (nižšie = hlbší zvuk)\n', top_centroid);
    fprintf('Crest Factor:               %.2f dB (nižšie = menej "staccato")\n', crest_factor_dB);
    fprintf('Pomer Ostré/Tupé zvuky:     %.5f (nižšie = kvalitnejšia farba)\n', softness_ratio);
    
    % Uloženie pre grafy
    results(i).f = f;
    results(i).pxx = 10*log10(pxx);
end

%% 3. Grafické porovnanie farby zvuku (PSD najsilnejších častí)
figure('Color','w','Position',[100 100 800 400]);
plot(results(1).f, results(1).pxx, 'r', 'LineWidth', 1.2); hold on;
plot(results(2).f, results(2).pxx, 'g', 'LineWidth', 1.2);
xlim([20 10000]); grid on;
xlabel('Frekvencia (Hz)');
ylabel('Výkon (dB/Hz)');
title('Spektrálny odtlačok motora pri maximálnom tlaku (TOP 10% Peakov)');
legend('101 oktan', '95 oktan');

% Pomôcka pre interpretáciu priamo v grafe
annotation('textbox', [0.6, 0.7, 0.25, 0.15], 'String', ...
    {'NIŽŠIA čara v oblasti','2-8 kHz znamená','KULTIVOVANEJŠÍ chod'}, ...
    'FontSize', 9, 'BackgroundColor', 'w');
