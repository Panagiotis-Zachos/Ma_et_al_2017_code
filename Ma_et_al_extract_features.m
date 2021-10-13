% Extract CCF-ILD from data
clearvars; clc;

% wavFilesStruct requires as input the root directory of the wav files to
% be proccesed
wavFilesStruct = dir('root\of\wav\files\*.wav');
% featureVector and labels output location
dstFolder = 'processing\output\loc\directory\';
startTwoEars;
% 4-D vector files# x t_frames x f_bands x features
featureVectors = zeros(length(wavFilesStruct),99,32,34);
% 1-D vector parallel with featureVectors containing labels (azimuths)
labels = zeros(length(wavFilesStruct),1);


for ii = 1:length(wavFilesStruct)
    fName = fullfile(wavFilesStruct(ii).folder,wavFilesStruct(ii).name);
    strParts = split(wavFilesStruct(ii).name,'_');
    % Assumes that file is in the form: D_0_S_1_SNR_0_Fs_16000.wav
    tmp = strParts{2};
    [y,fs] = audioread(fName);
    y = y(1:fs,:);
    featureVectors(ii,:,:,:) = calc_CCF_ILD(y);
    labels(ii) = str2double(tmp);
end

save(fullfile(dstFolder,'featureVectors.mat'),'featureVectors','-v7.3');
save(fullfile(dstFolder,'labels.mat'),'labels','-v7.3');

