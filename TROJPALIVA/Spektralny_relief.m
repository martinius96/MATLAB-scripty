%% POZOR, DLHO VYKRESLUJE!!!


clear; clc; close all;

%% 1. DEFINÍCIA SÚBOROV A INTERVALU
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};

start_time = 1; 
end_time = 29;  

sigs = cell(1, 3);
fs1 = 0; 

fprintf('--- NAČÍTAVANIE A PRÍPRAVA DÁT (Interval: %d - %d s) ---\n\n', start_time, end_time);

for i = 1:3
    [audio, fs] = audioread(files{i});
    if i == 1, fs1 = fs; end
    if size(audio, 2) > 1, audio = mean(audio, 2); end
    if fs ~= fs1, audio = resample(audio, fs1, fs); end
    
    idx_start = round(start_time * fs1) + 1;
    idx_end = round(end_time * fs1);
    if idx_end > length(audio), idx_end = length(audio); end
    
    sig = audio(idx_start:idx_end);
    sigs{i} = sig - mean(sig); 
    fprintf('Spracované: %s\n', labels{i});
end

% --- NASTAVENIA PRE DLHÝ WATERFALL ---
% Zväčšili sme dĺžku okna (win_len) aj krok, aby graf nebol preťažený
win_len = 4096; 
ovp = 2048; 
nfft = 4096; 
dur_show = 28.0; % 🔥 TERAZ ZOBRAZÍME CELÝCH 28 SEKÚND!

figure('Name','Celkový Waterfall (1 - 29 s)','Color','w','Position',[50 50 1400 800]);

%% RIADOK 1: KLASICKÝ 3D POHĽAD
for k = 1:3
    subplot(2, 3, k);
    current_sig = sigs{k};
    data_plot = current_sig(1:min(length(current_sig), round(dur_show * fs1)));
    
    [s, f, t] = spectrogram(data_plot, hamming(win_len), ovp, nfft, fs1);
    S_dB = 20*log10(abs(s')+eps);
    
    % Posunieme časovú os v grafe o štartovací čas
    t = t + start_time;
    
    waterfall(f/1000, t, S_dB);
    title([labels{k} ' (3D Pohľad)'], 'FontWeight', 'bold'); 
    view(30, 45); colormap jet;
    xlim([0 6]); zlim([-50 50]); caxis([-50 50]);  
    xlabel('Frekvencia [kHz]'); ylabel('Čas [s]'); zlabel('Amplitúda [dB]');
end

%% RIADOK 2: POHĽAD ZBOKU
for k = 1:3
    subplot(2, 3, k + 3); 
    current_sig = sigs{k};
    data_plot = current_sig(1:min(length(current_sig), round(dur_show * fs1)));
    
    [s, f, t] = spectrogram(data_plot, hamming(win_len), ovp, nfft, fs1);
    S_dB = 20*log10(abs(s')+eps);
    t = t + start_time;
    
    waterfall(f/1000, t, S_dB);
    title([labels{k} ' (Pohľad zboku)'], 'FontWeight', 'bold'); 
    view(90, 0); colormap jet;
    xlim([0 6]); zlim([-50 50]); caxis([-50 50]);  
    xlabel('Frekvencia [kHz]'); ylabel('Čas [s]'); zlabel('Amplitúda [dB]');
end

sgtitle('Celková Waterfall analýza v celom trvaní 28 sekúnd', 'FontSize', 14, 'FontWeight', 'bold');
