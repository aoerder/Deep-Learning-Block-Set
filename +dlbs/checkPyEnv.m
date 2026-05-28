function checkPyEnv()
    % check if currenty python environment features torch and numpy
    try
        py.importlib.import_module("torch");
        py.importlib.import_module("numpy");
    catch
        error("Python environment does not feature torch and numpy. Run dlbs.activatePyVenv() to activate the virtual environment set up with dlbs.createPyVenv().");
    end 
end