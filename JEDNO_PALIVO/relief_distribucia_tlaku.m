clear; clc; close all;

%% 1. NAČÍTANIE A FIXNÉ OREZANIE (1 - 29s)
filename = 'LPG_OMV.mp4'; 
start_time = 1; 
end_time = 29;

try
    [audio, fs] = audioread(filename);
catch
    error('Súbor %s nebol nájdený!', filename);
end

if size(audio,2) > 1, audio = mean(audio,2); end

% Presné indexy pre výrez
idx_start = round(start_time * fs) + 1;
idx_end = round(end_time * fs);
sig = audio(idx_start:idx_end);

% Parametre analýzy
win = 1024; ovp = 512; nfft = 1024;
col_95 = [0 0.4470 0.7410]; 

fprintf('Spracovávam výhradne úsek: %d až %d sekúnd.\n', start_time, end_time);

%% 2. 3D WATERFALL (Iba 1 - 29s)
figure('Name','3D Waterfall Analýza','Color','w','Position',[50 100 1000 600]);

% Spektrogram pre celý tvoj vybraný rozsah
[s, f, t_spec] = spectrogram(sig, hamming(win), ovp, nfft, fs);
t_spec = t_spec + start_time; % Posun osi, aby začínala na 1s

waterfall(f/1000, t_spec, 20*log10(abs(s')+eps));
view(30, 45); colormap jet; 
title(sprintf('Spektrálny reliéf: %d až %d s', start_time, end_time));
xlabel('Frekvencia [kHz]'); ylabel('Čas [s]'); zlabel('Amplitúda [dB]');
xlim([0 8]); 
grid on;

%% 3. HISTOGRAM (Iba 1 - 29s)
figure('Name','Hustota amplitúd','Color','w');
histogram(sig, 300, 'Normalization', 'pdf', 'FaceColor', col_95, 'EdgeAlpha', 0.1);
title(sprintf('Distribúcia amplitúd (%d - %d s)', start_time, end_time));
xlabel('Amplitúda'); ylabel('Hustota');
grid on;

%% 4. ENERGETICKÁ BILANCIA (Iba 1 - 29s)
bands = [0 800; 800 2500; 2500 7000; 7000 15000];
labels = {'Hlboké', 'Stredy', 'Vysoké', 'Ultra'};
[p, f_p] = pwelch(sig, hamming(win), ovp, nfft, fs);
e_vals = arrayfun(@(i) sum(p(f_p >= bands(i,1) & f_p < bands(i,2))), 1:4);

figure('Name','Rozdelenie energie','Color','w');
pie(e_vals, labels);
title(sprintf('Energia v pásmach (%d - %d s)', start_time, end_time));

%% 5. ČASOVÝ PRIEBEH (Iba 1 - 29s)
figure('Name','Časová analýza','Color','w');
t_full = linspace(start_time, end_time, length(sig));

% Horný graf: Celý orezaný úsek
subplot(2,1,1);
plot(t_full, sig, 'Color', col_95);
title(sprintf('Signál od %d do %d sekundy', start_time, end_time));
xlabel('Čas [s]'); ylabel('Amplitúda');
xlim([start_time end_time]);
grid on;

% Dolný graf: Automatický detail (stredná sekunda nahrávky pre ukážku impulzov)
subplot(2,1,2);
mid_point = (start_time + end_time) / 2;
plot(t_full, sig, 'Color', col_95);
title('Detailný pohľad na štruktúru signálu (výrez 0.2s)');
xlabel('Čas [s]'); ylabel('Amplitúda');
% Dynamický zoom na stred nahrávky
xlim([mid_point mid_point + 0.2]); 
grid on;
