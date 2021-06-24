function hdr = read_kyoto_header(K, trialDuration, baselineDuration)
% READ_KYOTO_HEADER Process Kyoto ECoG data to produce hdr structure
% hdr = read_kyoto_header(K, trialDuration, baselineDuration)
%
% Inputs:
%    K: The main data structure from the Kyoto .mat file (e.g.,
%    namingERP_data_PtYK_Pt01 for participant 1).
%    trialDuration: The legnth of a single trial (ms) post stimulus onset.
%    baselineDuration: The length of the baseline period before stimulus
%    onset
%
% Note that trialDuration and baselineDuration can be whatever you want
% them to be.
%
% Output:
%    hdr.Fs                  sampling frequency
%    hdr.nChans              number of channels
%    hdr.nSamples            number of samples per trial
%    hdr.nSamplesPre         number of pre-trigger samples in each trial
%    hdr.nTrials             number of trials
%    hdr.label               Nx1 cell-array with the label of each channel
%    hdr.chantype            Nx1 cell-array with the channel type, see FT_CHANTYPE
%    hdr.chanunit            Nx1 cell-array with the physical units, see FT_CHANUNIT
    hdr.Fs = 1/K.DIM(1).interval;
    hdr.nChans = size(K.DIM(2).label, 1);
    hdr.nSamples = trialDuration * (hdr.Fs / 1000);
    hdr.nSamplesPre = baselineDuration * (hdr.Fs / 1000);
    hdr.nTrials = 400;
    hdr.label = cellstr(K.DIM(2).label);
    hdr.chantype = {};
    hdr.chanunit = cellstr(repmat('uV',hdr.nChans,1));
end
    
    