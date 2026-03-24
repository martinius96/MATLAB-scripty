% LOGARITHMIC ENGINE MASTER-ANALYSIS v6.0
% Špecializované logaritmické a nelineárne metriky

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4',};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- SPUŠŤAM LOGARITMICKÝ DATA-MINING ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        y = y(fs : 29*fs);
        y = y / max(abs(y));
        eps_val = eps; % Malá konštanta proti log(0)

        % --- 1. LOG-ENERGY ENTROPY ---
        % Meria komplexnosť energetických zmien v dB
        y_sq = y.^2 + eps_val;
        res(i).log_entropy = -sum(y_sq .* log(y_sq));

        % --- 2. SPECTRAL SLOPE (Log-Log Regression) ---
        L = length(y);
        Y = abs(fft(y)/L);
        P = Y(1:floor(L/2)+1);
        freqs = (0:floor(L/2))' * (fs/L);
        
        % Analýza len v pásme 100Hz - 8kHz (kde je mechanický zvuk)
        idx = freqs >= 100 & freqs <= 8000;
        logF = log10(freqs(idx));
        logP = log10(P(idx) + eps_val);
        p_coeff = polyfit(logF, logP, 1);
        res(i).slope = p_coeff(1);

        % --- 3. RMS DYNAMIC RANGE (v dB) ---
        win = round(0.05 * fs); % 50ms okná
        numW = floor(length(y)/win);
        rms_db = zeros(numW, 1);
        for w = 1:numW
            segment = y((w-1)*win+1 : w*win);
            rms_db(w) = 20 * log10(sqrt(mean(segment.^2)) + eps_val);
        end
        % Rozsah medzi 5. a 95. percentilom v dB
        res(i).dyn_range = prctile(rms_db, 95) - prctile(rms_db, 5);

        fprintf('Hotovo: %s\n', labels{i});
    catch ME
        fprintf('Chyba: %s\n', ME.message);
    end
end

% --- TABUĽKA VÝSLEDKOV ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'Log-Entropia', 'Slope (Sklon)', 'Dyn. Rozsah [dB]');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.2e | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).log_entropy, res(i).slope, res(i).dyn_range);
end

fprintf('\nInterpretácia:\n');
fprintf('1. Log-Entropia: Vyššie číslo = "bohatší", ale menej predvídateľný zvuk.\n');
fprintf('2. Slope: Čím strmší (viac negatívny), tým menej mechanického vrieskania.\n');
fprintf('3. Dyn. Rozsah: Nižšie dB = motor "drží lajnu" a nepulzuje.\n');
