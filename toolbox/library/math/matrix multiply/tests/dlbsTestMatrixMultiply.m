classdef dlbsTestMatrixMultiply < dlbsAbstractHarnessTest


    methods (Test)

        function testCalc(testCase)
            % Fix the seed of the random number generator
            rng(0);

            % Setup inputs for 3x3 * 3x3 add
            inputs.X = randn(4,3);
            inputs.W = randn(3,2);
            inputs.dY = randn(4,2);

            % Simulate the model
            testCase.setHarness("dlbsTestHarnessMatrixMultiply");
            testCase.harness = testCase.harness.setVariable('X',  inputs.X);
            testCase.harness = testCase.harness.setVariable('W',  inputs.W);
            testCase.harness = testCase.harness.setVariable('dY',  inputs.dY);
            simout = sim(testCase.harness);
            output.Y = simout.Y.Data;
            output.dX = simout.dX.Data;
            output.dW = simout.dW.Data;

            % Check against PyTorch
            torch = py.importlib.import_module('torch');
            np = py.importlib.import_module('numpy');

            t.X = torch.tensor(inputs.X,requires_grad=true);
            t.W = torch.tensor(inputs.W,requires_grad=true);
            t.dY = torch.tensor(inputs.dY);
            t.Y = torch.matmul(t.X,t.W);
            t.Y.backward(t.dY);

            expected.Y = double(np.array(t.Y.tolist()));
            expected.dX = double(np.array(t.X.grad.tolist()));
            expected.dW = double(np.array(t.W.grad.tolist()));

            % Verify
            testCase.verifyEqual(output.Y,expected.Y,"RelTol",100*eps());
            testCase.verifyEqual(output.dX,expected.dX,"RelTol",100*eps());
            testCase.verifyEqual(output.dW,expected.dW,"RelTol",100*eps());
        end

    end

end
