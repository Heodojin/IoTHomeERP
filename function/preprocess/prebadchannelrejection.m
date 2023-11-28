function [badch] = prebadchannelrejection(sig, param)
Fs = param.Fs;
Nch = size(sig,1);

thr1 = param.prep.rejthr(1);
thr2 = param.prep.rejthr(2);

X = double(sig);
X = filtfilt(param.prep.pBF{1}, param.prep.pBF{2}, X')';

CC = zeros(Nch);
for ich = 1:Nch-1
    for jch = ich+1 : Nch
        % get correlation between each channel.
        CC(ich,jch) = abs(corr(X(ich,:)', X(jch,:)'));
    end
    fprintf('*'); % marking process.
end
fprintf('\n');
CC = CC + triu(CC,1)';
% get 
idx = CC < thr1;
badch = [];
for ich = 1:Nch-1
    if (sum(idx(ich, :))-1) ./ (Nch-1) > thr2
        badch = [badch; ich];
    end
end

badch = unique(badch);