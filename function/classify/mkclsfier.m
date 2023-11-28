function [ mdl ] = mkclsfier(feat, lb, mode)
mdl = selmdl(feat,lb,mode);

% cross-validation : 5-fold
CVidx = crossvalind('Kfold',lb,5);
for r = 1:5
    idx = CVidx ~= r;
    cvmdl = selmdl(feat(idx,:),lb(idx), mode);
    teidx = CVidx == r;
    [result, score] = predict(cvmdl, feat(teidx,:));
    acc(r) = length(find(result == lb(teidx)))/length(result);
end
CVAcc = mean(acc);
end

function [mdl] = selmdl(feat, lb, mode)
switch mode
    case 'svm'
        mdl = fitcsvm(feat, lb);
    case 'rf'
        TreesNum = 10;
        mdl = TreeBagger(TreesNum, feat, lb,...
            'Method','classification',...
            'OOBPrediction','on',...
            'OOBPredictorImportance','on');
end
end
