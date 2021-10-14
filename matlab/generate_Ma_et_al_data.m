% Generate data as described in "Exploiting Deep Neural Networks and Head
% Movements for Robust Binaural Localization of Multiple Sources in
% Reverberant Environments", Ma, Ning; May, Tobias; Brown, Guy J., IEEE
% TASLP, 2017, DOI: 10.1109/TASLP.2017.2750760
% Generates Anechoic audio samples from KEMAR HRTF with 1 second speech 
% segments from TIMIT with diffuse noise in 0, 10 and 20 dB SNR.

clearvars; clc;
SOFAstart;
KEMAR_HRTF = SOFAload('directory\of\44k\256tap\KEMAR.sofa\');
TIMIT = dir('directory\of\TIMIT\data\TRAIN\**\*.wav');
saveDataDir = 'directory\to\save\wav\files';

% APV: Azimuth | Elevation | Distance
% Azimuth is measured anti-clockwise (to the left). 0° marks directly in front of the subject.
APV = SOFAcalculateAPV(KEMAR_HRTF);
fs = 44100;

TIMIT = TIMIT(1:2:end); % Skip duplicate files contained in root folder

for azi = -180:5:175 % Iterate over the 72 different azimuth angles
    APV_Index = find(all(APV == [azi 0 1.2],2));
    IR = [squeeze(KEMAR_HRTF.Data.IR(APV_Index, 1, :))'
          squeeze(KEMAR_HRTF.Data.IR(APV_Index, 2, :))']';
    parfor ii = 1:30 % Randomly select 30 TIMIT sentences
        randIndex = randi([1 numel(TIMIT)]);
        [inputSignal,fsTimit] = audioread(fullfile(TIMIT(randIndex).folder,TIMIT(randIndex).name));
        % Select middle of speech signal to avoid silence in the beggining
        midSample = floor(numel(inputSignal)/2);
        inputSignal = inputSignal(midSample-fsTimit/2:midSample+fsTimit/2-1);
        inputSignal = resample(inputSignal,fs,fsTimit); % Resample TIMIT segment to 44.1k
        
        spatializedSignal = [conv(IR(:,1),inputSignal) conv(IR(:,2),inputSignal)];
        diffNoise = createDiffNoise(length(spatializedSignal),KEMAR_HRTF,APV);
        
        for desiredSNR = 0:10:20 % Add 3 levels of SNR diffuse noise to the anechoic input signal
            noise = addNoiseWithSNR(desiredSNR,spatializedSignal,diffNoise);
            MCTResult = spatializedSignal + noise;
            MCTResult = resample(MCTResult,fsTimit,fs);
            fName = sprintf('%sD_%d_S_%d_SNR_%d_Fs_%d.wav',saveDataDir,azi,ii,desiredSNR,fsTimit);
            audiowrite(fName,MCTResult,fsTimit);
        end
    end
end



