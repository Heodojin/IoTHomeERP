function [ param ] = RealTimeBCI__INIT__()
param.Ch = {'FP1' 'FPZ' 'FP2' 'F7' 'F3' 'FZ' 'F4' 'F8' ...
    'FT9' 'FC5' 'FC1' 'FC2' 'FC6' 'FT10' 'T7' 'C3' ...
    'CZ' 'C4' 'T8' 'CP5' 'CP1' 'CP2' 'CP6' ...
    'P7' 'P3' 'PZ' 'P4' 'P8' 'O1' 'OZ' 'O2'};

param.NumCh = length(param.Ch);
param.Fs = 500;
param.badch = [];
param.NumTrainBlock = 40;
param.Numiter = 10;
param.NumCondi = 4;
param.ISI = {'66' '66'};
param.target = [];
%% for preprocessing
% for filtering
[B,A] = butter(4, [0.5 50] ./ (param.Fs/2),'bandpass');
param.prep.BF = {B, A};
[B, A] = butter(2, [0.5 1] ./ (param.Fs/2),'bandpass');
param.prep.pBF = {B, A};
[B, A] = butter(4, 12 ./ (param.Fs/2),'low');
param.prep.LF = {B, A};
[B, A] = butter(4, [0.5]./(param.Fs/2),'high');
param.prep.HF = {B, A};
[B, A] = butter(4, [50]./(param.Fs/2),'low');
param.prep.dLF = {B, A};

param.prep.rejthr = [.4 .7];
param.prep.interp = false;

param.asr.do = true;
param.asr.cutoff = 10;
param.asr.windowlen = 0.5;
param.asr.stepsize = floor(param.Fs*param.asr.windowlen/2);
param.asr.maxdims = 0.66;
param.asr.state = [];
%% for epoching
param.epoch.avg = true;
param.epoch.baseTime = 0.20;
param.epoch.epocTime = 0.60;
%% for classify
param.cls.type = 'svm';
param.cls.win = [0.15 0.60];

    

            