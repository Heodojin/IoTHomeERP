function [ epoch_signal ] = RealTimeBCI_Epoching(sig, trig, BCI)
param = BCI.param;
%% 1. set parameter
% Experiment Condtion
Nch = size(sig,1);
Ncondi = param.NumCondi;
if strcmp(BCI.decoderState, 'training')
    Nblock = param.NumTrainBlock;
else % testing
    Nblock = 1;
end
Niter = param.Numiter; % single trial
condi_name = [1:4];

% epoch information
% onset time 기준
epoch_baseline_time = param.epoch.baseTime; % sec %if you don't want to base line, just set 0.
epoch_time = param.epoch.epocTime; % sec

Fs = param.Fs;
epoch_start_time = -epoch_baseline_time*Fs + 1;
epoch_end_point = epoch_time*Fs;
epoch_win = epoch_start_time :1: epoch_end_point;

Npoint = size(epoch_win,2);
%% 2. Epoching Signal by conditions.
% 1~4 : stimulus condition
% 12: block start
% 13: block end
% get signal and trigger
signal = sig;
trigger = trig;

latency = find(trigger ~= 0);
type = trigger(trigger ~= 0);

% target = type(find(type == 12) - 1)';

block_start_point = find(type == 12) + 1;
block_fin_point = find(type == 13) - 1;

% check error for number of block
assert(length(block_start_point) == Nblock);

epoch_signal = nan(Nch, Npoint, Nblock, Ncondi, Niter);
for bi = 1: Nblock
    % get one block point
    one_block_idx = block_start_point(bi) : block_fin_point(bi);
    one_block_point = latency(one_block_idx);
    one_block_type = type(one_block_idx);
    
    for icondi = 1: Ncondi
        one_condi_idx = (one_block_type == condi_name(icondi));
        one_condi_point = one_block_point(one_condi_idx);
        
        assert(Niter == length(one_condi_point));        
        for iter = 1:Niter
            % get signal
            one_iter_idx = one_condi_point(iter) + epoch_win;
            one_iter_signal = signal(:,one_iter_idx);
            
            epoch_signal(:,:,bi,icondi,iter) = one_iter_signal;
        end
    end
end
%% 3. Average for iteration.
if param.epoch.avg
    epoch_signal = mean(epoch_signal,5);
end
%% 4. Baseline Correction
epoch_baseline_point = 1:1:epoch_baseline_time*Fs;

baseMean = repmat(mean(epoch_signal(:,epoch_baseline_point,:,:,:),2), 1, Npoint);
baseStd = repmat(std(epoch_signal(:,epoch_baseline_point,:,:,:),[],2), 1, Npoint);

epoch_signal = (epoch_signal - baseMean);


