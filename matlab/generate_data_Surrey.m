clearvars; clc; SOFAstart;

databases = { 
    'IoSR-Surrey-Rooms\UniS_Room_A_BRIR_48k.sofa', ...
    'IoSR-Surrey-Rooms\UniS_Room_B_BRIR_48k.sofa', ...
    'IoSR-Surrey-Rooms\UniS_Room_C_BRIR_48k.sofa', ...
    'IoSR-Surrey-Rooms\UniS_Room_D_BRIR_48k.sofa'
    };

saveDataDir = 'SurreyABCD\';
ROOM_NAMES = {'SRA', 'SRB', 'SRC', 'SRD'}; ROOM_NUM = length(ROOM_NAMES); 
RESOLUTION = 5;
fs = 44100;
desiredSNR = 0;

KEMAR_HRTF = SOFAload('SADIE2_V1-3\D2\D2_HRIR_SOFA\D2_44K_16bit_256tap_FIR_SOFA.sofa');
KEM_APV = SOFAcalculateAPV(KEMAR_HRTF);
TIMIT = dir('ΤΙΜΙΤ\data\TRAIN\**\*.wav');
TIMIT = TIMIT(1:2:end); SIG_NUM = 20;

for room = 1:ROOM_NUM
    db_base_path = char(databases(room));
    brirDB = SOFAload(db_base_path);
    APV = SOFAcalculateAPV(brirDB);
    APV(:,1) = round(APV(:,1));
    disp('DB Loaded');
    brir_samp = brirDB.Data.SamplingRate;

    parfor sig = 1:SIG_NUM
        randIndex = randi([1 numel(TIMIT)]);
        [in_sig,fsTimit] = audioread(fullfile(TIMIT(randIndex).folder,TIMIT(randIndex).name));
        midSample = floor(numel(in_sig)/2);
        in_sig = in_sig(midSample-fsTimit/2:midSample+fsTimit/2-1);
        in_sig = resample(in_sig,brir_samp,fsTimit); % Resample TIMIT segment to 44.1k
        for azi = -90:5:90 % Iterate over the 72 different azimuth angles
            APV_Index = find(all(APV == [azi 0 1.5],2));
            brir = [squeeze(brirDB.Data.IR(APV_Index, 1, :))'
                  squeeze(brirDB.Data.IR(APV_Index, 2, :))']';

            binaural_signal = binaural_signal_generation(in_sig, brir);
            rresult = binaural_signal;
            [p, q] = rat(16000/brir_samp);
            rresult = resample(rresult, p, q);
            fName = sprintf('%sRoom_%s_Sig_%d_SNR_%d_Deg_%d.wav', saveDataDir, char(ROOM_NAMES(room)), sig, desiredSNR, azi);
            rresult = rresult ./ max(abs(rresult(:)));
            audiowrite(fName, rresult, 16000);
        end
    end
end
