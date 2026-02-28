%% ANALÝZA ČISTOTY TÓNU (HARMONIC-TO-NOISE RATIO)
% Parameter HNR určuje, či motor "spieva" alebo "šumí".
% Vyššie HNR = kvalitnejšie a čistejšie spaľovanie.

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

fprintf('--- ANALÝZA HNR (POMER SIGNÁLU K ŠUMU MOTORA) ---\n');

for i = 1:2
    seg_name = segments{i};
    raw_signal = audio(indices{i});
    raw_signal = raw_signal - mean(raw_signal); 
    
    % --- VÝBER TOP 10% ENERGIE (Imunita voči vzdialenosti) ---
    abs_audio = abs(raw_signal);
    sorted_vals = sort(abs_audio, 'descend');
    threshold = sorted_vals(round(length(sorted_vals)*0.10));
    top_samples = raw_signal(abs_audio >= threshold);
    
    % Výpočet výkonového spektra (PSD)
    nfft = 8192;
    [pxx, f] = periodogram(top_samples, rectwin(length(top_samples)), nfft, Fs);
    
    % --- VÝPOČET HNR ---
    % Harmonická zložka (0 - 2000 Hz): Základný zvuk motora
    % Šumová zložka (2000 - 10000 Hz): Vysokofrekvenčný chaos a parazitné zvuky
    harmonic_energy = sum(pxx(f > 50 & f <= 2000));
    noise_energy = sum(pxx(f > 2000 & f <= 10000));
    
    hnr_db = 10 * log10(harmonic_energy / noise_energy);
    
    % --- VÝPIS VÝSLEDKOV ---
    fprintf('\n========== %s ==========\n', seg_name);
    fprintf('HNR (Čistota tónu):  %.2f dB (Vyššie = čistejší chod)\n', hnr_db);
    
    % Uloženie pre vizualizáciu
    res(i).f = f;
    res(i).pxx = 10*log10(pxx);
end

%% 3. Grafické porovnanie
figure('Color','w');
plot(res(1).f, res(1).pxx, 'r', 'LineWidth', 1); hold on;
plot(res(2).f, res(2).pxx, 'g', 'LineWidth', 1);
xline(2000, '--k', 'Deliaca frekvencia HNR');
xlim([50 10000]); grid on;
xlabel('Frekvencia (Hz)');
ylabel('Výkon (dB/Hz)');
legend('101 oktan', '95 oktan');
title('Spektrálna analýza: Harmonické pásmo vs. Šumové pásmo');
