function [psuedo] = psuedoRandomGenerater(N,stimType)
    try
    Nstim = max(size(stimType));
    Rep = ceil(N/Nstim);
    
    psuedo_tmp = zeros(Nstim,Rep);
    for r = 1:Rep
        psuedo_tmp(:,r) = randperm(Nstim);
    end
    
    psuedo_tmp = psuedo_tmp(:);
    psuedo_tmp = psuedo_tmp(1:N,:);
    
    psuedo = stimType(psuedo_tmp)';
    catch ME
        keyboard();
    end
end