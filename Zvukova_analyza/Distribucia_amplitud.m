clear; clc; close all;

%% 1. NACITANIE DAT
[audio1, fs1] = audioread('TAM_Paliva_3x3.mp4');
[audio2, fs2] = audioread('LPG.mp4');

if size(audio1,2) > 1, audio1 = mean(audio1,2); end
if size(audio2,2) > 1, audio2 = mean(audio2,2); end

%% 2. TVOJE DEFINOVANÉ SEGMENTY
segments101 = [0, 3.2; 3.3, 5.9; 6.0, 9.2];
segments95  = [9.3, 12.5; 12.6, 16.6; 16.7, 20.1];
segmentsLPG = [0, 5.0; 5.1, 11.4];

% Funkcia na extrakciu
extract = @(au, fs, segs) cell2mat(arrayfun(@(i) au(round(segs(i,1)*fs)+1 : round(segs(i,2)*fs)), 1:size(segs,1), 'UniformOutput', false)');

sig101 = extract(audio1, fs1, segments101);
sig95  = extract(audio1, fs1, segments95);
sigLPG = extract(audio2, fs2, segmentsLPG);

%% 3. VIZUALIZÁCIA: 3D WATERFALL
figure('Name','3D Waterfall Analýza','Color','w','Position',[50 100 1200 500]);

subplot(1,2,1);
dur1 = min(length(sig101), round(1.5*fs1));
[s1, f1, t1] = spectrogram(sig101(1:dur1), hamming(1024), 512, 1024, fs1);
waterfall(f1/1000, t1, 20*log10(abs(s1')+eps));
view(30, 45); colormap jet; title('Spektrálny reliéf: 101 Oct');
xlabel('kHz'); ylabel('s'); zlabel('dB'); xlim([0 6]);

subplot(1,2,2);
durL = min(length(sigLPG), round(1.5*fs2));
[sL, fL, tL] = spectrogram(sigLPG(1:durL), hamming(1024), 512, 1024, fs2);
waterfall(fL/1000, tL, 20*log10(abs(sL')+eps));
view(30, 45); colormap jet; title('Spektrálny reliéf: LPG');
xlabel('kHz'); ylabel('s'); zlabel('dB'); xlim([0 6]);

%% 4. VIZUALIZÁCIA: HISTOGRAM (Logaritmický pre detekciu špičiek)
figure('Name','Distribúcia amplitúd','Color','w');
hold on;
histogram(sig101, 250, 'Normalization', 'pdf', 'FaceColor', 'r', 'EdgeAlpha', 0.1, 'FaceAlpha', 0.3);
histogram(sig95, 250, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeAlpha', 0.1, 'FaceAlpha', 0.3);
histogram(sigLPG, 250, 'Normalization', 'pdf', 'FaceColor', 'g', 'EdgeAlpha', 0.1, 'FaceAlpha', 0.3);
grid on; xlim([-0.15 0.15]);
legend('101 Oct', '95 Oct', 'LPG');
title('Hustota pravdepodobnosti amplitúd');
xlabel('Amplitúda'); ylabel('Hustota');

%% 5. VIZUALIZÁCIA: ENERGETICKÉ KOLÁČE
bands = [0 800; 800 2500; 2500 7000; 7000 15000];
labels = {'Hlboké', 'Stredy', 'Vysoké', 'Ultra'};

[p1, f_p] = pwelch(sig101, hamming(1024), 512, 1024, fs1);
e101 = arrayfun(@(i) sum(p1(f_p >= bands(i,1) & f_p < bands(i,2))), 1:4);
[pL, ~] = pwelch(sigLPG, hamming(1024), 512, 1024, fs2);
eLPG = arrayfun(@(i) sum(pL(f_p >= bands(i,1) & f_p < bands(i,2))), 1:4);

figure('Name','Energetická bilancia','Color','w');
subplot(1,2,1); pie(e101, labels); title('101 Oct');
subplot(1,2,2); pie(eLPG, labels); title('LPG');

%% 6. ČASOVÝ DETAIL (Zoom na pulzy)
figure('Name','Detail signálu','Color','w');
t1 = (0:length(sig101)-1)/fs1;
tL = (0:length(sigLPG)-1)/fs2;

subplot(2,1,1);
plot(t1, sig101, 'r'); title('Benzín 101 Oct'); grid on; xlim([0.5 0.7]);
subplot(2,1,2);
plot(tL, sigLPG, 'g'); title('LPG'); grid on; xlim([0.5 0.7]); xlabel('Čas [s]');
