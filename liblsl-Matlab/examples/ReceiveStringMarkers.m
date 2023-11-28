% instantiate the library
addpath(genpath('./../../liblsl-Matlab/'))
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving a Markers stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'source_id',140717528921952); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});

disp('Now receiving data...');
while true
    % get data from the inlet
    [mrks,ts] = inlet.pull_sample();
    % and display it
    fprintf('got %s at time %.5f\n',string(mrks),ts);
end
