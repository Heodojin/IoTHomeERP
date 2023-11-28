function [feat lb] = dataPreprocess(data, label, param)
win = (param.epoch.baseTime*param.Fs)+...
    ((param.cls.win(1)*param.Fs+1):1:(param.cls.win(2)*param.Fs));
if label
    % for training.
    target = (label == [1:4]);
else
    % for testing.
    target = ones(1,param.NumCondi);
end

% get data only range
X = data(:, win, :,:,:);
% target
feat1 = permute(X(:,:,target == 1), [2,1,3]);
feat1 = reshape(feat1, [], size(feat1,3));
% non-target
feat2 = permute(X(:,:,target ~= 1), [2,1,3]);
feat2 = reshape(feat2, [], size(feat2,3));

feat = cat(2, feat1, feat2)';
lb = [ones(size(feat1,2),1); -ones(size(feat2,2),1)];    
end