classdef dlbsTestRelu < dlbsAbstractHarnessTest

    methods (Test)

        function testCalc(testCase)
            % Fix the seed of the random number generator
            rng(0);

            % Setup inputs for element-wise ReLU
            inputs.X = randn(3,3);
            inputs.dY = randn(3,3);

            % Simulate the model
            testCase.setHarness("dlbsTestHarnessRelu");
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
            t.Y = torch.relu(t.X);
            t.Y.backward(t.dY);

            expected.Y = double(np.array(t.Y.tolist()));
            expected.dX = double(np.array(t.X.grad.tolist()));

            % Verify
            testCase.verifyEqual(output.Y,expected.Y);
            testCase.verifyEqual(output.dX,expected.dX);
        end
    end

end
