% dlbsTestSplit
% Validates split forward/backward behavior for 2, 3, and 4 outputs using
% dlbsTestHarnessSplit2/3/4 where input gradient is the sum of dY ports.
classdef dlbsTestSplit < dlbsAbstractHarnessTest

    methods (Test)

        function testCalc2Outputs(testCase)
            dlbsTestSplit.runCase(testCase, 2);
        end

        function testCalc3Outputs(testCase)
            dlbsTestSplit.runCase(testCase, 3);
        end

        function testCalc4Outputs(testCase)
            dlbsTestSplit.runCase(testCase, 4);
        end
    end

    methods (Static, Access = private)

        function runCase(testCase, nOut)
            allDims = randi([1, 4]);
            shapeX = randi([1, 8], 1, allDims);

            inputs = struct;
            inputs.X = dlbsTestSplit.randTensor(shapeX, allDims);
            for i = 1:nOut
                inputs.("dY" + i) = dlbsTestSplit.randTensor(shapeX, allDims);
            end

            expected.dX = zeros(size(inputs.X));
            for i = 1:nOut
                expected.dX = expected.dX + inputs.("dY" + i);
                expected.("Y" + i) = inputs.X;
            end

            testCase.setHarness("dlbsTestHarnessSplit" + nOut);
            testCase.harness = testCase.harness.setVariable('X', inputs.X);
            for i = 1:nOut
                testCase.harness = testCase.harness.setVariable(char("dY" + i), inputs.("dY" + i));
            end

            simout = sim(testCase.harness);
            output.dX = simout.dX.Data;
            for i = 1:nOut
                output.("Y" + i) = simout.("Y" + i).Data;
            end

            % Shape checks: X must match dX, and each Yi must match dYi.
            testCase.verifyEqual(size(output.dX), size(inputs.X));
            for i = 1:nOut
                testCase.verifyEqual(size(output.("Y" + i)), size(inputs.("dY" + i)));
            end

            testCase.verifyEqual(output.dX, expected.dX);
            for i = 1:nOut
                testCase.verifyEqual(output.("Y" + i), expected.("Y" + i));
            end
        end

        function x = randTensor(shapeVec, allDims)
            if allDims == 1
                x = randn(shapeVec(1), 1);
            else
                x = randn(shapeVec);
            end
        end
    end
end
