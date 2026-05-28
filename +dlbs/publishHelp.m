function publishHelp()

htmlOutputDir = dlbs.paths.htmlOut();

if isfolder(htmlOutputDir)
    folderContents = dir(htmlOutputDir);
    folderContents = folderContents(~ismember({folderContents.name}, {'.', '..'}));

    for item = folderContents'
        itemPath = fullfile(item.folder, item.name);
        try
            if item.isdir
                rmdir(itemPath, 's');
            else
                delete(itemPath);
            end
        catch
            % Continue trying to clean up remaining items.
        end
    end
else
    mkdir(htmlOutputDir)
end

libraryHelpFiles = dir("toolbox/library/**/dlbsHelp*.m");
docsHelpFiles = dir("docs/**/dlbsHelp*.m");
allHelpFiles = [libraryHelpFiles; docsHelpFiles];

for helpFile = allHelpFiles'

    fprintf("Builing doc for %s\n",helpFile.name);

    try
        try
            page = feval(helpFile.name(1:end-2));
        catch
            warning("Could not feval %s\n", helpFile.name)
            continue
        end

        page.render();


        if isfolder(page.tempdir_path)
            for filetype = ["html", "png" , "svg"]
                try
                    copyfile(fullfile(page.tempdir_path, "*."+filetype), htmlOutputDir);
                catch me
                    if ~strcmp(me.identifier,"MATLAB:COPYFILE:FileNotFound")
                        rethrow(me)
                    end
                end
            end
        end
    
    catch
        % If rendering fails, fall back to publish
        publish(fullfile(helpFile.folder, helpFile.name), ...
            "format", "html", ...
            "outputDir", htmlOutputDir, ...
            "showCode", false, ...
            "evalCode", false);
    end
end

copyfile(fullfile(dlbs.rootPath,"docs","dlbsIcon.svg"),htmlOutputDir)
copyfile(fullfile(dlbs.rootPath,"docs","helptoc.xml"),htmlOutputDir)
builddocsearchdb(htmlOutputDir)

end