function packageToolbox(varargin)

p = inputParser();
p.addRequired('version', @(x) ~isempty(regexp(x, "^[0-9]*\.[0-9]*\.[0-9]*$", "once")));
p.addParameter('runTests', true, @islogical);
p.addParameter('buildDocuments', true, @islogical);
p.addParameter('package', true, @islogical);
p.addParameter('outputFolder', dlbs.rootPath(), @(x) ...
	(ischar(x) || (isstring(x) && isscalar(x))) && ...
	(strlength(string(x)) == 0 || isfolder(char(x))));


p.parse(varargin{:});

% generated with java.util.UUID.randomUUID().toString 
% This MUST never change, until you want to publish a fork on Matlab File Exchange, then you MUST generate a new UUID to avoid conflicts with the original toolbox
uuid = "a22508c7-b8e0-49ed-ae50-fbf1dc7a0cf6";


version = p.Results.version;
runTests = p.Results.runTests;
buildDocuments = p.Results.buildDocuments;
package = p.Results.package;
outputFolder = string(p.Results.outputFolder);


toolboxFolder = fullfile(dlbs.rootPath,"toolbox");
opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder, uuid);

% Toolbox
opts.ToolboxName = "Deep Learning Block Set";
opts.ToolboxVersion = version;
opts.Description = "Description";
opts.Summary = "Summary";
opts.ToolboxImageFile = fullfile(dlbs.rootPath, "docs", "dlbsIcon.png");

% Author
opts.AuthorName = "Alexander Oerder";
opts.AuthorEmail = "alexander.oerder@kit.edu";
opts.AuthorCompany = "Karlsruhe Institute of Technology";

% Support
opts.SupportedPlatforms.Win64 = true;
opts.SupportedPlatforms.Maci64 = true;
opts.SupportedPlatforms.Glnxa64 = true;
opts.SupportedPlatforms.MatlabOnline = true;
opts.MinimumMatlabRelease = "R2025b";
opts.MaximumMatlabRelease = "";

% Packaging Configuration
opts.OutputFile = fullfile(outputFolder, strrep(opts.ToolboxName," ","-")+"-"+opts.ToolboxVersion);

% Run tests
if runTests
	dlbs.checkPyEnv();
	results = runtests(toolboxFolder, "IncludeSubfolders", true);
	failed = [results.Failed];
	incomplete = [results.Incomplete];
	if any(failed) || any(incomplete)
		failedCount = nnz(failed);
		incompleteCount = nnz(incomplete);
		error("dlbs:package:TestsFailed", ...
			"Toolbox tests failed before packaging (Failed: %d, Incomplete: %d).", ...
			failedCount, incompleteCount);
	end
end

% Create Docu
if buildDocuments
    dlbs.publishHelp();
end

% Included files
toolboxFiles = [ ...
	matlab.buildtool.io.FileCollection.fromPaths(fullfile(toolboxFolder, "library", "**", "dlbsBlock*.slx")).paths, ...
	matlab.buildtool.io.FileCollection.fromPaths(fullfile(toolboxFolder, "library", "**", "dlbsSubsystem*.slx")).paths, ...
	matlab.buildtool.io.FileCollection.fromPaths(fullfile(toolboxFolder, "library", "**", "dlbsMask*.m")).paths, ...
	fullfile(toolboxFolder, "library", "dlbs.slx"), ...
	fullfile(toolboxFolder, "library", "slblocks.m"), ...
	fullfile(toolboxFolder, "info.xml"), ...
	fullfile(toolboxFolder, "examples"), ...
	fullfile(toolboxFolder, "html") ...
];
opts.ToolboxFiles = toolboxFiles;

% Package
if package
    matlab.addons.toolbox.packageToolbox(opts);
end

end

