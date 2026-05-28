classdef dlbsTestSum < dlbsAbstractHarnessTest

    methods (Test)

        function testCalc(testCase)
            % Fix the seed of the random number generator
            rng(0);

            % Setup inputs for sum over all dimensions
            inputs.X = randn(3,3);
            inputs.dY = randn();

            % Simulate the model
            testCase.setHarness("dlbsTestHarnessSum");
            testCase.harness = testCase.harness.setVariable('X',  inputs.X);
            testCase.harness = testCase.harness.setVariable('dY',  inputs.dY);
            simout = sim(testCase.harness);
            output.Y = simout.Y.Data;
            output.dX = simout.dX.Data;

            % Check against PyTorch
            torch = py.importlib.import_module('torch');
            np = py.importlib.import_module('numpy');

            t.X = torch.tensor(inputs.X,requires_grad=true);
            t.dY = torch.tensor(inputs.dY);
            t.Y = torch.sum(t.X);
            t.Y.backward(t.dY);

            expected.Y = double(np.array(t.Y.tolist()));
            expected.dX = double(np.array(t.X.grad.tolist()));

            % Verify
            testCase.verifyEqual(output.Y,expected.Y,"RelTol",1e-7);
            testCase.verifyEqual(output.dX,expected.dX,"RelTol",1e-7);
        end
    end

end
