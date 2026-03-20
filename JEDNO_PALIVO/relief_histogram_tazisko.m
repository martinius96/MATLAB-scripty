clear; clc; close all;

%% 1. NACITANIE A PRÍPRAVA DAT
% Názov vášho súboru (zmeňte podľa potreby)
file_name = '95_TAM_30.mp4'; 

try
    [audio, fs] = audioread(file_name);
catch
    error('Súbor %s nebol nájdený. Skontrolujte názov a cestu.', file_name);
end

% Prevod na mono (priemer kanálov), ak je nahrávka stereo
if size(audio,2) > 1
    audio = mean(audio,2);
end

% Orezanie na presných 30 sekúnd (ak je nahrávka dlhšia)
target_duration = 30; 
max_samples = round(target_duration * fs);
if length(audio) > max_samples
    sig = audio(1:max_samples);
else
    sig = audio;
end

% Parametre pre analýzu
win = hamming(1024); 
ovp = 512; 
nfft = 1024;
col = 'b'; % Modrá farba pre 95 oktánov

%% 2. 3D WATERFALL ANALÝZA
figure('Name','Waterfall Analýza: 95 Oktán','Color','w','Position',[100 100 800 600]);
dur_show = 2.0; % Zobraziť detail prvých 2 sekúnd
data_plot = sig(1:min(length(sig), round(dur_show*fs)));

[s, f, t] = spectrogram(data_plot, win, ovp, nfft, fs);
waterfall(f/1000, t, 20*log10(abs(s')+eps));

title('3D Waterfall Spektrum (95 Oktán)');
xlabel('Frekvencia [kHz]'); 
ylabel('Čas [s]'); 
zlabel('Amplitúda [dB]');
view(30, 45); 
colormap jet;
xlim([0 6]);      % Zobrazenie do 6 kHz
zlim([-200 50]);  % Zjednotený rozsah v dB
grid on;

%% 3. FÁZOVÝ PORTRÉT (State-Space)
figure('Name','Fázový portrét','Color','w');
% Vykreslenie každého 5. vzorky pre lepšiu prehľadnosť pri dlhej nahrávke
plot(sig(1:5:end-1), sig(2:5:end), '.', 'Color', col, 'MarkerSize', 0.1);
title('Fázový portrét signálu (95 Oktán)');
xlabel('x(t)'); 
ylabel('x(t+\tau)');
grid on; 
axis tight;

%% 4. SPEKTRÁLNE ŤAŽISKO V ČASE
figure('Name','Spektrálne ťažisko','Color','w');
[S, F, T] = spectrogram(sig, win, ovp, nfft, fs);
S_abs = abs(S);
% Výpočet ťažiska: $\frac{\sum f \cdot A(f)}{\sum A(f)}$
centroid = (F' * S_abs) ./ sum(S_abs);

plot(T, centroid, col, 'LineWidth', 1.5);
title('Vývoj spektrálneho ťažiska v čase');
xlabel('Čas [s]'); 
ylabel('Frekvencia [Hz]');
ylim([500 3500]); 
grid on;

%% 5. ŠTATISTICKÁ DISTRIBÚCIA A PSD
figure('Name','Štatistika a Spektrum','Color','w');
subplot(2,1,1);
histogram(sig, 150, 'Normalization', 'pdf', 'FaceColor', col, 'FaceAlpha', 0.6);
title('Distribúcia amplitúd (Histogram)');
xlabel('Amplitúda'); 
ylabel('Hustota pravdepodobnosti');
xlim([-0.2 0.2]); 
grid on;

subplot(2,1,2);
[psd, f_psd] = pwelch(sig, win, ovp, nfft, fs);
plot(f_psd/1000, 10*log10(psd), 'Color', col, 'LineWidth', 1);
title('Výkonová spektrálna hustota (PSD)');
xlabel('Frekvencia [kHz]'); 
ylabel('Výkon [dB/Hz]');
xlim([0 10]); 
grid on;

%% 6. AUTOKORELÁCIA (Periodicita)
figure('Name','Autokorelačná funkcia','Color','w');
% Výpočet na reprezentatívnej časti signálu (napr. prvých 20 000 vzoriek)
[r, lags] = xcorr(sig(1:min(length(sig), 20000)), 1500, 'coeff');
plot(lags/fs, r, col);
title('Autokorelácia (Analýza periodicity)');
xlabel('Oneskorenie [s]'); 
ylabel('Koeficient korelácie');
grid on; 
ylim([-1 1]);
