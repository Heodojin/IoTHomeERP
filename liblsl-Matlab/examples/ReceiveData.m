%% instantiate the library
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_all(lib); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{2});

disp('Now receiving data...');
while true
    % get data from the inlet
    [vec,ts] = inlet.pull_sample();
    % and display it
    disp(vec(:,33));
end