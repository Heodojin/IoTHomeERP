function [ param ] = preASR(cal_sig, param)
cal_sig = double(cal_sig);

if ~param.prep.interp
    cal_sig(param.badch,:) = [];
end

cal_sig = filtfilt(param.prep.HF{1}, param.prep.HF{2}, double(cal_sig)')'; %180213 updated: default filtering 0.5 ~ Hz
cal_sig = filtfilt(param.prep.dLF{1}, param.prep.dLF{2}, double(cal_sig)')'; %180213 updated: default filtering ~ 50Hz

ref = cleanwindows(cal_sig,param.Fs);
param.asr.state = asr_calibrate(ref,param.Fs,param.asr.cutoff);
