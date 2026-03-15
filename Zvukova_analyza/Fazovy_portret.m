clear; clc; close all;

%% 1. NACITANIE DÁT
% Skontroluj, či sú tieto názvy presne v Current Folder
[audio1, fs1] = audioread('TAM_Paliva_3x3.mp4'); 
[audio2, fs2] = audioread('LPG.mp4'); 
[audio3, fs3] = audioread('misfire.mp3'); 

if size(audio1,2) > 1, audio1 = mean(audio1,2); end
if size(audio2,2) > 1, audio2 = mean(audio2,2); end
if size(audio3,2) > 1, audio3 = mean(audio3,2); end

% Zjednotenie vzorkovacej frekvencie pre porovnanie
if fs2 ~= fs1, audio2 = resample(audio2, fs1, fs2); end
if fs3 ~= fs1, audio3 = resample(audio3, fs1, fs3); end

segments101 = [0, 3.2; 3.3, 5.9; 6.0, 9.2];
segments95  = [9.3, 12.5; 12.6, 16.6; 16.7, 20.1];
segmentsLPG = [0, 5.0; 5.1, 11.4];

extract = @(au, fs, segs) cell2mat(arrayfun(@(i) au(round(segs(i,1)*fs)+1 : round(segs(i,2)*fs)), 1:size(segs,1), 'UniformOutput', false)');

sig101 = extract(audio1, fs1, segments101);
sig95  = extract(audio1, fs1, segments95);
sigLPG = extract(audio2, fs1, segmentsLPG);
sigMIS = audio3(1:min(length(audio3), length(sig101)));

sigs = {sig101, sig95, sigLPG, sigMIS};
titles = {'101 Oct', '95 Oct', 'LPG', 'MISFIRE'};
cols = {'r', 'b', 'g', 'k'}; 

%% 2. FÁZOVÝ PORTRÉT (2x2 rozloženie)

figure('Name','Fázový portrét (2x2)','Color','w','Position',[50 100 1000 700]);

for k = 1:4
    subplot(2,2,k); % 2 riadky, 2 stĺpce
    s = sigs{k};
    plot(s(1:end-1), s(2:end), '.', 'Color', cols{k}, 'MarkerSize', 0.2);
    title(['Fáza: ' titles{k}]); grid on; axis tight;
    xlim([-0.1 0.1]); ylim([-0.1 0.1]);
    xlabel('Amplitúda t'); ylabel('Amplitúda t+1');
end
