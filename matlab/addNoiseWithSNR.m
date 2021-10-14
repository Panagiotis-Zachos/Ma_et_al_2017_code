function noise = addNoiseWithSNR(Desired_SNR_dB,input,noise)
    % Generate noise with given SNR to be added to the given input signal
    % Inputs
    % Desired_SNR_dB: Desired SNR in dB for the noise to be generated
    % input:          Input signal for the SNR calculation
    % noise:          Input noise signal (e.g. AWGN)
    % Outputs
    % noise:          Noise with specified SNR with respect to input
    Signal_Power = sum(abs(input(:)).*abs(input(:)))/numel(input);
    Noise_Power = sum(abs(noise(:)).*abs(noise(:)))/numel(noise);

    K = (Signal_Power/Noise_Power)*10^(-Desired_SNR_dB/10);  % Scale factor
    noise = sqrt(K)*noise;
end
