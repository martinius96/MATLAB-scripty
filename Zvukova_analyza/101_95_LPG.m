clear; clc; close all;

% 1. NAČÍTANIE DÁT
[audio1, fs1] = audioread('TAM_Paliva_3x3.mp4');
[audio2, fs2] = audioread('LPG.mp4');

if size(audio1, 2) > 1, audio1 = mean(audio1, 2); end 
if size(audio2, 2) > 1, audio2 = mean(audio2, 2); end

% 2. DEFINÍCIA SEGMENTOV
segments101 = [0, 3.2; 3.3, 5.9; 6.0, 9.2];
segments95  = [9.3, 12.5; 12.6, 16.6; 16.7, 20.1];
segmentsLPG = [0, 5.0; 11.5, 15.0]; 

% 3. VÝPOČET METRÍK
res101 = analyze_fuel(audio1, fs1, segments101);
res95  = analyze_fuel(audio1, fs1, segments95);
resLPG = analyze_fuel(audio2, fs2, segmentsLPG);

% --- TU JE TÁ ZMENA: VÝPIS PRESNEJ FREKVENCIE ---
fprintf('\n--- ANALÝZA REZONANCIE LPG ---\n');
[pxxLPG, f_LPG] = get_stats(audio2, fs2, segmentsLPG);
% Hľadáme v pásme 800-1300 Hz
range = (f_LPG >= 800 & f_LPG <= 1300);
[~, idx_max] = max(pxxLPG(range));
f_roi = f_LPG(range);
presna_frekvencia = f_roi(idx_max);
fprintf('Presná frekvencia peaku vstrekovačov LPG: %.1f Hz\n', presna_frekvencia);

% 4. VIZUALIZÁCIA A POROVNANIE
compare_spectra(audio1, fs1, audio2, fs2, segments101, segments95, segmentsLPG);
display_results(res101, res95, resLPG);

% --- POMOCNÉ FUNKCIE ---
function s = analyze_fuel(audio, fs, segs)
    len = length(audio);
    for i = 1:size(segs, 1)
        s1 = max(1, round(segs(i,1)*fs)+1);
        s2 = min(len, round(segs(i,2)*fs));
        sig = audio(s1:s2);
        sig = sig - mean(sig); 
        s.rms(i) = rms(sig);
        s.kurt(i) = kurtosis(sig);
        fft_sig = fft(sig);
        psd = abs(fft_sig(1:floor(length(sig)/2)+1)).^2;
        psd_norm = psd / (sum(psd) + eps);
        s.ent(i) = -sum(psd_norm .* log2(psd_norm + eps));
    end
    s.avg_rms = mean(s.rms); s.avg_kurt = mean(s.kurt); s.avg_ent = mean(s.ent);
end

function [pxx_avg, f] = get_stats(audio, fs, segs)
    len = length(audio);
    all_pxx = [];
    for i = 1:size(segs, 1)
        s1 = max(1, round(segs(i,1)*fs)+1);
        s2 = min(len, round(segs(i,2)*fs));
        [pxx, f] = pwelch(audio(s1:s2), hamming(1024), 512, 1024, fs);
        all_pxx(:, i) = pxx;
    end
    pxx_avg = mean(all_pxx, 2);
end

function compare_spectra(a1, fs1, a2, fs2, s101, s95, sLPG)
    [pxx101, f1] = get_stats(a1, fs1, s101);
    [pxx95, ~]   = get_stats(a1, fs1, s95);
    [pxxLPG, f2] = get_stats(a2, fs2, sLPG);
    
    figure('Name', 'Porovnanie spektier', 'Color', 'w');
    plot(f1, 10*log10(pxx101 + eps), 'r', 'LineWidth', 1.2); hold on;
    plot(f1, 10*log10(pxx95 + eps), 'b', 'LineWidth', 1.2);
    plot(f2, 10*log10(pxxLPG + eps), 'g', 'LineWidth', 1.5);
    grid on; legend('101 Oct', '95 Oct', 'LPG'); 
    title('Spektrálna hustota (PSD)'); xlabel('Hz'); ylabel('dB/Hz'); xlim([0 5000]);
end

function display_results(r101, r95, rLPG)
    fprintf('\n--- ZÁKLADNÉ METRIKY ---\n');
    fprintf('Metric   | 101 Oct    | 95 Oct     | LPG\n');
    fprintf('Kurtosis | %10.4f | %10.4f | %10.4f\n', r101.avg_kurt, r95.avg_kurt, rLPG.avg_kurt);
    fprintf('Entropia | %10.4f | %10.4f | %10.4f\n', r101.avg_ent, r95.avg_ent, rLPG.avg_ent);
    fprintf('RMS      | %10.4f | %10.4f | %10.4f\n', r101.avg_rms, r95.avg_rms, rLPG.avg_rms);
end
