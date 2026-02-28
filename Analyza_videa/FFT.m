%% ANALÝZA KULTIVOVANOSTI MOTORA (VOLNOBEH) - OPRAVA CHYBY HORZCAT
clc; clear; close all;

%% 1. Načítanie audia
videoFile = 'TAM_paliva.mp4';
if exist(videoFile,'file') ~= 2
    error('Súbor %s nebol nájdený!', videoFile);
end

[audio, Fs] = audioread(videoFile);
if size(audio,2) == 2, audio = mean(audio,2); end
t = (0:length(audio)-1)/Fs;

%% 2. Definícia sekcií
idx_101 = t >= 5 & t < 29;   
idx_95  = t >= 29;           

segments = {'101 oktan', '95 oktan'};
indices = {idx_101, idx_95};
results = struct();

fprintf('--- FINÁLNE POROVNANIE: 101 vs 95 OKTÁN ---\n');

for i = 1:2
    seg_name = segments{i};
    raw_signal = audio(indices{i});
    raw_signal = raw_signal - mean(raw_signal);
    
    % --- A. ČASOVÁ DOMÉNA ---
    kurt_val = kurtosis(raw_signal);
    [env_upper, ~] = envelope(raw_signal, 100, 'peak');
    stability_val = std(env_upper) * 1000; 

    % --- B. FREKVENČNÁ DOMÉNA (FFT) ---
    N = length(raw_signal);
    X = fft(raw_signal);
    X_mag = abs(X(1:floor(N/2)+1)) / N; 
    f_axis = (0:floor(N/2)) * Fs / N;
    
    X_smooth = movmean(X_mag, 150); 
    noise_floor = median(X_mag);
    snr_val = 20 * log10(max(X_mag) / (noise_floor + eps));
    
    fprintf('\n========== %s ==========\n', seg_name);
    fprintf('Kurtosis (Rázovitosť):      %.2f (menej = lepšie)\n', kurt_val);
    fprintf('Stabilita voľnobehu:        %.2f (menej = lepšie)\n', stability_val);
    fprintf('Čistota chodu (SNR):        %.2f dB (viac = lepšie)\n', snr_val);
    
    % Uloženie dát
    results(i).f = f_axis;
    results(i).mag = 20*log10(X_smooth + eps);
    results(i).snr = snr_val;
end

%% 3. GRAFICKÉ POROVNANIE (BEZ CHYBY HORZCAT)
figure('Color','w','Position', [100, 100, 1000, 650]);

% Horný graf: Celkové spektrum
subplot(2,1,1);
plot(results(1).f, results(1).mag, 'b', 'LineWidth', 1.2); hold on;
plot(results(2).f, results(2).mag, 'r', 'LineWidth', 1.2);
xlim([20 6000]); grid on;
title('FFT Spektrum voľnobehu (0 - 6 kHz)');
ylabel('Amplitúda (dB)');
legend('101 oktan', '95 oktan');

% Dolný graf: Detail na mechanický hluk
subplot(2,1,2);
plot(results(1).f, results(1).mag, 'b', 'LineWidth', 1.5); hold on;
plot(results(2).f, results(2).mag, 'r', 'LineWidth', 1.5);

% BEZPEČNÝ VÝPOČET LIMITOV Y (pre každé pole zvlášť)
mask1 = results(1).f >= 2000 & results(1).f <= 5000;
mask2 = results(2).f >= 2000 & results(2).f <= 5000;
vals1 = results(1).mag(mask1);
vals2 = results(2).mag(mask2);
y_min = min([min(vals1), min(vals2)]) - 2;
y_max = max([max(vals1), max(vals2)]) + 2;

ylim([y_min, y_max]);
xlim([2000 5000]); grid on;
title('Detail: Oblasť vysokofrekvenčného klepotu (2 - 5 kHz)');
xlabel('Frekvencia (Hz)'); ylabel('Amplitúda (dB)');

% Vyhodnotenie
diff_snr = results(1).snr - results(2).snr;
annotation('textbox', [0.15, 0.02, 0.7, 0.06], 'String', ...
    sprintf('ZÁVER: 101 oktan má o %.2f dB lepší pomer signál/šum.\nMotor beží čistejšie a s menším parazitným hlukom.', diff_snr), ...
    'FontSize', 10, 'BackgroundColor', 'y', 'HorizontalAlignment', 'center');
