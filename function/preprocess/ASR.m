function sig = ASR(sig, param)

% extrapolate last few samples of the signal
sig = [sig bsxfun(@minus,2*sig(:,end),sig(:,(end-1):-1:end-round(param.asr.windowlen/2*param.Fs)))];
% process signal using ASR
[sig,param.asr.state] = asr_process(sig,param.Fs,...
    param.asr.state, param.asr.windowlen, param.asr.windowlen/2, param.asr.stepsize, param.asr.maxdims,[],false);
% shift signal content back (to compensate for processing delay)
sig(:,1:size(param.asr.state.carry,2)) = [];

end