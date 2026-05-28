function initPath()
rootpath = dlbs.rootPath();

% Zurücksetzen der Elemente aus den Ordnerpfaden.
% Dabei werden temporär Warnings zurückgesetzt.
warning_DirNotFound_setting = warning("query","MATLAB:rmpath:DirNotFound");
warning("off","MATLAB:rmpath:DirNotFound");
rmpath(genpath(rootpath));
warning(warning_DirNotFound_setting.state,"MATLAB:rmpath:DirNotFound");

% Diesen Ordner rekursiv hinzufügen
pathsToAdd=genpath(fullfile(rootpath,"toolbox"));
pathsToAdd=strsplit(string(pathsToAdd),";");
pathsToAdd(contains(pathsToAdd,"slprj")) = []; %slprj-Ordner ignorieren
pathsToAdd(contains(pathsToAdd,"hdlsrc")) = []; %hdlsrc-Ordner ignorieren
pathsToAdd(contains(pathsToAdd,"__pycache__")) = []; %hdlsrc-Ordner ignorieren
pathsToAdd=strjoin(pathsToAdd,";");
addpath(pathsToAdd);
addpath(rootpath);
addpath(fullfile(rootpath,"docs"));
end
