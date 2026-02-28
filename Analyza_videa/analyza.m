%% POROVNANIE HRUBOSTI CHODU MOTORA - 101 vs 95 OKTAN
%% RMS
%% STD (hrubost kolisania)
%% Spektralny centroid

clc;
clear;
close all;

videoFile = 'TAM_paliva.mp4';

if exist(videoFile,'file') ~= 2
    error('Subor TAM.mp4 sa nenachadza v Current Folder.');
end

%% 1. Nacitanie audia
[audio, Fs] = audioread(videoFile);

if size(audio,2) == 2
    audio = mean(audio,2);
end

t = (0:length(audio)-1)/Fs;

%% 2. Vyrezanie segmentov
seg_101 = audio(t >= 5 & t < 29);
seg_95  = audio(t >= 29);

%% 3. RMS hlasitost
rms_101 = sqrt(mean(seg_101.^2));
rms_95  = sqrt(mean(seg_95.^2));

rms_101_dB = 20*log10(rms_101 + eps);
rms_95_dB  = 20*log10(rms_95 + eps);

%% 4. Variabilita (hrubost kolisania)
std_101 = std(seg_101);
std_95  = std(seg_95);

%% 5. Spektralna analyza
NFFT = 2^nextpow2(length(seg_101));
f = Fs/2*linspace(0,1,NFFT/2+1);

FFT_101 = abs(fft(seg_101,NFFT));
FFT_95  = abs(fft(seg_95,NFFT));

spec_101 = FFT_101(1:NFFT/2+1);
spec_95  = FFT_95(1:NFFT/2+1);

% Spektralny centroid (vyssia hodnota = viac vysokych frekvencii)
centroid_101 = sum(f'.*spec_101)/sum(spec_101);
centroid_95  = sum(f'.*spec_95)/sum(spec_95);

%% 6. Vypis vysledkov
fprintf('\n================ POROVNANIE =================\n');
fprintf('101 oktan:\n');
fprintf('RMS: %.2f dBFS\n', rms_101_dB);
fprintf('STD (hrubost kolisania): %.6f\n', std_101);
fprintf('Spektralny centroid: %.2f Hz\n\n', centroid_101);

fprintf('95 oktan:\n');
fprintf('RMS: %.2f dBFS\n', rms_95_dB);
fprintf('STD (hrubost kolisania): %.6f\n', std_95);
fprintf('Spektralny centroid: %.2f Hz\n', centroid_95);
fprintf('=============================================\n\n');

%% 7. Graf spektra
figure('Color','w');
plot(f, spec_101, 'b'); hold on;
plot(f, spec_95, 'r');
xlim([0 5000]);
xlabel('Frekvencia (Hz)');
ylabel('Amplituda');
legend('101 oktan','95 oktan');
title('Porovnanie spektra motora');
grid on;
