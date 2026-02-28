%% POROVNANIE HRUBOSTI CHODU MOTORA - 101 vs 95 OKTAN
%% RMS, graf

clc;
clear;
close all;

%% 1. Nastavenie nazvu videa
videoFile = 'TAM_paliva.mp4';   % subor musi byt v aktualnom priecinku

%% 2. Nacitanie audia z videa
[audio, Fs] = audioread(videoFile);

% Ak je stereo, preved na mono
if size(audio,2) == 2
    audio = mean(audio,2);
end

%% 3. Vypocet RMS hlasitosti
window_ms = 50;
windowLength = round((window_ms/1000)*Fs);

rms_vals = sqrt(movmean(audio.^2, windowLength));

%% 4. Prevod na decibely
rms_dB = 20*log10(rms_vals + eps);

%% 5. Casova os
t = (0:length(rms_dB)-1)/Fs;

%% 6. Najdenie maxima
[max_dB, idx] = max(rms_dB);
t_max = t(idx);

%% 7. Vypis
fprintf('\n==============================\n');
fprintf('Maximalna hlasitost: %.2f dB\n', max_dB);
fprintf('Cas maxima: %.3f sekundy\n', t_max);
fprintf('==============================\n\n');

%% 8. Graf
figure('Color','w');
plot(t, rms_dB, 'b');
hold on;
plot(t_max, max_dB, 'ro', 'MarkerSize', 8, 'LineWidth', 2);

xlabel('Cas (s)');
ylabel('Hlasitost (dB)');
title('RMS hlasitost zvuku v case');
grid on;
legend('Hlasitost (RMS dB)', 'Maximum');
