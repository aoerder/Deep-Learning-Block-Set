function syncHelpBlockMaskHelp(dry_run)
% syncHelpBlockMaskHelp
% Execute all dlbsHelpBlock*.m functions and synchronize Simulink mask text.
% dry_run = true: report intended changes only.
% dry_run = false: set mask Description/Help and save changed libraries.

if nargin < 1 || isempty(dry_run)
    dry_run = false;
end

dry_run = logical(dry_run);

helpFiles = dir(fullfile(dlbs.rootPath(), "toolbox", "**", "dlbsHelpBlock*.m"));

fprintf('Found %d help block file(s).\n\n', numel(helpFiles));

totalChanged = 0;
totalErrors = 0;
processedBlocks = string.empty;

for k = 1:numel(helpFiles)
    filePath = fullfile(helpFiles(k).folder, helpFiles(k).name);
    [~, fnName] = fileparts(filePath);

    libraryLoadedHere = false;
    libraryPath = "";
    restoreLockState = false;
    originalLibraryLock = "";

    try
        if isempty(which(fnName))
            addpath(helpFiles(k).folder);
        end

        page = feval(fnName);

        if ~isa(page, 'dlbsHelpPageTemplate')
            fprintf('Help page: %s\n', helpFiles(k).name);
            fprintf('  SKIP: function did not return dlbsHelpPageTemplate.\n\n');
            continue;
        end

        if strlength(page.block_library_path) == 0 || strlength(page.block_path) == 0
            fprintf('Help page: %s\n', helpFiles(k).name);
            fprintf('  SKIP: no block path configured via setBlockLibraryPath().\n\n');
            continue;
        end

        libraryPath = string(page.block_library_path);
        blockPath = string(page.block_path);
        fullBlockPath = libraryPath + "/" + blockPath;

        if strcmp(libraryPath, "dlbsBlockInsertGradientGF") || strcmp(libraryPath, "dlbsBlockExtractGradientGF")
            fprintf('Help page: %s\n', helpFiles(k).name);
            fprintf('  SKIP: internal utility block.\n\n');
            continue;
        end

        if any(processedBlocks == fullBlockPath)
            fprintf('Help page: %s\n', helpFiles(k).name);
            fprintf('  SKIP: duplicate block path %s\n\n', fullBlockPath);
            continue;
        end

        processedBlocks(end + 1) = fullBlockPath;

        newDescription = string(page.maskhelp);
        if strlength(newDescription) == 0
            fprintf('Help page: %s\n', helpFiles(k).name);
            fprintf('  SKIP: maskhelp is empty.\n\n');
            continue;
        end

        newHelp = "web(""" + string(page.document_basename) + ".html"")";

        wasLibraryLoaded = bdIsLoaded(libraryPath);
        if ~wasLibraryLoaded
            load_system(libraryPath);
            libraryLoadedHere = true;
        end

        if ~dry_run
            originalLibraryLock = string(get_param(libraryPath, "Lock"));
            restoreLockState = true;
            if ~strcmpi(originalLibraryLock, "off")
                set_param(libraryPath, "Lock", "off");
            end
        end

        mask = Simulink.Mask.get(fullBlockPath);
        if isempty(mask)
            error('No Simulink mask found for block path: %s', fullBlockPath);
        end

        oldDescription = string(mask.Description);
        oldHelp = string(mask.Help);

        needsChange = oldDescription ~= newDescription || oldHelp ~= newHelp;

        fprintf('Help page: %s\n', helpFiles(k).name);
        if ~needsChange
            fprintf('  NO CHANGE: %s\n\n', fullBlockPath);
        elseif dry_run
            fprintf('  WOULD SET Description on %s\n', fullBlockPath);
            fprintf('  WOULD SET Help to %s\n\n', newHelp);
            totalChanged = totalChanged + 1;
        else
            mask.set("Description", newDescription);
            mask.set("Help", newHelp);
            save_system(libraryPath);

            fprintf('  UPDATED: %s\n', fullBlockPath);
            fprintf('  Help: %s\n\n', newHelp);
            totalChanged = totalChanged + 1;
        end

        if restoreLockState
            set_param(libraryPath, "Lock", char(originalLibraryLock));
            restoreLockState = false;
        end

        if libraryLoadedHere && bdIsLoaded(libraryPath)
            close_system(libraryPath, 0);
        end

    catch ME
        totalErrors = totalErrors + 1;
        fprintf('Help page: %s\n', helpFiles(k).name);
        fprintf('  ERROR: %s\n\n', ME.message);

        if restoreLockState && strlength(libraryPath) > 0 && bdIsLoaded(libraryPath)
            try
                set_param(libraryPath, "Lock", char(originalLibraryLock));
            catch
                % Best effort only; keep original exception as the reported error.
            end
        end

        if libraryLoadedHere && strlength(libraryPath) > 0 && bdIsLoaded(libraryPath)
            close_system(libraryPath, 0);
        end
    end
end

if dry_run
    fprintf('Summary: %d block mask(s) would be updated. Errors: %d.\n', totalChanged, totalErrors);
else
    fprintf('Summary: Updated %d block mask(s). Errors: %d.\n', totalChanged, totalErrors);
end

end
