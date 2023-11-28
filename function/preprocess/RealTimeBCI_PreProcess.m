function [sig,BCI] = RealTimeBCI_PreProcess(sig, BCI)
global cal_sig
param = BCI.param;
%% STEP 1. 0.5~ 50Hz filtering : avoid line noise & high frequency noise
sig = filtfilt(param.prep.BF{1}, param.prep.BF{2}, double(sig)')';
%% STEP 2. Bad channel Rejection
if ~strcmp(BCI.decoderState,'testing')
    badch = prebadchannelrejection(sig,param);
    param.badch = badch;
    for i = 1:length(param.badch)
        param.Ch{param.badch(i)} =[];
    end
    param.Ch = param.Ch(~cellfun('isempty',param.Ch));
end    
%% STEP 2-1. Interpolation
if param.prep.interp
    sig = eeginterp(sig,param.badch,'spherical');
    param.NumCh = size(sig,1);
else
    sig(param.badch,:) = [];
end
% param.NumCh = size(sig,1);
%% STEP 3. Common Average Rejection
sig = sig - repmat(mean(sig,1),size(sig,1),1);   
%% STEP 4. Artifact Subspace rejection (ASR)
if strcmp(BCI.decoderState, 'training')
    if isempty(BCI.param.asr.state)
        param = preASR(cal_sig,param);
    end
end
    
% do asr
try
    if param.asr.do
        sigout = ASR(sig, param);
    else
        sigout = sig;
    end
catch ME
    sigout = sig;
end  
sig = sigout;
%% STEP 6. Low-pass filtering (12Hz)
sig = filtfilt(param.prep.LF{1}, param.prep.LF{2}, sig')';
%% OUTPUT
if strcmp(BCI.decoderState, 'training')
    BCI.param = param;
end
