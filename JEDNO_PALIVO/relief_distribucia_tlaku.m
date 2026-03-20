clear; clc; close all;

%% 1. NAČÍTANIE A PRÍPRAVA DÁT (0 - 30s)
filename = '95_TAM_30.mp4'; 

try
    [audio, fs] = audioread(filename);
catch
    error('Súbor %s nebol nájdený!', filename);
end

% Prevod na mono
if size(audio,2) > 1, audio = mean(audio,2); end

% Orezanie na 30 sekúnd
target_dur = 30;
max_samples = min(length(audio), round(target_dur * fs));
sig = audio(1:max_samples);

% Parametre pre analýzu
win = 1024; ovp = 512; nfft = 1024;
col_95 = [0 0.4470 0.7410]; % Štýlová modrá pre 95 oktán

%% 2. VIZUALIZÁCIA: 3D WATERFALL (Spektrálny reliéf)
figure('Name','3D Waterfall Analýza: 95 Oktán','Color','w','Position',[50 100 1000 600]);

% Zobrazenie detailu (prvé 2 sekundy pre lepšiu viditeľnosť reliefu)
dur_show = min(length(sig), round(2.0 * fs));
[s, f, t] = spectrogram(sig(1:dur_show), hamming(win), ovp, nfft, fs);

waterfall(f/1000, t, 20*log10(abs(s')+eps));
view(30, 45); 
colormap jet; 
title('Spektrálny reliéf (Detail prvých 2s)');
xlabel('Frekvencia [kHz]'); ylabel('Čas [s]'); zlabel('Amplitúda [dB]');
xlim([0 8]); % Zameranie na hlavné frekvencie
zlim([-180 40]);
grid on;

%% 3. VIZUALIZÁCIA: HISTOGRAM (Distribúcia amplitúd)
figure('Name','Hustota amplitúd','Color','w');
histogram(sig, 300, 'Normalization', 'pdf', 'FaceColor', col_95, 'EdgeAlpha', 0.1);
grid on; 
xlim([-0.15 0.15]);
title('Štatistická distribúcia tlaku/zvuku (95 Oktán)');
xlabel('Amplitúda'); ylabel('Hustota pravdepodobnosti');

%% 4. VIZUALIZÁCIA: ENERGETICKÁ BILANCIA (Frekvenčné pásma)
% Definícia pásiem v Hz
bands = [0 800; 800 2500; 2500 7000; 7000 15000];
labels = {'Hlboké (Basy)', 'Stredy', 'Vysoké', 'Ultra'};

% Výpočet PSD (Power Spectral Density)
[p, f_p] = pwelch(sig, hamming(win), ovp, nfft, fs);

% Integrácia energie v pásmach
e_vals = arrayfun(@(i) sum(p(f_p >= bands(i,1) & f_p < bands(i,2))), 1:4);

figure('Name','Rozdelenie energie','Color','w');
pie(e_vals, labels);
title('Energetická bilancia spaľovania (95 Oktán)');

%% 5. ČASOVÝ DETAIL (Priebeh impulzov)
figure('Name','Časová analýza','Color','w');
t_full = (0:length(sig)-1)/fs;

% Celý priebeh (0-30s)
subplot(2,1,1);
plot(t_full, sig, 'Color', col_95);
title('Kompletný 30s záznam');
xlabel('Čas [s]'); ylabel('Amplitúda');
grid on; axis tight;

% Zoom na detail (napr. medzi 5.0s a 5.2s pre zobrazenie jednotlivých zážihov)
subplot(2,1,2);
plot(t_full, sig, 'Color', col_95, 'LineWidth', 1);
title('Detail jednotlivých impulzov (Zoom)');
xlabel('Čas [s]'); ylabel('Amplitúda');
xlim([5.0 5.2]); % Zobrazenie 200ms úseku
grid on;
