function diffuseNoise = createDiffNoise(N,HRTF,APV)
%Create diffuseNoise with N samples from the given HRTF database
% Inputs
% N:            Length of the resulting diffuse noise
% HRTF:         HRTF database to generate the diffuse noise
% APV:          APV Vector according to SOFA conventions
% Outputs
% diffuseNoise: Resulting diffuse noise
inNoise = wgn(N-256+1,1,1);
diffuseNoise = zeros(N,2);
for azi = -180:5:175 % Iterate over the 72 different azimuth angles
    APV_Index = find(all(APV == [azi 0 1.2],2));
    IR = [squeeze(HRTF.Data.IR(APV_Index, 1, :))'
          squeeze(HRTF.Data.IR(APV_Index, 2, :))']';
    diffuseNoise = diffuseNoise + [conv(IR(:,1),inNoise) conv(IR(:,2),inNoise)];
end
diffuseNoise = diffuseNoise ./ max(abs(diffuseNoise));
end
