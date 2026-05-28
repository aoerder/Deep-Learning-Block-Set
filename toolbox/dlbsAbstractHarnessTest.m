classdef (Abstract) dlbsAbstractHarnessTest < matlab.unittest.TestCase

    properties
        harness
    end

    methods
        function setHarness(testCase, harnessName)
            harness = Simulink.SimulationInput(char(harnessName));
            harness = harness.setModelParameter( ...
                'Solver','FixedStepDiscrete', ...
                'FixedStep','1', ...
                'StartTime','0', ...
                'StopTime','1');
            testCase.harness = harness;
        end
    end


end