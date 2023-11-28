function [sig, trig] = LoadData(FILE,PATH,BCI)
% load signal and trigger
sig = []; trig = [];
% 여기에 몇개의 데이터가 선택되었는지 stateflow에 명시해줄 필요있어용
for f = 1:BCI.param.NumTrainBlock
    load(fullfile(PATH{f}, FILE{f}))
    sig = cat(2, sig, sig_vec);
    trig = cat(2, trig, trigger);
end
end