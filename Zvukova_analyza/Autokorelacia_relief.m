clear; clc; close all;
%% 1. NACITANIE A PRÍPRAVA
[audio1, fs1] = audioread('TAM_Paliva_3x3.mp4');
[audio2, fs2] = audioread('LPG.mp4');
[audio3, fs3] = audioread('misfire.mp3');

if size(audio1,2) > 1, audio1 = mean(audio1,2); end
if size(audio2,2) > 1, audio2 = mean(audio2,2); end
if size(audio3,2) > 1, audio3 = mean(audio3,2); end

% Zjednotenie vzorkovacej frekvencie na fs1
if fs2 ~= fs1, audio2 = resample(audio2, fs1, fs2); end
if fs3 ~= fs1, audio3 = resample(audio3, fs1, fs3); end

segments101 = [0, 3.2; 3.3, 5.9; 6.0, 9.2];
segments95  = [9.3, 12.5; 12.6, 16.6; 16.7, 20.1];
segmentsLPG = [0, 5.0; 5.1, 11.4];

extract = @(au, fs, segs) cell2mat(arrayfun(@(i) au(round(segs(i,1)*fs)+1 : round(segs(i,2)*fs)), 1:size(segs,1), 'UniformOutput', false)');
sig101 = extract(audio1, fs1, segments101);
sig95  = extract(audio1, fs1, segments95);
sigLPG = extract(audio2, fs1, segmentsLPG);
sigMIS = audio3(1:min(length(audio3), 50000)); % Vezmeme kus misfire signálu

sigs = {sig101, sig95, sigLPG, sigMIS};
titles = {'101 Oct', '95 Oct', 'LPG', 'MISFIRE'};
cols = {'r', 'b', 'g', 'k'}; % 'k' (čierna) pre misfire

%% 2. 3D WATERFALL
figure('Name','Waterfall Analýza','Color','w','Position',[50 100 1400 400]);
win = hamming(1024); ovp = 512; nfft = 1024; dur_s = 1.2;
for k = 1:4
    subplot(1,4,k);
    [s, f, t] = spectrogram(sigs{k}(1:min(length(sigs{k}), round(dur_s*fs1))), win, ovp, nfft, fs1);
    waterfall(f/1000, t, 20*log10(abs(s')+eps));
    title(['Relief: ' titles{k}]); view(30, 45); colormap jet; xlim([0 6]);
end

%% 3. FÁZOVÝ PORTRÉT (State-Space geometrie)

figure('Name','Fázový portrét (State-Space)','Color','w');
for k = 1:4
    subplot(2,2,k); % Zmenené na 2x2 pre lepšiu prehľadnosť
    s = sigs{k};
    plot(s(1:end-1), s(2:end), '.', 'Color', cols{k}, 'MarkerSize', 0.2);
    title(['Fáza: ' titles{k}]); grid on; axis tight;
end

%% 4. SPEKTRÁLNE ŤAŽISKO

figure('Name','Spektrálne ťažisko v čase','Color','w');
for k = 1:4
    subplot(4,1,k);
    [S, F, T] = spectrogram(sigs{k}, win, ovp, nfft, fs1);
    S_abs = abs(S);
    centroid = (F' * S_abs) ./ sum(S_abs);
    plot(T, centroid, cols{k}); 
    title(['Ťažisko: ' titles{k}]); grid on; ylabel('Hz');
end

%% 5. HISTOGRAM A ENERGIA
figure('Name','Štatistika a Energia','Color','w');
subplot(1,2,1); hold on;
for k = 1:4
    histogram(sigs{k}, 100, 'Normalization', 'pdf', 'FaceColor', cols{k}, 'FaceAlpha', 0.1);
end
title('Distribúcia amplitúd'); xlim([-0.1 0.1]); legend(titles);

subplot(1,2,2);
[p1, f] = pwelch(sig101, win, ovp, nfft, fs1);
[p4, ~] = pwelch(sigMIS, win, ovp, nfft, fs1);
e = [sum(p1(f<2000)), sum(p4(f<2000))];
pie(e, {'101 Oct', 'MISFIRE'}); title('Energia: 101 Oct vs Misfire');

%% 6. AUTOKORELÁCIA

figure('Name','Autokorelačná funkcia','Color','w');
for k = 1:4
    subplot(4,1,k);
    [r, lags] = xcorr(sigs{k}(1:min(length(sigs{k}), 5000)), 500, 'coeff');
    plot(lags, r, cols{k}); title(['Periodickosť: ' titles{k}]); grid on;
end
