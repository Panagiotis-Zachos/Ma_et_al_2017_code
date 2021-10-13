function [vectors] = calc_CCF_ILD(b_sig)
% Calculate CCF and ILD vectors according to Ma et al. (2017)
% For this function to work startTwoEars must have been called first
%   Inputs:
%       b_sig:      A 2-channel binaural signal to be analysed
%       max_delay:  Maximum delay of the CCF to be retained (default 1ms)
%       fs:         sampling frequency of the binaural signal
%   Outputs:
%       vectors:    A 3D vector containing time_frames x frequency bands x
%                   (CCF values + final row of ILD values for each time frame)


fs = 16000;
max_delay = 0.001;
numFBands = 32;

dataObj = dataObject(b_sig,fs);

parameters = genParStruct('cc_wname','hann',...
                          'cc_maxDelaySec',max_delay,...
                          'ihc_method','halfwave',...
                          'fb_nChannels',numFBands);

% managerObj = manager(dataObj);
% managerObj.addProcessor({'ild','crosscorrelation'},parameters);

requests = {'ild','crosscorrelation'};
managerObj = manager(dataObj,requests,parameters);

managerObj.processSignal;
% The CCF is normalised by the auto-correlation sequence at lag zero
CCF = dataObj.crosscorrelation{1}.Data(:);
ILD = dataObj.ild{1}.Data(:);

vectors = cat(3,CCF,ILD);
end

