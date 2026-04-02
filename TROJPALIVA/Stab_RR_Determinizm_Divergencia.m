% ENGINE SOUND ANALYZER v2.0
% Pokročilá analýza zvuku motora (stabilita + determinism + spektrum)

clear; clc;

files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- ANALÝZA ZVUKU MOTORA (v2.0) ---\n\n');

for i = 1:length(files)
    try
        % --- NAČÍTANIE ---
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1
            y = mean(y, 2);
        end

        % 2 sekundy signálu
        y = y(fs : 3*fs);

        % normalizácia
        y = (y - mean(y)) / std(y);
        N = length(y);

        %% --- 1. RECURRENCE RATE (RR) ---
        delay = 15;
        y1 = y(1:end-delay);
        y2 = y(delay+1:end);

        dist = sqrt((y1(1:end-1) - y1(2:end)).^2 + ...
                    (y2(1:end-1) - y2(2:end)).^2);

        res(i).RR = 1 / (std(dist) + eps);

        %% --- 2. DETERMINISM (OPRAVENÝ) ---
        diffs = abs(diff(y));

        threshold = 0.3 * std(diffs);   % 🔥 kľúčová zmena
        res(i).DET = sum(diffs < threshold) / length(diffs);

        %% --- 3. DIVERGENCIA ---
        d0 = abs(y(1:100) - y(2:101));
        d1 = abs(y(101:200) - y(102:201));

        res(i).DIV = mean(log(d1 ./ (d0 + eps)));

        %% --- 4. SPECTRAL FLATNESS (šum vs tón) ---
        Y = abs(fft(y));
        Y = Y(1:floor(end/2));

        res(i).flatness = exp(mean(log(Y + eps))) / (mean(Y + eps));

        %% --- 5. VARIABILITA AMPLITÚDY ---
        res(i).var_amp = std(abs(y));

        fprintf('Spracované: %s\n', labels{i});

    catch ME
        fprintf('Chyba: %s\n', ME.message);
    end
end

%% --- VÝSLEDKY ---
fprintf('\n%-15s | %-10s | %-10s | %-10s | %-10s | %-10s\n', ...
    'Palivo', 'RR', 'DET', 'DIV', 'Flatness', 'VarAmp');
fprintf('--------------------------------------------------------------------------\n');

for i = 1:length(res)
    fprintf('%-15s | %-10.4f | %-10.4f | %-10.4f | %-10.4f | %-10.4f\n', ...
        labels{i}, res(i).RR, res(i).DET, res(i).DIV, ...
        res(i).flatness, res(i).var_amp);
end

%% --- INTERPRETÁCIA ---
fprintf('\nINTERPRETÁCIA:\n');
fprintf('RR        ↑ = stabilnejší chod motora\n');
fprintf('DET       ↑ = viac plynulých zmien (menej náhodnosti)\n');
fprintf('DIV       ↓ = vyššia predvídateľnosť\n');
fprintf('Flatness  ↓ = menej šumu, viac "čistý tón"\n');
fprintf('VarAmp    ↓ = rovnomernejší zvuk\n');
