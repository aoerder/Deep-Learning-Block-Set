classdef dlbsHelpPageTemplate < handle


    properties (SetAccess = private)
        tempdir_path
        document_basename
        lines
        title
        block_library_path
        block_path
        maskhelp
    end

    methods
    
        function obj = dlbsHelpPageTemplate(basename, title)
            obj.title = title;
            obj.lines = string.empty;
            obj.block_library_path = "";
            obj.block_path = "";
            obj.maskhelp = "";
            obj.tempdir_path = tempname;
            if nargin < 1 || isempty(basename)
                [~, basename, ~] = fileparts(tempname);
            end
            obj.document_basename = string(basename);
            if ~exist(obj.tempdir_path, 'dir')
                mkdir(obj.tempdir_path);
            end
        end

        function delete(obj)
            % Delete the temporary directory
            if ~isempty(obj.tempdir_path) && exist(obj.tempdir_path, 'dir')
                rmdir(obj.tempdir_path, 's');
            end
        end

        function addTitle(obj, title)
            obj.lines = [obj.lines; sprintf("%%%% %s", title); "%"];
        end

        function addParagraph(obj, paragraph)
            obj.lines = [obj.lines; sprintf("%% %s", paragraph); "%"];
        end

        function setBlockLibraryPath(obj, varargin)
            if nargin < 2
                error("dlbsHelpPageTemplate:setBlockLibraryPath:MissingPath", ...
                    "Provide either a combined path 'library/block' or two arguments: library and block.");
            end

            if numel(varargin) == 1
                combinedPath = string(varargin{1});
                tokens = split(combinedPath, "/");
                if numel(tokens) ~= 2 || any(strlength(strtrim(tokens)) == 0)
                    error("dlbsHelpPageTemplate:setBlockLibraryPath:InvalidCombinedPath", ...
                        "Combined path must be in the form 'library/block'. Got: %s", combinedPath);
                end
                obj.block_library_path = strtrim(tokens(1));
                obj.block_path = strtrim(tokens(2));
            elseif numel(varargin) == 2
                libraryPath = string(varargin{1});
                blockPath = string(varargin{2});
                if strlength(strtrim(libraryPath)) == 0 || strlength(strtrim(blockPath)) == 0
                    error("dlbsHelpPageTemplate:setBlockLibraryPath:InvalidPath", ...
                        "Library path and block path must be non-empty.");
                end
                obj.block_library_path = strtrim(libraryPath);
                obj.block_path = strtrim(blockPath);
            else
                error("dlbsHelpPageTemplate:setBlockLibraryPath:TooManyInputs", ...
                    "setBlockLibraryPath accepts one or two input arguments.");
            end
        end

        function addParagraphAndMaskHelp(obj, paragraph)
            obj.addParagraph(paragraph);
            obj.addMaskHelp(paragraph);
        end


        function addMaskHelp(obj, varargin)
            for k = 1:numel(varargin)
                segment = string(varargin{k});
                if strlength(strtrim(segment)) == 0
                    continue;
                end

                if strlength(obj.maskhelp) == 0
                    obj.maskhelp = segment;
                else
                    obj.maskhelp = obj.maskhelp + newline + segment;
                end
            end
        end

        function addMonospaced(obj, varargin)
            for segment = [varargin{:}]
                obj.lines = [obj.lines; sprintf("%%  %s", segment)];
            end
            obj.lines = [obj.lines; "%"];
        end

        function addLatex(obj, varargin)
            obj.lines = [obj.lines; "% <latex>"];
            for latex_segment = [varargin{:}]
                obj.lines = [obj.lines; sprintf("%% %s", latex_segment)];
            end
            obj.lines = [obj.lines; "% </latex>"; "%"];
        end

        function addTable(obj, tbl)
            obj.lines = [obj.lines; "% <html>"];
            obj.lines = [obj.lines; "% <table>"];
            obj.lines = [obj.lines; "% <tr>"];
            for col = 1:width(tbl)
                obj.lines = [obj.lines; sprintf("%% <th><b>%s</b></th>", tbl.Properties.VariableNames{col})];
            end
            obj.lines = [obj.lines; "% </tr>"];
            for row = 1:height(tbl)
                obj.lines = [obj.lines; "% <tr>"];
                for col = 1:width(tbl)
                    value = tbl{row, col};
                    if isnumeric(value)
                        value = num2str(value);
                    end
                    obj.lines = [obj.lines; sprintf("%% <td>%s</td>", value)];
                end
                obj.lines = [obj.lines; "% </tr>"];
            end
            obj.lines = [obj.lines; "% </table>"];
            obj.lines = [obj.lines; "% </html>"; "%"];
        end

        function addBlockImage(obj, image_name)
            assert(~isempty(obj.tempdir_path) && exist(obj.tempdir_path, 'dir'), ...
                "dlbsHelpBlockdlbsHelpPageTemplate:addBlockImage:MissingTempDir", ...
                "Temporary directory does not exist.");

            if strlength(obj.block_library_path) == 0 || strlength(obj.block_path) == 0
                error("dlbsHelpPageTemplate:addBlockImage:MissingBlockPath", ...
                    "Call setBlockLibraryPath() before addBlockImage().");
            end

            if nargin < 2 || isempty(image_name)
                image_name = "block";
            end

            library_name = obj.block_library_path;
            library_block = obj.block_path;

            if isempty(library_name) || isempty(library_block) || isempty(image_name)
                error("dlbsHelpBlockdlbsHelpPageTemplate:addBlockImage:MissingBlockInfo", ...
                    "setBlockLibraryPath() and image_name must be provided to addBlockImage().");
            end

            image_name = string(image_name);
            if endsWith(image_name, ".svg", "IgnoreCase", true)
                image_name = extractBefore(image_name, strlength(image_name) - 3);
            end
            image_file_name = obj.document_basename + "_" + image_name + ".svg";
            blockImagePath = fullfile(obj.tempdir_path, image_file_name);

            wasLibraryLoaded = bdIsLoaded(library_name);
            if ~wasLibraryLoaded
                load_system(library_name)
            end

            % Export from a temporary model copy with broken library links to avoid badges.
            tmpModel = string(library_name) + "_doc_tmp";
            if bdIsLoaded(tmpModel)
                close_system(tmpModel,0)
            end
            new_system(tmpModel)

            try
                add_block(string(library_name) + "/" + string(library_block), ...
                    tmpModel + "/" + string(library_block), "CopyOption", "nolink");
                print(blockImagePath, "-dsvg", "-s" + tmpModel);
            catch ME
                if bdIsLoaded(tmpModel)
                    close_system(tmpModel,0)
                end
                if ~wasLibraryLoaded && bdIsLoaded(library_name)
                    close_system(library_name,0)
                end
                rethrow(ME)
            end

            close_system(tmpModel,0)
            if ~wasLibraryLoaded && bdIsLoaded(library_name)
                close_system(library_name,0)
            end

            obj.lines = [obj.lines; sprintf("%% <html><img src=""%s""/></html>", image_file_name); "%"];

        end

        function addSubsystemImage(obj, model_name, subsystem_name, image_name)
            assert(~isempty(obj.tempdir_path) && exist(obj.tempdir_path, 'dir'), ...
                "dlbsHelpPageTemplate:addSubsystemImage:MissingTempDir", ...
                "Temporary directory does not exist.");

            if nargin < 3 || isempty(model_name) || isempty(subsystem_name)
                error("dlbsHelpPageTemplate:addSubsystemImage:MissingInputs", ...
                    "Provide model_name and subsystem_name.");
            end

            if nargin < 4 || isempty(image_name)
                image_name = "subsystem";
            end

            model_name = string(strtrim(model_name));
            subsystem_name = string(strtrim(subsystem_name));
            if strlength(model_name) == 0 || strlength(subsystem_name) == 0
                error("dlbsHelpPageTemplate:addSubsystemImage:InvalidInputs", ...
                    "model_name and subsystem_name must be non-empty strings.");
            end

            % Support either model name or .slx path by normalizing to loaded model name.
            model_load_target = model_name;
            [~, normalizedModelName, ext] = fileparts(model_name);
            if strcmpi(ext, ".slx")
                model_name = string(normalizedModelName);
            end

            subsystem_path = model_name + "/" + subsystem_name;

            image_name = string(image_name);
            if endsWith(image_name, ".svg", "IgnoreCase", true)
                image_name = extractBefore(image_name, strlength(image_name) - 3);
            end
            image_file_name = obj.document_basename + "_" + image_name + ".svg";
            subsystemImagePath = fullfile(obj.tempdir_path, image_file_name);

            wasModelLoaded = bdIsLoaded(model_name);
            if ~wasModelLoaded
                % Load model without opening editor windows.
                load_system(model_load_target)
            end

            wasSubsystemOpen = strcmp(get_param(subsystem_path, "Open"), "on");

            try
                print(subsystemImagePath, "-dsvg", "-s" + subsystem_path);
            catch ME
                if ~wasSubsystemOpen
                    close_system(subsystem_path)
                end
                if ~wasModelLoaded && bdIsLoaded(model_name)
                    close_system(model_name,0)
                end
                rethrow(ME)
            end

            if ~wasSubsystemOpen
                close_system(subsystem_path)
            end
            if ~wasModelLoaded && bdIsLoaded(model_name)
                close_system(model_name,0)
            end

            obj.lines = [obj.lines; sprintf("%% <html><img src=""%s""/></html>", image_file_name); "%"];

        end

        function text = internalLink(~, url, display_text)
            text = sprintf("<matlab:web('%s.html') %s>", url, display_text);
        end

        function addList(obj, varargin)
            for item = [varargin{:}]
                obj.lines = [obj.lines; sprintf("%% * %s", item)];
            end
            obj.lines = [obj.lines; "%"];
        end

        function previewSrc(obj)
            for line = obj.lines'
                disp(line);
            end
        end

        function render(obj)
            assert(~isempty(obj.tempdir_path) && exist(obj.tempdir_path, 'dir'), ...
                "dlbsHelpBlockdlbsHelpPageTemplate:render:MissingTempDir", ...
                "Temporary directory does not exist.");

            m_file_name = obj.document_basename + ".m";
            m_path = fullfile(obj.tempdir_path, m_file_name);
            tempfile_fid = fopen(m_path, "w");

            if tempfile_fid < 0
                error("dlbsHelpBlockdlbsHelpPageTemplate:render:FileOpenFailed", ...
                    "Could not create preview file: %s", m_path);
            end

            try
                for line = obj.lines'
                    fprintf(tempfile_fid, "%s\n", line);
                end
                fclose(tempfile_fid);
            catch ME
                fclose(tempfile_fid);
                rethrow(ME)
            end

            publish(m_path, ...
                "format", "html", ...
                "outputDir", obj.tempdir_path, ...
                "showCode", false, ...
                "evalCode", false);

        end

        function preview(obj)
            html_path = fullfile(obj.tempdir_path, obj.document_basename + ".html");

            if ~exist(html_path, 'file')
                obj.render();
            end

            pause(0.5); % Wait a moment to ensure the file system has updated
            web(html_path);
        end

    end
end