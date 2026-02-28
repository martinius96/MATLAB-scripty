%% ANALYZA FFT MOTORA - POROVNANIE 101 vs 95 OKTAN

clc;
clear;
close all;

%% 1. Nazov suboru
videoFile = 'TAM_paliva.mp4';

if exist(videoFile,'file') ~= 2
    error('Subor TAM_paliva.mp4 sa nenachadza v Current Folder.');
end

%% 2. Nacitanie audia
[audio, Fs] = audioread(videoFile);

if size(audio,2) == 2
    audio = mean(audio,2);
end

t = (0:length(audio)-1)/Fs;

%% 3. Rozdelenie na sekcie
idx_101 = t >= 5 & t < 29;   % 101 oktan
idx_95  = t >= 29;           % 95 oktan

segments = {'101 oktan', '95 oktan'};
indices = {idx_101, idx_95};
colors = {'b','r'};  % farby pre graf

figure('Color','w');
hold on;

for i = 1:2
    seg_name = segments{i};
    idx = indices{i};
    
    seg_audio = audio(idx);
    
    % FFT
    NFFT = 2^nextpow2(length(seg_audio));
    Y = fft(seg_audio, NFFT);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    magnitude = abs(Y(1:NFFT/2+1));
    
    % Normalizacia na RMS alebo max (volitelne)
    magnitude = magnitude / max(magnitude);
    
    % Vykreslenie
    plot(f, 20*log10(magnitude+eps), colors{i}, 'LineWidth', 1.5);
    
    % Energeticke sumy v pasmach (volitelne)
    energy_low = sum(magnitude(f>=50 & f<=200).^2);
    energy_mid = sum(magnitude(f>200 & f<=500).^2);
    energy_high = sum(magnitude(f>500 & f<=2000).^2);
    
    fprintf('\n%s:\n', seg_name);
    fprintf('Energia 50-200 Hz: %.4f\n', energy_low);
    fprintf('Energia 200-500 Hz: %.4f\n', energy_mid);
    fprintf('Energia 500-2000 Hz: %.4f\n', energy_high);
end

xlabel('Frekvencia [Hz]');
ylabel('Amplituda [dB, normalizovana]');
title('Porovnanie FFT motora - 101 vs 95 oktan');
legend('101 oktan','95 oktan');
xlim([0 5000]);
grid on;
