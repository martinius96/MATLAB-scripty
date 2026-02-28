%% SPEKTRÁLNA ANALÝZA: 101 vs 95 OKTÁN
% (Nadväzuje na predchádzajúce načítanie premenných audio, Fs, idx_101, idx_95)

% 1. Príprava dát
audio_101 = audio(idx_101);
audio_95  = audio(idx_95);

% Odstránime DC zložku (strednú hodnotu), aby sme videli len čistý zvuk
audio_101 = audio_101 - mean(audio_101);
audio_95  = audio_95 - mean(audio_95);

% 2. Výpočet Výkonovej spektrálnej hustoty (PSD) - Welchova metóda
% Toto vyhladí graf, aby sme nevideli len "šum", ale reálne trendy
[pxx_101, f] = pwelch(audio_101, hanning(4096), 2048, 4096, Fs);
[pxx_95, ~]  = pwelch(audio_95,  hanning(4096), 2048, 4096, Fs);

% Prevod na dB pre lepšiu viditeľnosť rozdielov
psd_101_dB = 10*log10(pxx_101);
psd_95_dB  = 10*log10(pxx_95);

%% 3. Vizualizácia
figure('Color','w', 'Name', 'Frekvenčný odtlačok paliva');

% Graf spektra
plot(f, psd_101_dB, 'r', 'LineWidth', 1.2); hold on;
plot(f, psd_95_dB, 'g', 'LineWidth', 1.2);

% Zameriame sa na počuteľné spektrum motora (do 12 kHz)
xlim([20 12000]); 
grid on;

xlabel('Frekvencia (Hz)');
ylabel('Výkon (dB/Hz)');
title('Porovnanie frekvenčného spektra motora');
legend('101 oktan', '95 oktan');

% 4. Výpočet pomeru Vysoké vs. Nízke frekvencie (Kultivovanosť)
% Nízke (basy motora): 20 - 500 Hz
% Vysoké (cvakanie/ostrosť): 2000 - 10000 Hz
low_idx = f > 20 & f < 500;
high_idx = f > 2000 & f < 10000;

ratio_101 = mean(pxx_101(high_idx)) / mean(pxx_101(low_idx));
ratio_95  = mean(pxx_95(high_idx)) / mean(pxx_95(low_idx));

fprintf('\n--- Spektrálna analýza --- \n');
fprintf('Pomer "Ostré/Tupé" zvuky (101 okt): %.5f\n', ratio_101);
fprintf('Pomer "Ostré/Tupé" zvuky (95 okt):  %.5f\n', ratio_95);
