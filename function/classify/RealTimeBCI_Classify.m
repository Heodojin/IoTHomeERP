function [C, mdl] = RealTimeBCI_Classify(sig, target, BCI)
param = BCI.param;
stim = [1:4];
% if test, lb = 0
[feat lb] = dataPreprocess(sig, target, param);

if strcmp(BCI.decoderState, 'training') || isempty(BCI.decoder)
    [ mdl ] = mkclsfier(feat, lb, 'svm');
    C = nan;
elseif strcmp(BCI.decoderState, 'testing')
    [~, sc]  = predict(BCI.decoder, feat);
    [~, I]   = max(sc(:,end));
    C = stim(I);
end
end
