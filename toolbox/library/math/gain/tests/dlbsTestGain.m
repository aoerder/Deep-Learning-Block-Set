classdef dlbsTestGain < dlbsAbstractHarnessTest


    methods (Test)

        function testCalc(testCase)
            % Fix the seed of the random number generator
            rng(0);

            % Setup Inputs
            inputs.X=randn(3,3);
            inputs.dY=randn(3,3);
            constants.g=randn();

            % Simulate the model
            testCase.setHarness("dlbsTestHarnessGain");
            testCase.harness = testCase.harness.setVariable('X',  inputs.X);
            testCase.harness = testCase.harness.setVariable('dY',  inputs.dY);
            testCase.harness = testCase.harness.setVariable('g',  constants.g);
            simout = sim(testCase.harness);
            output.Y = simout.Y.Data;
            output.dX = simout.dX.Data;

            % check against PyTorch
            torch = py.importlib.import_module('torch');
            np = py.importlib.import_module('numpy');

            t.X  = torch.tensor(inputs.X,requires_grad=true);
            t.dY = torch.tensor(inputs.dY);
            t.Y = t.X*constants.g;
            t.Y.backward(t.dY);
            t.dX = t.X.grad;

            expected.Y  = double(np.array(t.Y.tolist()));
            expected.dX = double(np.array(t.dX.tolist()));

            % Verify
            testCase.verifyEqual(output.Y,expected.Y);
            testCase.verifyEqual(output.dX,expected.dX);
        end
    end

end