classdef dlbsTestProduct < dlbsAbstractHarnessTest


    methods (Test)

        function testCalc(testCase)
            % Fix the seed of the random number generator
            rng(0);

            % Setup inputs for 3x3 * 3x3 add
            inputs.X1 = randn(3,3);
            inputs.X2 = randn(3,3);
            inputs.dY = randn(3,3);

            % Simulate the model
            testCase.setHarness("dlbsTestHarnessProduct");
            testCase.harness = testCase.harness.setVariable('X1',  inputs.X1);
            testCase.harness = testCase.harness.setVariable('X2',  inputs.X2);
            testCase.harness = testCase.harness.setVariable('dY',  inputs.dY);
            simout = sim(testCase.harness);
            output.Y = simout.Y.Data;
            output.dX1 = simout.dX1.Data;
            output.dX2 = simout.dX2.Data;

            % Check against PyTorch
            torch = py.importlib.import_module('torch');
            np = py.importlib.import_module('numpy');

            t.X1 = torch.tensor(inputs.X1,requires_grad=true);
            t.X2 = torch.tensor(inputs.X2,requires_grad=true);
            t.dY = torch.tensor(inputs.dY);
            t.Y = t.X1 * t.X2;
            t.Y.backward(t.dY);

            expected.Y = double(np.array(t.Y.tolist()));
            expected.dX1 = double(np.array(t.X1.grad.tolist()));
            expected.dX2 = double(np.array(t.X2.grad.tolist()));

            % Verify
            testCase.verifyEqual(output.Y,expected.Y);
            testCase.verifyEqual(output.dX1,expected.dX1);
            testCase.verifyEqual(output.dX2,expected.dX2);
        end

    end

end
