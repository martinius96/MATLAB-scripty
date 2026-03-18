clear; clc; close all;

%% 1. NACITANIE A PRÍPRAVA DAT
% Načítanie súborov
[audio1, fs1] = audioread('TAM_Paliva_3x3.mp4');
[audio2, fs2] = audioread('LPG.mp4');
[audio3, fs3] = audioread('astra.mp3');

% Prevod na mono (priemer kanálov)
if size(audio1,2) > 1, audio1 = mean(audio1,2); end
if size(audio2,2) > 1, audio2 = mean(audio2,2); end
if size(audio3,2) > 1, audio3 = mean(audio3,2); end

% Zjednotenie vzorkovacej frekvencie na fs1 (všetko na rovnaký základ)
if fs2 ~= fs1, audio2 = resample(audio2, fs1, fs2); end
if fs3 ~= fs1, audio3 = resample(audio3, fs1, fs3); end

% Definícia segmentov pre palivá
segments101 = [0, 3.2; 3.3, 5.9; 6.0, 9.2];
segments95  = [9.3, 12.5; 12.6, 16.6; 16.7, 20.1];
segmentsLPG = [0, 5.0; 5.1, 11.4];

% Anonymná funkcia na extrakciu a spojenie segmentov
extract = @(au, fs, segs) cell2mat(arrayfun(@(i) au(round(segs(i,1)*fs)+1 : round(segs(i,2)*fs)), 1:size(segs,1), 'UniformOutput', false)');

% Príprava jednotlivých signálov
sig101 = extract(audio1, fs1, segments101);
sig95  = extract(audio1, fs1, segments95);
sigLPG = extract(audio2, fs1, segmentsLPG);

% --- ÚPRAVA ASTRA.MP3 (MISFIRE) NA 6 SEKÚND ---
target_dur = 6; 
target_smp = round(target_dur * fs1);

if length(audio3) >= target_smp
    sigMIS = audio3(1:target_smp);
else
    % Ak je nahrávka kratšia ako 6s, doplníme ticho (nuly)
    sigMIS = padarray(audio3, [target_smp - length(audio3), 0], 0, 'post');
end

% Kolekcia pre cykly
sigs = {sig101, sig95, sigLPG, sigMIS};
titles = {'101 Oct', '95 Oct', 'LPG', 'MISFIRE (Astra)'};
cols = {'r', 'b', 'g', 'k'};

%% 2. 3D WATERFALL (Zjednotená os Z: -200 až 50 dB)
figure('Name','Waterfall Analýza (Zjednotené dB)','Color','w','Position',[50 100 1400 450]);
win = hamming(1024); ovp = 512; nfft = 1024; 
dur_show = 2.0; % Zobraziť prvé 2 sekundy pre lepšiu viditeľnosť detailov

for k = 1:4
    subplot(1,4,k);
    current_sig = sigs{k};
    % Orezanie pre graf (aby nebol waterfall príliš hustý)
    data_plot = current_sig(1:min(length(current_sig), round(dur_show*fs1)));
    
    [s, f, t] = spectrogram(data_plot, win, ovp, nfft, fs1);
    waterfall(f/1000, t, 20*log10(abs(s')+eps));
    
    title(titles{k}); 
    view(30, 45); 
    colormap jet;
    
    % --- ZJEDNOTENIE OSÍ ---
    xlim([0 6]);      % Frekvencia do 6 kHz
    zlim([-200 50]);  % Amplitúda v dB (podľa požiadavky)
    xlabel('kHz'); ylabel('s'); zlabel('dB');
end

%% 3. FÁZOVÝ PORTRÉT (State-Space)
figure('Name','Fázový portrét','Color','w');
for k = 1:4
    subplot(2,2,k);
    s = sigs{k};
    % Vykreslenie každého 5. vzorky pre plynulosť grafu pri 6s dĺžke
    plot(s(1:5:end-1), s(2:5:end), '.', 'Color', cols{k}, 'MarkerSize', 0.1);
    title(['Fáza: ' titles{k}]); 
    grid on; axis tight;
    xlabel('x(t)'); ylabel('x(t+\tau)');
end

%% 4. SPEKTRÁLNE ŤAŽISKO (Jednotná os frekvencie)
figure('Name','Spektrálne ťažisko','Color','w');
for k = 1:4
    subplot(4,1,k);
    [S, F, T] = spectrogram(sigs{k}, win, ovp, nfft, fs1);
    S_abs = abs(S);
    centroid = (F' * S_abs) ./ sum(S_abs);
    
    plot(T, centroid, cols{k}, 'LineWidth', 1); 
    title(['Ťažisko: ' titles{k}]); 
    grid on; 
    ylabel('Hz'); 
    ylim([500 3500]); % Zjednotený rozsah frekvencie ťažiska
end

%% 5. HISTOGRAM A ENERGIA
figure('Name','Štatistika a Energia','Color','w');
subplot(1,2,1); hold on;
for k = 1:4
    histogram(sigs{k}, 100, 'Normalization', 'pdf', 'FaceColor', cols{k}, 'FaceAlpha', 0.2);
end
title('Distribúcia amplitúd'); xlim([-0.2 0.2]); grid on; legend(titles);

subplot(1,2,2);
[p1, f_psd] = pwelch(sig101, win, ovp, nfft, fs1);
[p4, ~] = pwelch(sigMIS, win, ovp, nfft, fs1);
% Porovnanie energie v nízkofrekvenčnej oblasti (do 2kHz)
e = [sum(p1(f_psd<2000)), sum(p4(f_psd<2000))];
pie(e, {'101 Oct', 'MISFIRE'}); 
title('Energia (<2kHz): 101 Oct vs Misfire');

%% 6. AUTOKORELÁCIA (Analýza periodicity)
figure('Name','Autokorelačná funkcia','Color','w');
for k = 1:4
    subplot(4,1,k);
    % Výpočet na prvých 10 000 vzorkách pre stabilitu
    [r, lags] = xcorr(sigs{k}(1:min(length(sigs{k}), 10000)), 1000, 'coeff');
    plot(lags, r, cols{k}); 
    title(['Periodickosť: ' titles{k}]); 
    grid on; ylim([-1 1]);
end
