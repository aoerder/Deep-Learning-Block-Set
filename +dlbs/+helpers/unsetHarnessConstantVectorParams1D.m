function unsetHarnessConstantVectorParams1D(dry_run)
% unsetHarnessConstantVectorParams1D
% Scan harness models for top-level Constant blocks and unset VectorParams1D.
% dry_run = true: list only Constant blocks that would be changed.
% dry_run = false: set VectorParams1D to off and save changed models.

if nargin < 1 || isempty(dry_run)
    dry_run = false;
end

dry_run = logical(dry_run);

harnessFiles = dir(fullfile(dlbs.rootPath(), "toolbox", "**", "dlbsTestHarness*.slx"));

fprintf('Found %d harness model(s).\n\n', numel(harnessFiles));
totalUpdated = 0;

for k = 1:numel(harnessFiles)
    modelPath = fullfile(harnessFiles(k).folder, harnessFiles(k).name);
    [~, modelName] = fileparts(modelPath);

    try
        load_system(modelPath);

        % Only top-level Constant blocks (SearchDepth = 1).
        constBlocks = find_system(modelName, 'SearchDepth', 1, 'BlockType', 'Constant');
        modelUpdated = 0;

        for i = 1:numel(constBlocks)
            blk = constBlocks{i};
            oldVal = get_param(blk, 'VectorParams1D');

            if ~shouldUnsetVectorParams1D(oldVal)
                continue;
            end

            if modelUpdated == 0
                fprintf('Model: %s\n', harnessFiles(k).name);
            end

            if dry_run
                fprintf('  WOULD UNSET: %s (VectorParams1D = %s)\n', blk, oldVal);
            else
                set_param(blk, 'VectorParams1D', 'off');
                fprintf('  UNSET: %s (VectorParams1D: %s -> off)\n', blk, oldVal);
            end

            modelUpdated = modelUpdated + 1;
            totalUpdated = totalUpdated + 1;
        end

        if modelUpdated > 0
            if ~dry_run
                save_system(modelName);
                fprintf('  Saved model with %d Constant block(s) unset.\n', modelUpdated);
            end
            fprintf('\n');
        end

        close_system(modelName, 0);

    catch ME
        fprintf('Model: %s\n', harnessFiles(k).name);
        fprintf('  ERROR: %s\n\n', ME.message);
        if bdIsLoaded(modelName)
            close_system(modelName, 0);
        end
    end
end

if dry_run
    fprintf('Summary: %d top-level Constant block(s) would be unset.\n', totalUpdated);
else
    fprintf('Summary: Unset VectorParams1D on %d top-level Constant block(s).\n', totalUpdated);
end

end

function tf = shouldUnsetVectorParams1D(value)
% Return true if VectorParams1D is not already off.
if isstring(value) || ischar(value)
    tf = ~any(strcmpi(strtrim(string(value)), ["off", "false", "0"]));
elseif isnumeric(value) || islogical(value)
    tf = logical(value);
else
    tf = true;
end
end
