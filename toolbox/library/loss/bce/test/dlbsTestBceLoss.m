classdef dlbsTestBceLoss < dlbsAbstractHarnessTest

    methods (Test)

        function testCalc(testCase)
            % Fix the seed of the random number generator
            rng(0);

            % Setup Inputs
            inputs.Y= rand(3,3);
            inputs.Y_ref =  rand(3,3);

            % Simulate the model
            testCase.setHarness("dlbsTestHarnessBceLoss");
            testCase.harness = testCase.harness.setVariable('Y',  inputs.Y);
            testCase.harness = testCase.harness.setVariable('Y_ref',  inputs.Y_ref);
            simout = sim(testCase.harness);
            output.L = simout.L.Data;
            output.dY = simout.dY.Data;
            output.dY_ref = simout.dY_ref.Data;

            % Check against PyTorch
            torch = py.importlib.import_module('torch');
            np = py.importlib.import_module('numpy');

            t.Y  = torch.tensor(inputs.Y,requires_grad=true);
            t.Y_ref = torch.tensor(inputs.Y_ref, requires_grad=true);
            t.L = torch.nn.functional.binary_cross_entropy(t.Y, t.Y_ref);
            t.L.backward();
            t.dY = t.Y.grad;
            t.dY_ref = t.Y_ref.grad;

            expected.L  = double(np.array(t.L.tolist()));
            expected.dY = double(np.array(t.dY.tolist()));
            expected.dY_ref = double(np.array(t.dY_ref.tolist()));

            % Verify
            testCase.verifyEqual(output.L,expected.L, "RelTol", 1e-6);
            testCase.verifyEqual(output.dY,expected.dY, "RelTol", 1e-6);
            testCase.verifyEqual(output.dY_ref,expected.dY_ref, "RelTol", 1e-6);
        end
    end

end