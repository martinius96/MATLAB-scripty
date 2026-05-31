clear; clc; close all;
%%subory, label
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

% konstanty
rpm = 790; %%otacky motora na volnobehu stredna hodnota
f_crank = rpm / 60;      % Frekvencia klukoveho hriadela --> jedno otocenie (~13.17 Hz)
f_firing = f_crank * 2;  % Frekvencia zazihov pre 4-valec (~26.33 Hz)

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        
        % Orezanie 1s - 29s na spracovanie
        y = y(fs : 29*fs);
        y = y / max(abs(y)); % Normalizácia
        L = length(y);
        
        % Pomocné FFT výpočty
        f = (0:L/2) * (fs/L);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1);
        
        % --- 1. ISO 532: Vnímaná hlasitosť voľnobehu (Zwicker) ---
        % Simulácia nelineárnej citlivosti ľudského ucha (A-weighting filter)
        f_sq = f.^2;
        c1 = 12194^2; c2 = 20.6^2; c3 = 107.7^2; c4 = 737.9^2;
        A_weight = (c1 * f_sq.^2) ./ ((f_sq + c2) .* sqrt((f_sq + c3) .* (f_sq + c4)) .* (f_sq + c1));
        A_weight = A_weight' / max(A_weight); % Normalizácia filtra
        
        % Vnímaná energia po aplikácii filtra ucha
        res(i).iso532_loudness = sum(P .* A_weight); 
        
        % --- 2. ISO 1996: Impulzivita voľnobežných zážihov ---
        % Meria rázovosť jednotlivých zážihov a vstrekov
        window_len = floor(fs * 0.05); %% 50ms okno (obsiahne aspoň jeden zážih)
        num_windows = floor(L / window_len);
        rms_local = zeros(num_windows, 1);
        for w = 1:num_windows
            idx = ((w-1)*window_len + 1) : (w*window_len);
            rms_local(w) = sqrt(mean(y(idx).^2));
        end
        % Pomer špičkového RMS k priemernému RMS voľnobehu
        res(i).iso1996_impulsivity = max(rms_local) / mean(rms_local);
        
        % --- 3. ISO 5130: Ustálená hladina hluku stojaceho vozidla ---
        % Ekvivalentný akustický tlak vážený krivkou A (reprezentácia dB)
        p_ref = 20e-6; % Referenčný akustický tlak
        % Keďže nepoznáme absolútny akustický tlak mikrofónu, počítame relatívnu hladinu
        rms_weighted = sqrt(sum((P .* A_weight).^2));
        res(i).iso5130_db_rel = 20 * log10(rms_weighted / p_ref);
        
        % --- 4. ISO 13373: Order Tracking pre 790 RPM ---
        % Hľadáme presné harmonické násobky frekvencie kľuky a horenia
        harmonics_energy = 0;
        % Sledujeme prvých 5 harmonických poriadkov horenia (26Hz, 52Hz, 79Hz...)
        for k = 1:5
            target_f = k * f_firing;
            [~, h_idx] = min(abs(f - target_f));
            % Sčítame energiu v malom okolí danej frekvencie (tolerancia na kolísanie voľnobehu)
            harmonics_energy = harmonics_energy + sum(P(max(1, h_idx-3):min(length(P), h_idx+3)));
        end
        % Pomer čistých harmonických voľnobehu k celkovému šumu a mechanike
        res(i).iso13373_purity = (harmonics_energy / sum(P)) * 100;
        
        fprintf('Spracované: %s\n', labels{i});
    catch ME
        fprintf('Chyba %s: %s\n', files{i}, ME.message);
    end
end

%%KONZOLA VYPIS
fprintf('\n%-15s | %-15s | %-15s | %-15s | %-15s\n', ...
    'Palivo', 'ISO 532 [Vl.]', 'ISO 1996 [Im.]', 'ISO 5130 [rel dB]', 'ISO 13373 [%]');
fprintf('--------------------------------------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-15.4f | %-15.4f | %-15.4f | %-15.4f\n', ...
        labels{i}, res(i).iso532_loudness, res(i).iso1996_impulsivity, ...
        res(i).iso5130_db_rel, res(i).iso13373_purity);
end

%%GRAFY
figure('Name', 'Analýza voľnobehu motora (790 RPM) podľa ISO', 'Position', [100, 100, 950, 600]);

subplot(2,2,1);
bar([res.iso532_loudness]); set(gca, 'XTickLabel', labels);
title('ISO 532: Vnímaná hlasitosť (Zwicker)'); ylabel('Subjektívna hlasitosť'); grid on;

subplot(2,2,2);
bar([res.iso1996_impulsivity]); set(gca, 'XTickLabel', labels);
title('ISO 1996: Impulzivita voľnobehu'); ylabel('Index rázovosti'); grid on;

subplot(2,2,3);
bar([res.iso5130_db_rel]); set(gca, 'XTickLabel', labels);
title('ISO 5130: Hladina hluku stojaceho vozidla'); ylabel('Relatívne dB(A)'); grid on;

subplot(2,2,4);
bar([res.iso13373_purity]); set(gca, 'XTickLabel', labels);
title('ISO 13373: Čistota voľnobežných cyklov'); ylabel('Zastúpenie harmonických [%]'); grid on;
