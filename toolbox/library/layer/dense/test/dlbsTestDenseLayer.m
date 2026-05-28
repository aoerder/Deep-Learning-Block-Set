classdef dlbsTestDenseLayer < dlbsAbstractHarnessTest


    methods (Test)

        function testCalc(testCase)
            % Fix the seed of the random number generator
            rng(0);

            % Run Python reference and reuse exactly the same tensors in Simulink
            np = py.importlib.import_module('numpy');
            torchRef = py.importlib.import_module('dlbsTestDenseLayerTorch');
            torchRef = py.importlib.reload(torchRef);
            torchOut = torchRef.calc();

            inputs.X = double(np.array(torchOut{1}));
            inputs.dY = double(np.array(torchOut{4}));
            inputs.W = double(np.array(torchOut{5}))';
            inputs.b = double(np.array(torchOut{7}));

            expected.dX = double(np.array(torchOut{2}));
            expected.Y = double(np.array(torchOut{3}));
            expected.dW = double(np.array(torchOut{6}))';
            expected.db = double(np.array(torchOut{8}));

            % Simulate the model
            testCase.setHarness("dlbsTestHarnessDenseLayer");
            testCase.harness = testCase.harness.setVariable('X',  inputs.X);
            testCase.harness = testCase.harness.setVariable('W',  inputs.W);
            testCase.harness = testCase.harness.setVariable('b',  inputs.b);
            testCase.harness = testCase.harness.setVariable('dY',  inputs.dY);
            simout = sim(testCase.harness);
            output.Y = simout.Y.Data;
            output.dX = simout.dX.Data;
            output.dW = simout.dW.Data;
            output.db = simout.db.Data;

            % Verify
            testCase.verifyEqual(output.Y,expected.Y,"RelTol",1e-6);
            testCase.verifyEqual(output.dX,expected.dX,"RelTol",1e-6);
            testCase.verifyEqual(output.dW,expected.dW,"RelTol",1e-6);
            testCase.verifyEqual(output.db,expected.db,"RelTol",1e-6);
        end

    end

end
